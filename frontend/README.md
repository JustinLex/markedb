# markedb Frontend

Frontend Typescript + React app for markedb, uses isomorphic rendering (client-hydrated SSR).

Based off of Remix's Vite+Express preset.

## Configuration

The following environment variables can be used to configure the markedb frontend:

| `ENV_VAR`                      | type     | default                          | description                                              |
|--------------------------------| -------- |----------------------------------|----------------------------------------------------------|
| `BACKEND_URL`                  | `string` | `https://localhost:8080/api/v1/` | The URL that the backend rust server is hosted at.       |

## Remix-vite documentation:

⚠️ Remix support for Vite is unstable and not recommended for production.

📖 See the [Remix Vite docs][remix-vite-docs] for details on supported features.

### Setup

```shellscript
npx create-remix@latest --template remix-run/remix/templates/unstable-vite-express
```

### Run

Spin up the Express server as a dev server:

```shellscript
npm start
```

Or build your app for production and run it:

```shellscript
npm run build
NODE_ENV=production npm start
```

### Customize

Remix exposes APIs for integrating Vite with a custom server:

```ts
import {
  unstable_createViteServer,
  unstable_loadViteServerBuild,
} from "@remix-run/dev";
```

In this template, we'll use Express but remember that these APIs can be used with _any_ Node-compatible server setup that supports standard middleware.

[remix-vite-docs]: https://remix.run/docs/en/main/future/vite
