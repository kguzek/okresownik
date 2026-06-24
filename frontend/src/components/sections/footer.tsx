import { GitHubIcon } from "@/components/icons/github-icon";

export function Footer() {
  return (
    <footer className="border-t border-pink-100 bg-white px-3 py-6">
      <div className="mx-auto flex max-w-5xl flex-col items-center justify-between gap-3 text-xs text-gray-500 sm:flex-row sm:text-sm">
        <p>
          &copy; {new Date().getFullYear()}{" "}
          <a
            href="https://www.guzek.uk"
            target="_blank"
            rel="noopener noreferrer"
            className="text-primary hover:decoration-primary underline decoration-transparent transition-colors"
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
            className="hover:text-primary flex items-center gap-1 transition-colors"
          >
            <GitHubIcon className="size-4" />
            GitHub
          </a>
          <a href="mailto:kontakt@okresownik.pl" className="hover:text-primary transition-colors">
            Kontakt
          </a>
        </div>
      </div>
    </footer>
  );
}
