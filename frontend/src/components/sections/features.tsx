import { Globe, Heart, Lock, Share2, Star, Zap } from "lucide-react";
import { motion } from "motion/react";

const features = [
  {
    icon: Share2,
    title: "Współdzielenie z partnerem",
    desc: "Połącz swój kalendarz z partnerem za pomocą unikalnego kodu. Wasze cykle i predykcje są zawsze widoczne dla Was obojga.",
  },
  {
    icon: Zap,
    title: "Synchronizacja na żywo",
    desc: "Zaznacz dzień na swoim telefonie – partner widzi go natychmiast. Żadnego opóźnienia, żadnej ręcznej aktualizacji.",
  },
  {
    icon: Star,
    title: "Inteligentne predykcje",
    desc: "Algorytm uczy się Twojego cyklu i z czasem staje się coraz dokładniejszy. Przewiduje owulację, okno płodne i następną miesiączkę.",
  },
  {
    icon: Globe,
    title: "Dane w UE, open source",
    desc: "Cały kod jest jawny i dostępny na GitHubie. Twoje dane przechowywane są na serwerach w Unii Europejskiej, zgodnie z RODO.",
  },
  {
    icon: Lock,
    title: "Zero opłat, zero subskrypcji",
    desc: "Aplikacja jest w pełni darmowa. Żadnych płatności, subskrypcji, ukrytych opłat ani reklam. Otwarte oprogramowanie dla każdego.",
  },
  {
    icon: Heart,
    title: "Pełna kontrola nad danymi",
    desc: "Możesz samodzielnie hostować cały system (backend + baza danych) za pomocą Docker Compose. Twoje dane, Twoje zasady.",
  },
];

export function Features() {
  return (
    <section id="funkcje" className="scroll-mt-20 px-3 py-14 sm:py-20">
      <motion.div
        initial={{ opacity: 0, y: 20 }}
        whileInView={{ opacity: 1, y: 0 }}
        viewport={{ once: true, margin: "-100px" }}
        transition={{ duration: 0.6 }}
        className="mx-auto max-w-5xl"
      >
        <h2 className="mb-3 text-center text-2xl font-bold text-gray-900 sm:text-4xl">
          Wszystko, czego potrzebujesz
        </h2>
        <p className="mx-auto mb-10 max-w-lg text-center text-sm text-gray-600 sm:text-base">
          Okresownik łączy w sobie prostotę użytkowania z zaawansowanymi funkcjami, które docenisz
          Ty i Twój partner.
        </p>
        <div className="grid gap-3 sm:grid-cols-2 sm:gap-6 lg:grid-cols-3">
          {features.map((feature) => (
            <div
              key={feature.title}
              className="rounded-2xl border border-pink-100 bg-white p-3 shadow-sm sm:p-6"
            >
              <div className="text-primary mb-3 flex size-9 items-center justify-center rounded-xl bg-pink-50 sm:size-12">
                <feature.icon className="size-4 sm:size-6" />
              </div>
              <h3 className="mb-1.5 text-sm font-semibold text-gray-900 sm:text-lg">
                {feature.title}
              </h3>
              <p className="text-xs leading-relaxed text-gray-600 sm:text-sm">{feature.desc}</p>
            </div>
          ))}
        </div>
      </motion.div>
    </section>
  );
}
