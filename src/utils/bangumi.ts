import { existsSync, readFileSync } from "node:fs";
import { fileURLToPath } from "node:url";
import { fallbackAnime } from "../data/anime-fallback";
import type { AnimeItem, AnimeStatus } from "../types/anime";

export const BANGUMI_FEED_URL =
	"https://bgm.tv/feed/user/luuton/interests";

const CACHE_PATH = fileURLToPath(
	new URL("../data/bangumi-feed.xml", import.meta.url),
);

const USER_AGENT =
	"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36";

/**
 * 构建时获取 Bangumi 收藏订阅。
 * 优先级：实时订阅 -> 本地缓存 XML -> 静态回退数据。
 */
let animeListCache: Promise<AnimeItem[]> | undefined;

export function getAnimeList(): Promise<AnimeItem[]> {
	return (animeListCache ??= loadAnimeList());
}

async function loadAnimeList(): Promise<AnimeItem[]> {
	const url = process.env.BANGUMI_FEED_URL || BANGUMI_FEED_URL;
	let xml = "";

	try {
		xml = await fetchFeed(url);
	} catch (error) {
		console.warn(
			`[bangumi] 订阅源不可用，尝试本地缓存：${formatError(error)}`,
		);
		if (existsSync(CACHE_PATH)) {
			xml = readFileSync(CACHE_PATH, "utf8");
		}
	}

	if (xml.trim()) {
		const parsed = parseBangumiFeed(xml);
		if (parsed.length > 0) {
			return mergeWithFallback(parsed);
		}
		console.warn("[bangumi] 订阅源没有解析到条目，使用静态回退数据。");
	}

	return fallbackAnime;
}

async function fetchFeed(url: string): Promise<string> {
	const controller = new AbortController();
	const timer = setTimeout(() => controller.abort(), 12_000);
	const headers: Record<string, string> = {
		"User-Agent": USER_AGENT,
		Accept:
			"application/rss+xml, application/atom+xml, application/xml, text/xml, */*",
	};
	if (process.env.BANGUMI_COOKIE) {
		headers.Cookie = process.env.BANGUMI_COOKIE;
	}

	try {
		const response = await fetch(url, {
			headers,
			signal: controller.signal,
		});
		if (!response.ok) {
			throw new Error(`HTTP ${response.status} ${response.statusText}`);
		}
		return await response.text();
	} finally {
		clearTimeout(timer);
	}
}

export function parseBangumiFeed(xml: string): AnimeItem[] {
	const blocks = Array.from(
		xml.matchAll(/<(item|entry)\b[^>]*>([\s\S]*?)<\/\1>/gi),
		(match) => match[2],
	);
	const seen = new Set<string>();
	const result: AnimeItem[] = [];

	for (const block of blocks) {
		const item = parseItem(block);
		if (!item) continue;
		const key = item.link || normalizeTitle(item.title);
		if (key && seen.has(key)) continue;
		if (key) seen.add(key);
		result.push(item);
	}

	return result;
}

function parseItem(block: string): AnimeItem | null {
	const rawTitle = getTag(block, ["title"]);
	if (!rawTitle) return null;

	const link = getLink(block);
	const html = getTag(block, [
		"content:encoded",
		"description",
		"summary",
		"content",
	]);
	const categories = getTags(block, "category");
	const pubDate = getTag(block, [
		"pubDate",
		"published",
		"updated",
		"dc:date",
	]);
	const text = htmlToText(html);
	const title = cleanTitle(rawTitle) || rawTitle;
	const status =
		detectStatus(`${rawTitle} ${categories.join(" ")}`) ??
		detectStatus(text) ??
		"planned";
	const { progress, totalEpisodes } = extractProgress(text);
	const year =
		extractYear(text) ||
		(pubDate ? String(new Date(pubDate).getFullYear()) : "");

	return {
		title,
		status,
		rating: extractRating(text),
		cover: extractCover(html, block),
		description: extractDescription(text),
		episodes:
			totalEpisodes > 0 ? `${totalEpisodes} episodes` : "",
		year,
		genre: extractGenre(text),
		studio: extractStudio(text),
		link,
		progress,
		totalEpisodes,
		startDate: "",
		endDate: "",
		updatedAt: pubDate ? formatDate(pubDate) : "",
		source: "bangumi",
	};
}

function mergeWithFallback(items: AnimeItem[]): AnimeItem[] {
	return items.map((item) => {
		const local = fallbackAnime.find((candidate) =>
			isSameAnime(candidate, item),
		);
		if (!local) return item;

		return {
			...local,
			...item,
			title: local.title,
			rating: item.rating || local.rating,
			cover: item.cover || local.cover,
			description: item.description || local.description,
			episodes: item.episodes || local.episodes,
			year: item.year || local.year,
			genre: item.genre.length > 0 ? item.genre : local.genre,
			studio: item.studio || local.studio,
			progress: item.progress || local.progress,
			totalEpisodes: item.totalEpisodes || local.totalEpisodes,
			startDate: item.startDate || local.startDate,
			endDate: item.endDate || local.endDate,
			aliases: local.aliases,
			link: item.link || local.link,
			status: item.status,
			updatedAt: item.updatedAt,
			source: "bangumi",
		};
	});
}

function isSameAnime(local: AnimeItem, item: AnimeItem): boolean {
	const itemKey = normalizeTitle(item.title);
	if (!itemKey) return false;

	return [local.title, ...(local.aliases ?? [])].some((candidate) => {
		const localKey = normalizeTitle(candidate);
		if (!localKey) return false;
		if (localKey === itemKey) return true;
		if (localKey.length < 4 || itemKey.length < 4) return false;
		return localKey.includes(itemKey) || itemKey.includes(localKey);
	});
}

function normalizeTitle(value: string): string {
	return value
		.toLowerCase()
		.replace(/[\s\p{P}\p{S}]/gu, "")
		.trim();
}

function cleanTitle(raw: string): string {
	let title = raw.replace(/\s+/g, " ").trim();
	title = title.replace(
		/^[^:：]{1,32}\s+(?=(?:在看|看过|想看|搁置|抛弃)\s)/,
		"",
	);
	title = title.replace(
		/^(?:在看|看过|想看|搁置|抛弃)\s*[：:\-]?\s*/,
		"",
	);
	title = title.replace(/^\[(?:在看|看过|想看|搁置|抛弃)\]\s*/, "");
	return title.trim();
}

function detectStatus(value: string): AnimeStatus | undefined {
	if (/(在看|追番中|watching|\bdo\b)/i.test(value)) return "watching";
	if (/(看过|看完|completed|\bcollect\b)/i.test(value)) return "completed";
	if (/(想看|计划|planned|\bwish\b)/i.test(value)) return "planned";
	if (/(搁置|on.?hold)/i.test(value)) return "on_hold";
	if (/(抛弃|dropped|\bdrop\b)/i.test(value)) return "dropped";
	return undefined;
}

function extractRating(text: string): number {
	const match =
		text.match(
			/(?:我的评分|评分|rating)\s*[：:]\s*([0-9]+(?:\.[0-9]+)?)/i,
		) ?? text.match(/(?:^|\s)([0-9]+(?:\.[0-9]+)?)\s*分(?:\s|$)/m);
	if (!match) return 0;
	const value = Number(match[1]);
	return Number.isFinite(value) && value > 0 && value <= 10 ? value : 0;
}

function extractProgress(text: string): {
	progress: number;
	totalEpisodes: number;
} {
	const match = text.match(
		/(?:看到|进度|episode|ep)\s*[：:]?\s*第?\s*(\d+)\s*(?:话|集)?(?:\s*\/\s*(?:全\s*)?(\d+)\s*(?:话|集)?)?/i,
	);
	const progress = match ? Number(match[1]) : 0;
	let totalEpisodes = match?.[2] ? Number(match[2]) : 0;

	if (!totalEpisodes) {
		const totalMatch = text.match(/(?:全|共)\s*(\d+)\s*(?:话|集)/);
		totalEpisodes = totalMatch ? Number(totalMatch[1]) : 0;
	}

	return {
		progress: Number.isFinite(progress) ? progress : 0,
		totalEpisodes: Number.isFinite(totalEpisodes) ? totalEpisodes : 0,
	};
}

function extractYear(text: string): string {
	const match = text.match(
		/(?:(\d{4})\s*年|（(\d{4})）|\((\d{4})\))/,
	);
	return match ? match[1] || match[2] || match[3] : "";
}

function extractStudio(text: string): string {
	const match = text.match(
		/(?:动画制作|制作|Studio)\s*[：:]\s*([^\n]+)/i,
	);
	return match ? match[1].trim().slice(0, 60) : "";
}

function extractGenre(text: string): string[] {
	const match = text.match(/(?:类型|标签|Genre)\s*[：:]\s*([^\n]+)/i);
	if (!match) return [];
	return match[1]
		.split(/[\/、,，]/)
		.map((value) => value.trim())
		.filter(Boolean)
		.slice(0, 6);
}

function extractDescription(text: string): string {
	const lines = text
		.split("\n")
		.map((line) => line.trim())
		.filter(Boolean)
		.filter(
			(line) =>
				!/(?:我的评分|评分|看到|进度|全\s*\d+\s*话|共\s*\d+\s*话|动画制作|制作\s*[：:]|类型\s*[：:]|标签\s*[：:])/.test(
					line,
				),
		);
	const description = lines.join(" ").replace(/\s+/g, " ").trim();
	return (description || text.replace(/\s+/g, " ").trim()).slice(0, 180);
}

function extractCover(html: string, block: string): string {
	const img = html.match(/<img\b[^>]*\bsrc=["']([^"']+)["']/i);
	const media = block.match(
		/<(?:media:thumbnail|media:content|enclosure)\b[^>]*\burl=["']([^"']+)["']/i,
	);
	const raw = img?.[1] ?? media?.[1] ?? "";
	if (!raw) return "";
	const src = decodeXml(raw);
	if (src.startsWith("//")) return `https:${src}`;
	if (src.startsWith("/")) return `https://bgm.tv${src}`;
	if (src.startsWith("http://")) return src.replace(/^http:\/\//, "https://");
	return src;
}

function getLink(block: string): string {
	const textLink = getTag(block, ["link"]);
	if (/^https?:\/\//i.test(textLink)) return textLink;

	const hrefs = Array.from(
		block.matchAll(/<link\b[^>]*\bhref=["']([^"']+)["']/gi),
		(match) => decodeXml(match[1]),
	);
	const subject = hrefs.find((href) => href.includes("/subject/"));
	const raw = subject ?? hrefs[0] ?? "";
	if (!raw) return "";
	if (raw.startsWith("//")) return `https:${raw}`;
	if (raw.startsWith("/")) return `https://bgm.tv${raw}`;
	if (raw.startsWith("http://")) return raw.replace(/^http:\/\//, "https://");
	return raw;
}

function getTag(block: string, names: string[]): string {
	for (const name of names) {
		const escaped = name.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
		const regex = new RegExp(
			`<${escaped}\\b[^>]*>([\\s\\S]*?)<\\/${escaped}>`,
			"i",
		);
		const match = block.match(regex);
		if (match) return decodeXml(match[1]).trim();
	}
	return "";
}

function getTags(block: string, name: string): string[] {
	return Array.from(
		block.matchAll(
			new RegExp(`<${name}\\b[^>]*>([\\s\\S]*?)<\\/${name}>`, "gi"),
		),
		(match) => decodeXml(match[1]).trim(),
	).filter(Boolean);
}

function htmlToText(html: string): string {
	return decodeXml(html)
		.replace(/<br\s*\/?>/gi, "\n")
		.replace(/<\/(?:p|div|li|h[1-6])>/gi, "\n")
		.replace(/<[^>]+>/g, " ")
		.replace(/[ \t]+/g, " ")
		.replace(/\n\s*\n+/g, "\n")
		.trim();
}

function decodeXml(value: string): string {
	return value
		.replace(/<!\[CDATA\[([\s\S]*?)\]\]>/g, "$1")
		.replace(/&lt;/g, "<")
		.replace(/&gt;/g, ">")
		.replace(/&quot;/g, '"')
		.replace(/&#39;|&apos;/g, "'")
		.replace(/&nbsp;/g, " ")
		.replace(/&amp;/g, "&")
		.replace(/&#x([0-9a-f]+);/gi, (_, hex: string) =>
			String.fromCodePoint(Number.parseInt(hex, 16)),
		)
		.replace(/&#(\d+);/g, (_, dec: string) =>
			String.fromCodePoint(Number.parseInt(dec, 10)),
		);
}

function formatDate(value: string): string {
	const date = new Date(value);
	if (Number.isNaN(date.getTime())) return value;
	return date.toISOString().slice(0, 10);
}

function formatError(error: unknown): string {
	return error instanceof Error ? error.message : String(error);
}
