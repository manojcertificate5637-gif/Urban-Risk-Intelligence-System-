import { defineConfig, loadEnv } from 'vite'
import react from '@vitejs/plugin-react'
import path from 'path'
import fs from 'fs'

export default defineConfig(({ mode }) => {
  const env = loadEnv(mode, process.cwd(), '')
  const isProduction = mode === 'production'
  const apiUrl = env.VITE_API_URL || 'http://localhost:8000'
  const wsUrl = apiUrl.replace('http', 'ws')

  // HTTPS dev server is opt-in: set HTTPS_DEV=1 to serve the Vite dev
  // server and proxy to the backend over TLS (requires certs/ + backend
  // started with --ssl-*). Default is plain HTTP end-to-end.
  const httpsEnabled = process.env.HTTPS_DEV === '1' && fs.existsSync(path.resolve(__dirname, 'certs/key.pem'))

  return {
    plugins: [react()],
    resolve: {
      alias: {
        '@': path.resolve(__dirname, './src'),
      },
    },
    server: {
      host: '0.0.0.0',
      port: 5173,
      ...(httpsEnabled
        ? {
            https: {
              key: fs.readFileSync(path.resolve(__dirname, 'certs/key.pem')),
              cert: fs.readFileSync(path.resolve(__dirname, 'certs/cert.pem')),
            },
          }
        : {}),
      proxy: isProduction ? undefined : {
        '/api': {
          target: 'http://localhost:8000',
          changeOrigin: true,
          secure: false,
        },
        '/ws': {
          target: 'ws://localhost:8000',
          ws: true,
          secure: false,
        },
        '/uploads': {
          target: 'http://localhost:8000',
          changeOrigin: true,
          secure: false,
        },
      },
    },
    define: {
      'import.meta.env.VITE_API_URL': JSON.stringify(apiUrl),
      'import.meta.env.VITE_WS_URL': JSON.stringify(wsUrl),
    },
  }
})
