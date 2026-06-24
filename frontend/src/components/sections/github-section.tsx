import { motion } from "motion/react";

import { GitHubIcon } from "@/components/icons/github-icon";
import { Button } from "@/components/ui/button";

export function GitHubSection() {
  return (
    <section className="px-3 pb-14 sm:pb-20">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.5 }}
        className="mx-auto max-w-2xl text-center"
      >
        <div className="rounded-2xl border border-gray-200 bg-white p-4 shadow-sm sm:p-10">
          <GitHubIcon className="mx-auto mb-3 size-8 text-gray-800 sm:size-10" />
          <h2 className="mb-2 text-xl font-bold text-gray-900 sm:text-2xl">
            Otwarte oprogramowanie
          </h2>
          <p className="mb-4 text-sm text-gray-600 sm:text-base">
            Kod źródłowy Okresownika jest w pełni jawny. Możesz go przeglądać, forkować, zgłaszać
            błędy i proponować zmiany.
          </p>
          <Button asChild variant="outline">
            <a
              href="https://github.com/kguzek/okresownik"
              target="_blank"
              rel="noopener noreferrer"
              className="bg-white max-sm:px-4"
            >
              <GitHubIcon className="size-4" />
              <span className="truncate">github.com/kguzek/okresownik</span>
            </a>
          </Button>
        </div>
      </motion.div>
    </section>
  );
}
