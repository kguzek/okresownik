import { Mail } from 'lucide-react'
import { motion } from 'motion/react'
import { Button } from '@/components/ui/button'

export function Cta() {
  return (
    <section id="kontakt" className="scroll-mt-20 px-3 py-2 sm:py-6">
      <motion.div
        initial={{ opacity: 0, scale: 0.95 }}
        whileInView={{ opacity: 1, scale: 1 }}
        viewport={{ once: true }}
        transition={{ duration: 0.5 }}
        className="mx-auto max-w-2xl text-center"
      >
        <div className="rounded-3xl bg-linear-to-br from-primary to-primary-dark p-4 sm:p-10">
          <Mail className="mx-auto mb-4 size-8 text-white/90" />
          <h2 className="mb-3 text-xl font-bold text-white sm:text-4xl">
            Chcesz przetestować wersję alpha?
          </h2>
          <p className="mb-4 text-sm text-white/80 sm:text-lg">
            Jeżeli jesteś zainteresowana wczesnym dostępem do Okresownika, napisz do nas —
            udostępnimy Ci wersję alpha do przetestowania.
          </p>
          <Button
            asChild
            className="bg-white text-primary hover:bg-white/90 hover:text-primary-dark text-sm max-sm:px-4"
          >
            <a href="mailto:kontakt@okresownik.pl">
              <Mail className="size-4 shrink-0" />
              <span className="truncate">
                <span className="max-sm:hidden">Napisz: </span>kontakt@okresownik.pl
              </span>
            </a>
          </Button>
        </div>
      </motion.div>
    </section>
  )
}
