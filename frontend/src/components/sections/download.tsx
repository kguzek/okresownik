import { FlaskConical } from "lucide-react";
import { motion } from "motion/react";

import { Button } from "@/components/ui/button";

export function Download() {
  return (
    <section
      id="pobierz"
      className="scroll-mt-20 bg-gradient-to-b from-pink-50/50 to-white px-3 py-14 sm:py-20"
    >
      <motion.div
        initial={{ opacity: 0, y: 40 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true }}
        transition={{ duration: 0.6 }}
        className="mx-auto max-w-3xl text-center"
      >
        <h2 className="mb-3 text-2xl font-bold text-gray-900 sm:text-4xl">Pobierz Okresownik</h2>
        <p className="mb-8 text-sm text-gray-600 sm:text-base">
          Aplikacja wkrótce trafi do sklepów Google Play i App Store. Póki co możesz pobrać
          najnowszą wersję bezpośrednio z GitHub Releases.
        </p>
        <div className="mx-auto mb-10 grid max-w-md gap-3 sm:grid-cols-2 sm:gap-6">
          <div className="hover:border-primary rounded-2xl border-2 border-dashed border-pink-200 bg-white p-3 text-center transition-all duration-300 hover:shadow-md sm:p-8">
            <div className="mb-3 flex justify-center">
              <div className="flex size-14 items-center justify-center rounded-2xl bg-gray-100 sm:size-20">
                <svg
                  className="size-6 text-gray-400 sm:size-10"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                  aria-hidden="true"
                >
                  <path d="M17.523 16.435a10.52 10.52 0 0 0 2.358-6.109C14.254 10.48 9.48 5.72 9.48 0a10.516 10.516 0 0 0-6.11 2.358A10.52 10.52 0 0 0 9.48 8.484a10.52 10.52 0 0 0-6.11 2.358A10.52 10.52 0 0 0 9.48 16.97a10.52 10.52 0 0 0-2.358 6.109A10.52 10.52 0 0 0 9.48 20.72a10.52 10.52 0 0 0 2.358 2.358 10.52 10.52 0 0 0-2.358-6.109 10.52 10.52 0 0 0 6.109 2.358A10.52 10.52 0 0 0 17.523 16.435Z" />
                </svg>
              </div>
            </div>
            <h3 className="mb-1.5 text-sm font-semibold text-gray-900 sm:text-lg">Android</h3>
            <p className="mb-3 text-xs text-gray-500 sm:text-sm">Wkrótce w Google Play</p>
            <span className="inline-block rounded-full bg-amber-50 px-2 py-0.5 text-[10px] font-medium text-amber-700 sm:text-xs">
              Wczesny dostęp
            </span>
          </div>
          <div className="hover:border-primary rounded-2xl border-2 border-dashed border-pink-200 bg-white p-3 text-center transition-all duration-300 hover:shadow-md sm:p-8">
            <div className="mb-3 flex justify-center">
              <div className="flex size-14 items-center justify-center rounded-2xl bg-gray-100 sm:size-20">
                <svg
                  className="size-6 text-gray-400 sm:size-10"
                  viewBox="0 0 24 24"
                  fill="currentColor"
                  aria-hidden="true"
                >
                  <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z" />
                </svg>
              </div>
            </div>
            <h3 className="mb-1.5 text-sm font-semibold text-gray-900 sm:text-lg">iOS</h3>
            <p className="mb-3 text-xs text-gray-500 sm:text-sm">Wkrótce dostępne</p>
            <span className="inline-block rounded-full bg-amber-50 px-2 py-0.5 text-[10px] font-medium text-amber-700 sm:text-xs">
              Wczesny dostęp
            </span>
          </div>
        </div>
        <div className="mx-auto max-w-sm space-y-3">
          <p className="text-xs text-gray-500 sm:text-sm">
            Lub pobierz bezpośrednio z GitHub Releases:
          </p>
          <div className="rounded-xl border border-amber-200 bg-amber-50 p-2.5 text-left sm:p-4">
            <div className="flex items-start gap-2 sm:gap-3">
              <FlaskConical className="mt-0.5 size-4 shrink-0 text-amber-600 sm:size-5" />
              <div className="space-y-0.5">
                <p className="text-xs font-medium text-amber-800 sm:text-sm">
                  Wydanie eksperymentalne
                </p>
                <p className="text-[10px] leading-relaxed text-amber-700 sm:text-xs">
                  Te buildy są generowane automatycznie i udostępniane dla wygody.{" "}
                  <b>Mogą zawierać błędy i nie są przeznaczone do codziennego użytku</b>.
                </p>
              </div>
            </div>
          </div>
          <div className="flex items-center gap-2 max-sm:flex-col sm:justify-center sm:gap-3">
            <Button asChild>
              <a
                href="https://github.com/kguzek/okresownik/releases/latest/download/okresownik.apk"
                target="_blank"
                rel="noopener noreferrer"
              >
                Pobierz APK
              </a>
            </Button>
            <Button asChild variant="outline">
              <a
                href="https://github.com/kguzek/okresownik/releases/latest/download/okresownik.aab"
                target="_blank"
                rel="noopener noreferrer"
              >
                Pobierz AAB
              </a>
            </Button>
          </div>
        </div>
      </motion.div>
    </section>
  );
}
