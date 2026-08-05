// Reexport the native module. On web, it will be resolved to ExpoKeyeventModule.web.ts
// and on native platforms to ExpoKeyeventModule.ts
export { default } from './ExpoKeyeventModule';
export * from './ExpoKeyevent.types';
