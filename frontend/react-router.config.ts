import type { Config } from "@react-router/dev/config";

export default {
  async prerender() {
    return ["/", "/regulamin", "/polityka-prywatnosci"];
  },
} satisfies Config;
