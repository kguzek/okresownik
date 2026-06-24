import { ChevronRight, Heart, Smartphone } from 'lucide-react'
import { motion } from 'motion/react'
import { Button } from '@/components/ui/button'

export function Hero() {
  return (
    <section className="relative overflow-hidden px-3 pt-14 pb-12 sm:pt-28 sm:pb-24">
      <div className="absolute inset-0 -z-10">
        <div className="absolute inset-0 bg-[radial-gradient(ellipse_at_top_right,_var(--tw-gradient-stops))] from-pink-100/40 via-transparent to-transparent" />
      </div>
      <motion.div
        initial={{ opacity: 0, y: 40 }}
        animate={{ opacity: 1, y: 0 }}
        transition={{ duration: 0.7, delay: 0.2 }}
        className="mx-auto max-w-3xl text-center"
      >
        <div className="mb-4 inline-flex items-center gap-2 rounded-full bg-pink-100 px-3 py-1 text-xs sm:text-sm text-primary">
          <Heart className="size-3.5 fill-primary" />
          Otwarte oprogramowanie
        </div>
        <h1 className="mb-4 text-3xl font-bold tracking-tight text-gray-900 sm:text-5xl md:text-6xl">
          Śledź swój cykl{' '}
          <span className="bg-gradient-to-r from-primary to-secondary bg-clip-text text-transparent">
            z partnerem
          </span>
        </h1>
        <p className="mx-auto mb-6 max-w-xl text-sm sm:text-base md:text-lg leading-relaxed text-gray-600">
          Okresownik to darmowy, otwartoźródłowy kalendarzyk menstruacyjny z synchronizacją na żywo.
          Żadnych opłat, żadnych subskrypcji. Dane przechowywane w UE.
        </p>
        <div className="flex flex-col items-center gap-3 sm:flex-row sm:justify-center">
          <Button asChild>
            <a href="#pobierz">
              <Smartphone className="size-4" />
              Pobierz aplikację
            </a>
          </Button>
          <Button asChild variant="outline">
            <a href="#funkcje">
              Poznaj funkcje
              <ChevronRight className="size-4" />
            </a>
          </Button>
        </div>
      </motion.div>
    </section>
  )
}
