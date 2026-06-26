import { type JSX } from "react";
import { Route, Routes } from "react-router-dom";

import { LandingPage } from "./pages/landing-page";
import PolitykaPrywatnosci from "./pages/polityka-prywatnosci";
import Regulamin from "./pages/regulamin";

function App(): JSX.Element {
  return (
    <Routes>
      <Route path="/" element={<LandingPage />} />
      <Route path="/regulamin" element={<Regulamin />} />
      <Route path="/polityka-prywatnosci" element={<PolitykaPrywatnosci />} />
    </Routes>
  );
}

export default App;
