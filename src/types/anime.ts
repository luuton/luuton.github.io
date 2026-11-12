export type AnimeStatus =
	| "watching"
	| "completed"
	| "planned"
	| "on_hold"
	| "dropped";

export interface AnimeItem {
	title: string;
	status: AnimeStatus;
	rating: number;
	cover: string;
	description: string;
	episodes: string;
	year: string;
	genre: string[];
	studio: string;
	link: string;
	progress: number;
	totalEpisodes: number;
	startDate: string;
	endDate: string;
	aliases?: string[];
	updatedAt?: string;
	source?: "fallback" | "bangumi";
}
