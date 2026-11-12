import { mkdir, writeFile } from "node:fs/promises";
import path from "node:path";

const url =
	process.env.BANGUMI_FEED_URL ||
	"https://bgm.tv/feed/user/luuton/interests";
const outFile = path.join(process.cwd(), "src", "data", "bangumi-feed.xml");
const headers = {
	"User-Agent":
		"Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120 Safari/537.36",
	Accept:
		"application/rss+xml, application/atom+xml, application/xml, text/xml, */*",
};
if (process.env.BANGUMI_COOKIE) {
	headers.Cookie = process.env.BANGUMI_COOKIE;
}

const controller = new AbortController();
const timer = setTimeout(() => controller.abort(), 20_000);

try {
	const response = await fetch(url, {
		headers,
		signal: controller.signal,
	});
	if (!response.ok) {
		throw new Error(`HTTP ${response.status} ${response.statusText}`);
	}
	const xml = await response.text();
	await mkdir(path.dirname(outFile), { recursive: true });
	await writeFile(outFile, xml, "utf8");
	console.log(
		`[bangumi] 已保存 ${xml.length} 字节到 ${path.relative(process.cwd(), outFile)}`,
	);
} finally {
	clearTimeout(timer);
}
