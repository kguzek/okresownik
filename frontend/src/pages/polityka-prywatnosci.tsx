import { Link } from "react-router-dom";

export default function PolitykaPrywatnosci() {
  return (
    <div className="mx-auto max-w-3xl px-4 py-12 text-gray-800">
      <Link
        to="/"
        className="text-primary mb-6 inline-block text-sm underline decoration-transparent transition-colors hover:decoration-current"
      >
        &larr; Powrót do strony głównej
      </Link>
      <h1 className="mb-8 text-3xl font-bold">Polityka prywatności</h1>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">1. Administrator danych</h2>
        <p className="leading-relaxed">
          Administratorem danych osobowych Użytkowników aplikacji Okresownik jest
          Konrad Guzek, ul. Kosiarzy 37, 02-953 Warszawa, NIP: 9512545352, adres
          e-mail:{" "}
          <a
            href="mailto:kontakt@okresownik.pl"
            className="text-primary underline decoration-transparent transition-colors hover:decoration-current"
          >
            kontakt@okresownik.pl
          </a>
          .
        </p>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">2. Zakres zbieranych danych</h2>
        <p className="mb-2 leading-relaxed">
          W trakcie korzystania z Aplikacji Okresownik zbieramy następujące kategorie
          danych:
        </p>

        <h3 className="mb-2 mt-4 font-semibold">a) Dane konta:</h3>
        <ul className="list-disc space-y-1 pl-6 leading-relaxed">
          <li>Adres e-mail,</li>
          <li>Imię i nazwisko (lub pseudonim),</li>
          <li>Hash hasła (hasło nie jest przechowywane w jawnej postaci).</li>
        </ul>

        <h3 className="mb-2 mt-4 font-semibold">
          b) Dane wrażliwe (art. 9 RODO) – przetwarzane wyłącznie na podstawie
          wyraźnej zgody:
        </h3>
        <ul className="list-disc space-y-1 pl-6 leading-relaxed">
          <li>Daty menstruacji i poziom krwawienia (plamienie, lekki, średni,
            obfity),</li>
          <li>Informacje o współżyciu,</li>
          <li>Notatki dotyczące zdrowia reprodukcyjnego,</li>
          <li>Prognozy cyklu i dni płodnych generowane na podstawie wprowadzonych
            danych.</li>
        </ul>

        <h3 className="mb-2 mt-4 font-semibold">c) Dane techniczne:</h3>
        <ul className="list-disc space-y-1 pl-6 leading-relaxed">
          <li>Adres IP,</li>
          <li>Typ urządzenia i system operacyjny,</li>
          <li>Dane o aktywności w Aplikacji (czas logowania, ostatnia
            aktywność).</li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">3. Cele i podstawy prawne przetwarzania</h2>
        <div className="overflow-x-auto">
          <table className="w-full border-collapse text-sm">
            <thead>
              <tr className="bg-pink-50">
                <th className="border border-pink-200 p-2 text-left">Cel</th>
                <th className="border border-pink-200 p-2 text-left">Podstawa prawna</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td className="border border-pink-200 p-2">
                  Założenie i utrzymanie konta, uwierzytelnianie
                </td>
                <td className="border border-pink-200 p-2">
                  Art. 6 ust. 1 lit. b RODO (niezbędność do wykonania umowy)
                </td>
              </tr>
              <tr>
                <td className="border border-pink-200 p-2">
                  Przechowywanie danych cyklu, generowanie prognoz
                </td>
                <td className="border border-pink-200 p-2">
                  Art. 6 ust. 1 lit. b RODO oraz art. 9 ust. 2 lit. a RODO (wyraźna
                  zgoda na przetwarzanie danych wrażliwych)
                </td>
              </tr>
              <tr>
                <td className="border border-pink-200 p-2">
                  Udostępnianie kalendarza partnerowi
                </td>
                <td className="border border-pink-200 p-2">
                  Art. 6 ust. 1 lit. a RODO (zgoda)
                </td>
              </tr>
              <tr>
                <td className="border border-pink-200 p-2">
                  Analiza i doskonalenie Aplikacji
                </td>
                <td className="border border-pink-200 p-2">
                  Art. 6 ust. 1 lit. f RODO (prawnie uzasadniony interes
                  Administratora)
                </td>
              </tr>
              <tr>
                <td className="border border-pink-200 p-2">
                  Ewentualne dochodzenie roszczeń
                </td>
                <td className="border border-pink-200 p-2">
                  Art. 6 ust. 1 lit. f RODO
                </td>
              </tr>
            </tbody>
          </table>
        </div>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">4. Przetwarzanie danych wrażliwych</h2>
        <p className="mb-2 leading-relaxed">
          Zgodnie z art. 9 ust. 1 RODO, dane dotyczące zdrowia, w tym zdrowia
          seksualnego i reprodukcyjnego, stanowią szczególną kategorię danych
          osobowych (dane wrażliwe). Ich przetwarzanie jest co do zasady zabronione,
          chyba że zachodzi jedna z przesłanek określonych w art. 9 ust. 2 RODO.
        </p>
        <p className="mb-2 leading-relaxed">
          W przypadku Aplikacji Okresownik, dane wrażliwe są przetwarzane wyłącznie
          na podstawie wyraźnej, świadomej i dobrowolnej zgody Użytkownika (art. 9
          ust. 2 lit. a RODO).
        </p>
        <p className="mb-2 leading-relaxed">
          Udzielenie zgody jest dobrowolne, ale niezbędne do korzystania z Aplikacji
          – bez zgody nie jest możliwe przechowywanie danych cyklu i generowanie
          prognoz.
        </p>
        <p className="leading-relaxed">
          Zgoda może być wycofana w dowolnym momencie poprzez usunięcie danych lub
          konta w ustawieniach Aplikacji. Wycofanie zgody nie wpływa na zgodność z
          prawem przetwarzania dokonanego przed jej wycofaniem.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">5. Okres przechowywania danych</h2>
        <p className="leading-relaxed">
          Dane Użytkownika są przechowywane przez okres korzystania z Aplikacji, aż
          do momentu usunięcia konta lub wycofania zgody. Po usunięciu konta dane są
          trwale usuwane z bazy danych. W przypadku wycofania zgody na przetwarzanie
          danych wrażliwych bez usunięcia konta, dane konta (nie wrażliwe) mogą być
          przechowywane do momentu usunięcia konta.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">6. Odbiorcy danych</h2>
        <p className="mb-2 leading-relaxed">
          Dane Użytkownika nie są sprzedawane ani udostępniane osobom trzecim, z
          wyjątkiem:
        </p>
        <ul className="list-disc space-y-1 pl-6 leading-relaxed">
          <li>
            <strong>Dostawcy usług hostingowych</strong> – dane są przechowywane na
            serwerach w chmurze. Obecnie nie korzystamy z zewnętrznych dostawców
            chmurowych poza infrastrukturą niezbędną do uruchomienia Aplikacji.
          </li>
          <li>
            <strong>Partnera Użytkownika</strong> – jeśli Użytkownik aktywnie
            udostępni swój kalendarz partnerowi za pomocą kodu pary, partner
            otrzymuje dostęp do danych cyklu i prognoz Użytkownika (w trybie tylko
            do odczytu).
          </li>
          <li>
            <strong>Organów ścigania</strong> – na podstawie i w zakresie
            wymaganym przez przepisy prawa.
          </li>
        </ul>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">7. Prawa Użytkownika</h2>
        <p className="mb-2 leading-relaxed">
          Użytkownik ma prawo do:
        </p>
        <ol className="list-decimal space-y-1 pl-6 leading-relaxed">
          <li>
            <strong>Dostępu do danych</strong> – uzyskania informacji o tym, jakie
            dane są przetwarzane oraz otrzymania ich kopii.
          </li>
          <li>
            <strong>Sprostowania danych</strong> – poprawienia nieprawidłowych lub
            niekompletnych danych.
          </li>
          <li>
            <strong>Usunięcia danych ("prawo do bycia zapomnianym")</strong> –
            żądania usunięcia wszystkich swoich danych. Można to zrobić w
            ustawieniach Aplikacji (usunięcie wszystkich danych lub usunięcie
            konta).
          </li>
          <li>
            <strong>Ograniczenia przetwarzania</strong> – w przypadkach określonych
            w art. 18 RODO.
          </li>
          <li>
            <strong>Przenoszenia danych</strong> – otrzymania danych w ustrukturyzowanym,
            powszechnie używanym formacie.
          </li>
          <li>
            <strong>Sprzeciwu</strong> – wobec przetwarzania danych na podstawie
            prawnie uzasadnionego interesu Administratora.
          </li>
          <li>
            <strong>Wycofania zgody</strong> – w dowolnym momencie, bez wpływu na
            zgodność z prawem przetwarzania dokonanego przed wycofaniem zgody.
          </li>
          <li>
            <strong>Skargi</strong> – wniesienia skargi do Prezesa Urzędu Ochrony
            Danych Osobowych (PUODO), jeśli Użytkownik uzna, że przetwarzanie
            danych narusza przepisy RODO.
          </li>
        </ol>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">8. Bezpieczeństwo danych</h2>
        <p className="leading-relaxed">
          Administrator wdraża odpowiednie środki techniczne i organizacyjne
          zapewniające bezpieczeństwo danych osobowych, w tym szyfrowanie haseł
          (bcrypt), szyfrowanie transmisji (HTTPS/TLS) oraz regularne kopie
          zapasowe. Dostęp do bazy danych jest ograniczony wyłącznie do
          Administratora.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">9. Pliki cookies i technologie śledzące</h2>
        <p className="leading-relaxed">
          Aplikacja Okresownik nie wykorzystuje plików cookies ani innych technologii
          śledzących do profilowania Użytkowników. Strona internetowa okresownik.pl
          może wykorzystywać niezbędne pliki cookies do prawidłowego działania.
          Administrator nie korzysta z narzędzi analitycznych stron trzecich (takich
          jak Google Analytics) w sposób umożliwiający identyfikację Użytkownika.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">10. Dane kontaktowe i RODO</h2>
        <p className="leading-relaxed">
          We wszystkich sprawach związanych z ochroną danych osobowych można
          kontaktować się z Administratorem pod adresem e-mail:{" "}
          <a
            href="mailto:kontakt@okresownik.pl"
            className="text-primary underline decoration-transparent transition-colors hover:decoration-current"
          >
            kontakt@okresownik.pl
          </a>
          .
        </p>
        <p className="mt-2 leading-relaxed">
          Administrator nie wyznaczył Inspektora Ochrony Danych (IOD), ponieważ nie
          jest do tego zobowiązany na podstawie art. 37 RODO.
        </p>
      </section>

      <section className="mb-8">
        <h2 className="mb-3 text-xl font-semibold">11. Zmiany Polityki prywatności</h2>
        <p className="leading-relaxed">
          Administrator zastrzega sobie prawo do zmiany Polityki prywatności.
          Użytkownicy zostaną powiadomieni o zmianach za pośrednictwem Aplikacji.
          Polityka prywatności wchodzi w życie z dniem 1 lipca 2026 roku.
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
          to="/regulamin"
          className="text-primary underline decoration-transparent transition-colors hover:decoration-current"
        >
          Regulamin
        </Link>
      </div>
    </div>
  );
}
