import { motion } from 'motion/react'
import { GitHubIcon } from '@/components/icons/github-icon'
import AppLogo from "@/assets/logo.png"

export function Header() {
  return (
    <motion.header
      initial={{ opacity: 0, y: -20 }}
      animate={{ opacity: 1, y: 0 }}
      transition={{ duration: 0.6 }}
      className="sticky top-0 z-50 border-b border-pink-100 bg-white/80 backdrop-blur-md"
    >
      <div className="mx-auto flex max-w-5xl items-center justify-between px-3 py-2.5">
        <div className="flex items-center gap-1.5">
          <img src={AppLogo} alt="Okresownik" className="size-6" />
          <span className="text-sm sm:text-lg font-semibold text-gray-900">Okresownik</span>
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
  )
}
