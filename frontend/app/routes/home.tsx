import type { MetaFunction } from "react-router";

import { Cta } from "@/components/sections/cta";
import { Download } from "@/components/sections/download";
import { Features } from "@/components/sections/features";
import { Footer } from "@/components/sections/footer";
import { GitHubSection } from "@/components/sections/github-section";
import { Header } from "@/components/sections/header";
import { Hero } from "@/components/sections/hero";

export const meta: MetaFunction = () => [
  { title: "Okresownik — Śledź swój cykl z partnerem" },
  {
    name: "description",
    content:
      "Darmowy, otwartoźródłowy kalendarzyk menstruacyjny z synchronizacją z partnerem. Bez opłat, bez subskrypcji. Dane w UE.",
  },
];

export default function Home() {
  return (
    <div className="from-surface min-h-screen bg-gradient-to-b via-white to-white">
      <Header />
      <main>
        <Hero />
        <Features />
        <Download />
        <Cta />
        <GitHubSection />
      </main>
      <Footer />
    </div>
  );
}
