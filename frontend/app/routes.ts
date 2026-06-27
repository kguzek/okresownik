import type { RouteConfig } from "@react-router/dev/routes";

export default [
  { path: "/", file: "routes/home.tsx" },
  { path: "/regulamin", file: "routes/regulamin.tsx" },
  { path: "/polityka-prywatnosci", file: "routes/polityka-prywatnosci.tsx" },
] satisfies RouteConfig;
