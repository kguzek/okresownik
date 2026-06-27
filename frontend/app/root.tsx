import { Links, Meta, Outlet, Scripts } from "react-router";

import "@/index.css";

export default function Root() {
  return (
    <html lang="pl" className="scroll-smooth">
      <head>
        <meta charSet="UTF-8" />
        <link rel="icon" type="image/png" href="/src/assets/logo.png" />
        <meta name="viewport" content="width=device-width, initial-scale=1.0" />
        <Meta />
        <Links />
        <script
          defer
          src="https://analytics.guzek.uk/script.js"
          data-website-id="673422fc-e903-4a88-81d2-ad5ab53240cf"
        />
      </head>
      <body>
        <Outlet />
        <Scripts />
      </body>
    </html>
  );
}
