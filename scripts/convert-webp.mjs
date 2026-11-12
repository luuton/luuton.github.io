import { readdir, unlink } from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import sharp from "sharp";

const root = path.resolve(path.dirname(fileURLToPath(import.meta.url)), "..");
const dir = path.join(root, "public", "images", "computer-network");
const keepPng = process.argv.includes("--keep");

const files = (await readdir(dir)).filter((f) => f.endsWith(".png")).sort();
if (files.length === 0) {
	console.log("No PNG files found.");
	process.exit(0);
}

for (const file of files) {
	const src = path.join(dir, file);
	const dst = path.join(dir, file.replace(/\.png$/i, ".webp"));
	const info = await sharp(src).webp({ quality: 82, effort: 6 }).toFile(dst);
	console.log(`${file} -> ${path.basename(dst)} (${(info.size / 1024).toFixed(1)} KiB)`);
	if (!keepPng) await unlink(src);
}
