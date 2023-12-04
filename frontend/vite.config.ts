import { unstable_vitePlugin as remix } from "@remix-run/dev";
import { defineConfig } from "vite";
import tsconfigPaths from "vite-tsconfig-paths";

export default defineConfig({
  plugins: [
    
    remix({
      
      // Define 404 route, prevents exceptions from happening on invalid routes
      // vite plugin configures identically to legacy remix config
      // https://remix.run/docs/en/main/file-conventions/remix-config#routes
      routes: async (defineRoutes) => {
        return defineRoutes((route) => {
          route("*", "routes/404.tsx");
        })
      }
      
    }),
    
    tsconfigPaths()
    
  ],
});
