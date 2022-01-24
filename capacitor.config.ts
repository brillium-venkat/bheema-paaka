import { CapacitorConfig } from '@capacitor/cli';

const config: CapacitorConfig = {
  appId: 'com.paakashashtra.bheemapaaka.mobile.app',
  appName: 'Bheema Paaka',
  webDir: 'www',
  bundledWebRuntime: false,
  server: {
    cleartext: true,
  },
  plugins: {
    SplashScreen: {
      launchShowDuration: 0,
    },
  },
};
export default config;
