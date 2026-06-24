import { ChevronRight, Globe, Heart, Lock, Mail, Share2, Smartphone, Star, Zap } from 'lucide-react'
import { motion } from 'motion/react'
import type { JSX } from 'react'
import { Button } from '@/components/ui/button'

function GitHubIcon({ className }: { className?: string }) {
  return (
    <svg className={className} viewBox="0 0 24 24" fill="currentColor" aria-hidden="true">
      <path d="M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0 0 24 12c0-6.63-5.37-12-12-12z" />
    </svg>
  )
}

const features = [
  {
    icon: Share2,
    title: 'Współdzielenie z partnerem',
    desc: 'Połącz swój kalendarz z partnerem za pomocą unikalnego kodu. Wasze cykle i predykcje są zawsze widoczne dla Was obojga.',
  },
  {
    icon: Zap,
    title: 'Synchronizacja na żywo',
    desc: 'Zaznacz dzień na swoim telefonie – partner widzi go natychmiast. Żadnego opóźnienia, żadnej ręcznej aktualizacji.',
  },
  {
    icon: Star,
    title: 'Inteligentne predykcje',
    desc: 'Algorytm uczy się Twojego cyklu i z czasem staje się coraz dokładniejszy. Przewiduje owulację, okno płodne i następną miesiączkę.',
  },
  {
    icon: Globe,
    title: 'Dane w UE, open source',
    desc: 'Cały kod jest jawny i dostępny na GitHubie. Twoje dane przechowywane są na serwerach w Unii Europejskiej, zgodnie z RODO.',
  },
  {
    icon: Lock,
    title: 'Zero opłat, zero subskrypcji',
    desc: 'Aplikacja jest w pełni darmowa. Żadnych płatności, subskrypcji, ukrytych opłat ani reklam. Otwarte oprogramowanie dla każdego.',
  },
  {
    icon: Heart,
    title: 'Pełna kontrola nad danymi',
    desc: 'Możesz samodzielnie hostować cały system (backend + baza danych) za pomocą Docker Compose. Twoje dane, Twoje zasady.',
  },
]

function App(): JSX.Element {
  return (
    <div className="min-h-screen bg-gradient-to-b from-surface via-white to-white">
      {/* Nav */}
      <motion.header
        initial={{ opacity: 0, y: -20 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.6 }}
        className="sticky top-0 z-50 border-b border-pink-100 bg-white/80 backdrop-blur-md"
      >
        <div className="mx-auto flex max-w-5xl items-center justify-between px-4 py-3">
          <div className="flex items-center gap-2">
            <Heart className="size-6 text-primary" />
            <span className="text-lg font-semibold text-gray-900">Okresownik</span>
          </div>
          <nav className="hidden items-center gap-6 text-sm text-gray-600 sm:flex">
            <a href="#funkcje" className="hover:text-primary transition-colors">
              Funkcje
            </a>
            <a href="#pobierz" className="hover:text-primary transition-colors">
              Pobierz
            </a>
            <a href="#kontakt" className="hover:text-primary transition-colors">
              Kontakt
            </a>
          </nav>
          <a
            href="https://github.com/kguzek/okresownik"
            target="_blank"
            rel="noopener noreferrer"
            className="text-gray-600 hover:text-primary transition-colors"
          >
            <GitHubIcon className="size-5" />
          </a>
        </div>
      </motion.header>

      <main>
        {/* Hero */}
        <section className="relative overflow-hidden px-4 pt-20 pb-16 sm:pt-28 sm:pb-24">
          <div className="absolute inset-0 -z-10">
            <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,_var(--tw-gradient-stops))] from-pink-100/40 via-transparent to-transparent" />
          </div>
          <motion.div
            initial={{ opacity: 0, y: 40 }}
            animate={{ opacity: 1, y: 0 }}
            transition={{ duration: 0.7, delay: 0.2 }}
            className="mx-auto max-w-3xl text-center"
          >
            <div className="mb-6 inline-flex items-center gap-2 rounded-full bg-pink-100 px-4 py-1.5 text-sm text-primary">
              <Heart className="size-4 fill-primary" />
              Otwarte oprogramowanie
            </div>
            <h1 className="mb-6 text-4xl font-bold tracking-tight text-gray-900 sm:text-5xl md:text-6xl">
              Śledź swój cykl{' '}
              <span className="bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent">
                z partnerem
              </span>
            </h1>
            <p className="mx-auto mb-10 max-w-xl text-lg leading-relaxed text-gray-600">
              Okresownik to darmowy, otwartoźródłowy kalendarzyk menstruacyjny z synchronizacją na
              żywo. Żadnych opłat, żadnych subskrypcji. Dane przechowywane w UE.
            </p>
            <div className="flex flex-col items-center gap-4 sm:flex-row sm:justify-center">
              <Button asChild size="lg">
                <a href="#pobierz">
                  <Smartphone className="size-5" />
                  Pobierz aplikację
                </a>
              </Button>
              <Button asChild variant="outline" size="lg">
                <a href="#funkcje">
                  Poznaj funkcje
                  <ChevronRight className="size-5" />
                </a>
              </Button>
            </div>
          </motion.div>
        </section>

        {/* Features */}
        <section id="funkcje" className="scroll-mt-20 px-4 py-20">
          <motion.div
            initial={{ opacity: 0 }}
            whileInView={{ opacity: 1 }}
            viewport={{ once: true, margin: '-100px' }}
            transition={{ duration: 0.6 }}
            className="mx-auto max-w-5xl"
          >
            <h2 className="mb-4 text-center text-3xl font-bold text-gray-900 sm:text-4xl">
              Wszystko, czego potrzebujesz
            </h2>
            <p className="mx-auto mb-14 max-w-lg text-center text-gray-600">
              Okresownik łączy w sobie prostotę użytkowania z zaawansowanymi funkcjami, które
              docenisz Ty i Twój partner.
            </p>
            <div className="grid gap-6 sm:grid-cols-2 lg:grid-cols-3">
              {features.map((feature, i) => (
                <motion.div
                  key={feature.title}
                  initial={{ opacity: 0, y: 30 }}
                  whileInView={{ opacity: 1, y: 0 }}
                  viewport={{ once: true, margin: '-50px' }}
                  transition={{ duration: 0.5, delay: i * 0.08 }}
                  className="group rounded-2xl border border-pink-100 bg-white p-6 shadow-sm transition-all duration-300 hover:shadow-lg hover:border-pink-200 hover:-translate-y-1"
                >
                  <div className="mb-4 flex size-12 items-center justify-center rounded-xl bg-pink-50 text-primary transition-colors group-hover:bg-primary group-hover:text-white">
                    <feature.icon className="size-6" />
                  </div>
                  <h3 className="mb-2 text-lg font-semibold text-gray-900">{feature.title}</h3>
                  <p className="text-sm leading-relaxed text-gray-600">{feature.desc}</p>
                </motion.div>
              ))}
            </div>
          </motion.div>
        </section>

        {/* Download */}
        <section
          id="pobierz"
          className="scroll-mt-20 bg-gradient-to-b from-pink-50/50 to-white px-4 py-20"
        >
          <motion.div
            initial={{ opacity: 0, y: 40 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.6 }}
            className="mx-auto max-w-3xl text-center"
          >
            <h2 className="mb-4 text-3xl font-bold text-gray-900 sm:text-4xl">
              Pobierz Okresownik
            </h2>
            <p className="mb-12 text-gray-600">
              Aplikacja nie jest jeszcze publicznie dostępna, ale możesz już teraz zapisać się do
              programu alpha i przetestować ją jako pierwszy.
            </p>
            <div className="mx-auto mb-14 grid max-w-md gap-6 sm:grid-cols-2">
              <div className="rounded-2xl border-2 border-dashed border-pink-200 bg-white p-8 text-center transition-all duration-300 hover:border-primary hover:shadow-md">
                <div className="mb-4 flex justify-center">
                  <div className="flex size-20 items-center justify-center rounded-2xl bg-gray-100">
                    <svg
                      className="size-10 text-gray-400"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      aria-hidden="true"
                    >
                      <path d="M17.523 16.435a10.52 10.52 0 0 0 2.358-6.109C14.254 10.48 9.48 5.72 9.48 0a10.516 10.516 0 0 0-6.11 2.358A10.52 10.52 0 0 0 9.48 8.484a10.52 10.52 0 0 0-6.11 2.358A10.52 10.52 0 0 0 9.48 16.97a10.52 10.52 0 0 0-2.358 6.109A10.52 10.52 0 0 0 9.48 20.72a10.52 10.52 0 0 0 2.358 2.358 10.52 10.52 0 0 0-2.358-6.109 10.52 10.52 0 0 0 6.109 2.358A10.52 10.52 0 0 0 17.523 16.435Z" />
                    </svg>
                  </div>
                </div>
                <h3 className="mb-2 text-lg font-semibold text-gray-900">Android</h3>
                <p className="mb-4 text-sm text-gray-500">Wkrótce dostępne</p>
                <span className="inline-block rounded-full bg-amber-50 px-3 py-1 text-xs font-medium text-amber-700">
                  Wczesny dostęp
                </span>
              </div>
              <div className="rounded-2xl border-2 border-dashed border-pink-200 bg-white p-8 text-center transition-all duration-300 hover:border-primary hover:shadow-md">
                <div className="mb-4 flex justify-center">
                  <div className="flex size-20 items-center justify-center rounded-2xl bg-gray-100">
                    <svg
                      className="size-10 text-gray-400"
                      viewBox="0 0 24 24"
                      fill="currentColor"
                      aria-hidden="true"
                    >
                      <path d="M17.05 20.28c-.98.95-2.05.8-3.08.35-1.09-.46-2.09-.48-3.24 0-1.44.62-2.2.44-3.06-.35C2.79 15.25 3.51 7.59 9.05 7.31c1.35.07 2.29.74 3.08.8 1.18-.24 2.31-.93 3.57-.84 1.51.12 2.65.72 3.4 1.8-3.12 1.87-2.38 5.98.48 7.13-.57 1.5-1.31 2.99-2.54 4.09zM12.03 7.25c-.15-2.23 1.66-4.07 3.74-4.25.29 2.58-2.34 4.5-3.74 4.25z" />
                    </svg>
                  </div>
                </div>
                <h3 className="mb-2 text-lg font-semibold text-gray-900">iOS</h3>
                <p className="mb-4 text-sm text-gray-500">Wkrótce dostępne</p>
                <span className="inline-block rounded-full bg-amber-50 px-3 py-1 text-xs font-medium text-amber-700">
                  Wczesny dostęp
                </span>
              </div>
            </div>
          </motion.div>
        </section>

        {/* CTA */}
        <section id="kontakt" className="scroll-mt-20 px-4 py-20">
          <motion.div
            initial={{ opacity: 0, scale: 0.95 }}
            whileInView={{ opacity: 1, scale: 1 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
            className="mx-auto max-w-2xl text-center"
          >
            <div className="rounded-3xl bg-gradient-to-br from-primary to-primary-dark p-10 sm:p-14">
              <Mail className="mx-auto mb-6 size-10 text-white/90" />
              <h2 className="mb-4 text-3xl font-bold text-white sm:text-4xl">
                Chcesz przetestować wersję alpha?
              </h2>
              <p className="mb-8 text-lg text-white/80">
                Jeżeli jesteś zainteresowany wczesnym dostępem do Okresownika, napisz do nas —
                udostępnimy Ci wersję alpha do przetestowania.
              </p>
              <Button
                asChild
                size="lg"
                className="bg-white text-primary hover:bg-white/90 hover:text-primary-dark"
              >
                <a href="mailto:kontakt@okresownik.pl">
                  <Mail className="size-5" />
                  Napisz: kontakt@okresownik.pl
                </a>
              </Button>
            </div>
          </motion.div>
        </section>

        {/* GitHub */}
        <section className="px-4 pb-20">
          <motion.div
            initial={{ opacity: 0, y: 20 }}
            whileInView={{ opacity: 1, y: 0 }}
            viewport={{ once: true }}
            transition={{ duration: 0.5 }}
            className="mx-auto max-w-2xl text-center"
          >
            <div className="rounded-2xl border border-gray-200 bg-white p-10 shadow-sm">
              <GitHubIcon className="mx-auto mb-4 size-10 text-gray-800" />
              <h2 className="mb-3 text-2xl font-bold text-gray-900">Otwarte oprogramowanie</h2>
              <p className="mb-6 text-gray-600">
                Kod źródłowy Okresownika jest w pełni jawny. Możesz go przeglądać, forkować,
                zgłaszać błędy i proponować zmiany.
              </p>
              <Button asChild variant="outline" size="lg">
                <a
                  href="https://github.com/kguzek/okresownik"
                  target="_blank"
                  rel="noopener noreferrer"
                >
                  <GitHubIcon className="size-5" />
                  github.com/kguzek/okresownik
                </a>
              </Button>
            </div>
          </motion.div>
        </section>
      </main>

      {/* Footer */}
      <footer className="border-t border-pink-100 bg-white px-4 py-8">
        <div className="mx-auto flex max-w-5xl flex-col items-center justify-between gap-4 text-sm text-gray-500 sm:flex-row">
          <p>
            &copy; {new Date().getFullYear()}{' '}
            <a
              href="https://guzek.uk"
              target="_blank"
              rel="noopener noreferrer"
              className="text-primary hover:underline"
            >
              Konrad Guzek
            </a>
            . Wszelkie prawa zastrzeżone.
          </p>
          <div className="flex items-center gap-4">
            <a
              href="https://github.com/kguzek/okresownik"
              target="_blank"
              rel="noopener noreferrer"
              className="hover:text-primary transition-colors"
            >
              GitHub
            </a>
            <a href="mailto:kontakt@okresownik.pl" className="hover:text-primary transition-colors">
              Kontakt
            </a>
          </div>
        </div>
      </footer>
    </div>
  )
}

export default App
