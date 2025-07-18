import { defineConfig } from 'astro/config';
import pagefind from 'astro-pagefind';
import tailwindcss from '@tailwindcss/vite';

import react from '@astrojs/react';

export default defineConfig({
  output: 'static',
  prefetch: true,
  compressHTML: true,
  site: 'https://akiidjk.github.io',
  base: '/',
  integrations: [pagefind(), react()],

  vite: {
    server: {
      allowedHosts: [
        'akiidjk.github.io',
        'localhost',
      ],
    },
    plugins: [tailwindcss()],
  },
});
