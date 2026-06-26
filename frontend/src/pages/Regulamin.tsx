import { Link } from "react-router-dom";

export default function Regulamin() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-12 text-gray-800">
      <Link
        to="/"
        className="text-primary mb-6 inline-block text-sm underline decoration-transparent transition-colors hover:decoration-current"
      >
        &larr; Powrót do strony głównej
      </Link>
      <h1 className="mb-8 text-3xl font-bold">Regulamin</h1>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">1. Postanowienia ogólne</h2>
        <p className="mb-2 leading-relaxed">
          Niniejszy Regulamin określa zasady korzystania z aplikacji mobilnej Okresownik
          (dalej: "Aplikacja"), udostępnianej przez Konrada Guzka, ul. Kosiarzy 37, 02-953
          Warszawa, NIP: 9512545352 (dalej: "Administrator").
        </p>
        <p className="mb-2 leading-relaxed">
          Aplikacja Okresownik służy do śledzenia cyklu menstruacyjnego, prognozowania
          okresów i dni płodnych oraz rejestrowania danych związanych ze zdrowiem
          reprodukcyjnym. Aplikacja nie jest urządzeniem medycznym i nie zastępuje
          konsultacji lekarskiej.
        </p>
        <p className="leading-relaxed">
          Korzystanie z Aplikacji jest równoznaczne z akceptacją niniejszego Regulaminu
          oraz Polityki prywatności. Użytkownik zobowiązuje się do przestrzegania
          postanowień Regulaminu.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">2. Definicje</h2>
        <ul className="list-disc space-y-1 pl-6 leading-relaxed">
          <li>
            <strong>Administrator</strong> – Konrad Guzek, ul. Kosiarzy 37, 02-953 Warszawa.
          </li>
          <li>
            <strong>Aplikacja</strong> – mobilne oprogramowanie Okresownik dostępne na
            systemy Android, iOS oraz wersję webową.
          </li>
          <li>
            <strong>Użytkownik</strong> – każda osoba fizyczna korzystająca z Aplikacji,
            posiadająca konto w Aplikacji.
          </li>
          <li>
            <strong>Dane osobowe</strong> – wszelkie informacje o zidentyfikowanej lub
            możliwej do zidentyfikowania osobie fizycznej, w tym dane wrażliwe w
            rozumieniu art. 9 RODO.
          </li>
          <li>
            <strong>RODO</strong> – Rozporządzenie Parlamentu Europejskiego i Rady (UE)
            2016/679 z dnia 27 kwietnia 2016 r. w sprawie ochrony osób fizycznych w
            związku z przetwarzaniem danych osobowych.
          </li>
          <li>
            <strong>Dane wrażliwe</strong> – dane dotyczące zdrowia seksualnego i
            reprodukcyjnego, w tym informacje o cyklu menstruacyjnym, współżyciu,
            płodności i inne dane wprowadzane przez Użytkownika.
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">3. Zakres usług</h2>
        <p className="mb-2 leading-relaxed">Aplikacja umożliwia Użytkownikowi:</p>
        <ul className="list-disc space-y-1 pl-6 leading-relaxed">
          <li>Rejestrowanie i śledzenie dni cyklu menstruacyjnego,</li>
          <li>Oznaczanie dni z miesiączką wraz z poziomem krwawienia,</li>
          <li>Rejestrowanie współżycia,</li>
          <li>Dodawanie notatek do poszczególnych dni,</li>
          <li>Prognozowanie kolejnych miesiączek i dni płodnych na podstawie
            wprowadzonych danych,</li>
          <li>Udostępnianie kalendarza partnerowi za pomocą kodu pary,</li>
          <li>Przeglądanie kalendarza partnera (za jego zgodą).</li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">4. Rejestracja i konto</h2>
        <p className="mb-2 leading-relaxed">
          Aby korzystać z Aplikacji, Użytkownik musi utworzyć konto, podając imię i
          nazwisko (lub pseudonim), adres e-mail oraz hasło.
        </p>
        <p className="mb-2 leading-relaxed">
          Rejestracja wymaga akceptacji niniejszego Regulaminu, Polityki prywatności oraz
          udzielenia wyraźnej zgody na przetwarzanie danych wrażliwych, o której mowa w
          pkt 8.
        </p>
        <p className="mb-2 leading-relaxed">
          Użytkownik zobowiązuje się do podawania prawdziwych danych oraz do
          zabezpieczenia swojego hasła przed dostępem osób trzecich.
        </p>
        <p className="leading-relaxed">
          Administrator zastrzega sobie prawo do zablokowania konta Użytkownika w
          przypadku naruszenia postanowień Regulaminu.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">5. Prawa i obowiązki Użytkownika</h2>
        <p className="mb-2 leading-relaxed">
          Użytkownik ma prawo do korzystania z Aplikacji zgodnie z jej
          przeznaczeniem.
        </p>
        <p className="mb-2 leading-relaxed">
          Użytkownik ma prawo do:
        </p>
        <ul className="list-disc space-y-1 pl-6 leading-relaxed">
          <li>Dostępu do swoich danych osobowych,</li>
          <li>Sprostowania danych,</li>
          <li>Usunięcia wszystkich swoich danych (z zachowaniem konta),</li>
          <li>Usunięcia konta wraz z wszystkimi danymi,</li>
          <li>Wycofania zgody na przetwarzanie danych w dowolnym momencie,</li>
          <li>Przenoszenia danych.</li>
        </ul>
        <p className="mt-2 leading-relaxed">
          Użytkownik zobowiązuje się do nieudostępniania swoich danych logowania
          osobom trzecim.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">6. Ograniczenie odpowiedzialności</h2>
        <p className="mb-2 leading-relaxed">
          Aplikacja Okresownik nie jest urządzeniem medycznym ani narzędziem
          diagnostycznym. Dane i prognozy generowane przez Aplikację mają charakter
          wyłącznie informacyjny i nie mogą stanowić podstawy do podejmowania decyzji
          medycznych, w szczególności dotyczących antykoncepcji czy planowania ciąży.
        </p>
        <p className="leading-relaxed">
          Administrator nie ponosi odpowiedzialności za szkody wynikające z
          niewłaściwego korzystania z Aplikacji lub polegania na generowanych
          prognozach.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">7. Przetwarzanie danych osobowych</h2>
        <p className="mb-2 leading-relaxed">
          Szczegółowe informacje na temat przetwarzania danych osobowych zawiera
          Polityka prywatności dostępna pod adresem{" "}
          <Link
            to="/polityka-prywatnosci"
            className="text-primary underline decoration-transparent transition-colors hover:decoration-current"
          >
            okresownik.pl/polityka-prywatnosci
          </Link>
          .
        </p>
        <p className="mb-2 leading-relaxed">
          Administrator przetwarza dane Użytkownika w celu świadczenia usług
          Aplikacji, w tym przechowywania danych o cyklu i generowania prognoz.
        </p>
        <p className="leading-relaxed">
          Dane wrażliwe (w tym dane dotyczące zdrowia seksualnego i reprodukcyjnego) są
          przetwarzane wyłącznie na podstawie wyraźnej zgody Użytkownika (art. 9 ust. 2
          lit. a RODO).
        </p>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">8. Zgoda na przetwarzanie danych wrażliwych</h2>
        <p className="mb-2 leading-relaxed">
          Korzystanie z Aplikacji Okresownik wymaga wyraźnej, świadomej i dobrowolnej
          zgody na przetwarzanie danych wrażliwych, w szczególności danych dotyczących
          zdrowia seksualnego i reprodukcyjnego (art. 9 ust. 2 lit. a RODO).
        </p>
        <p className="mb-2 leading-relaxed">
          Użytkownik wyraża zgodę na przetwarzanie przez Administratora następujących
          kategorii danych wrażliwych:
        </p>
        <ul className="list-disc space-y-1 pl-6 leading-relaxed">
          <li>Daty dni menstruacyjnych i poziom krwawienia,</li>
          <li>Informacje o współżyciu,</li>
          <li>Dni płodne i prognozy owulacji,</li>
          <li>Inne notatki dotyczące zdrowia reprodukcyjnego wprowadzone przez
            Użytkownika.</li>
        </ul>
        <p className="mt-2 mb-2 leading-relaxed">
          Zgoda obejmuje następujące czynności przetwarzania: zbieranie,
          przechowywanie, odczytywanie, modyfikowanie, uaktualnianie, usuwanie danych
          Użytkownika, a także analizę i przetwarzanie algorytmiczne w celu generowania
          prognoz cyklu.
        </p>
        <p className="mb-2 leading-relaxed">
          Celem przetwarzania danych wrażliwych jest świadczenie usług śledzenia cyklu
          menstruacyjnego i prognozowania płodności w ramach Aplikacji Okresownik.
        </p>
        <p className="leading-relaxed">
          Użytkownik ma prawo w dowolnym momencie wycofać zgodę na przetwarzanie
          danych wrażliwych. Wycofanie zgody nie wpływa na zgodność z prawem
          przetwarzania dokonanego przed jej wycofaniem. Wycofanie zgody może
          uniemożliwić dalsze korzystanie z Aplikacji.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">9. Usunięcie danych i konta</h2>
        <p className="mb-2 leading-relaxed">
          Użytkownik ma możliwość w każdej chwili:
        </p>
        <ul className="list-disc space-y-1 pl-6 leading-relaxed">
          <li>
            <strong>Usunięcia wszystkich danych</strong> – spowoduje trwałe usunięcie
            wszystkich zapisanych danych cyklu, notatek i powiązań partnerskich, przy
            zachowaniu samego konta Użytkownika (dane logowania pozostają).
          </li>
          <li>
            <strong>Usunięcia konta</strong> – spowoduje trwałe usunięcie konta
            Użytkownika wraz ze wszystkimi danymi, w tym danymi cyklu, notatkami i
            powiązaniami partnerskimi. Operacja ta jest nieodwracalna.
          </li>
        </ul>
        <p className="mt-2 leading-relaxed">
          Obie opcje są dostępne w ustawieniach Aplikacji.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">10. Postanowienia końcowe</h2>
        <p className="mb-2 leading-relaxed">
          Administrator zastrzega sobie prawo do zmiany Regulaminu. Użytkownicy
          zostaną powiadomieni o zmianach za pośrednictwem Aplikacji.
        </p>
        <p className="mb-2 leading-relaxed">
          W sprawach nieuregulowanych niniejszym Regulaminem zastosowanie mają przepisy
          prawa polskiego, w szczególności Kodeksu cywilnego oraz RODO.
        </p>
        <p className="mb-2 leading-relaxed">
          Wszelkie spory rozstrzygane będą przez sąd właściwy dla siedziby
          Administratora.
        </p>
        <p className="leading-relaxed">
          Regulamin wchodzi w życie z dniem 1 lipca 2026 roku.
        </p>
      </section>

      <div className="border-primary/20 mt-12 border-t pt-6 text-center text-sm text-gray-500">
        <Link
          to="/"
          className="text-primary underline decoration-transparent transition-colors hover:decoration-current"
        >
          Powrót do strony głównej
        </Link>
        {" | "}
        <Link
          to="/polityka-prywatnosci"
          className="text-primary underline decoration-transparent transition-colors hover:decoration-current"
        >
          Polityka prywatności
        </Link>
      </div>
    </div>
  );
}
