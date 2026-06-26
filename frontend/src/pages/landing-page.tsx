import type { JSX } from "react";

import { Cta } from "@/components/sections/cta";
import { Download } from "@/components/sections/download";
import { Features } from "@/components/sections/features";
import { Footer } from "@/components/sections/footer";
import { GitHubSection } from "@/components/sections/github-section";
import { Header } from "@/components/sections/header";
import { Hero } from "@/components/sections/hero";

export function LandingPage(): JSX.Element {
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
