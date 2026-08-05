import { NativeModule, requireNativeModule } from 'expo';

import { ExpoKeyeventModuleEvents } from './ExpoKeyevent.types';

declare class ExpoKeyeventModule extends NativeModule<ExpoKeyeventModuleEvents> {
  startListening(consumeEvents?: boolean): void;
  stopListening(): void;
}

export default requireNativeModule<ExpoKeyeventModule>('ExpoKeyevent');
