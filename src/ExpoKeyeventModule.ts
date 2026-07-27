import { NativeModule, requireNativeModule } from 'expo';

import { ExpoKeyeventModuleEvents } from './ExpoKeyevent.types';
import type { ExpoKeyeventModuleSharedObject } from './ExpoKeyeventModuleSharedObject';

declare class ExpoKeyeventModule extends NativeModule<ExpoKeyeventModuleEvents> {
  PI: number;
  hello(): string;
  setValueAsync(value: string): Promise<void>;
  ExpoKeyeventModuleSharedObject: typeof ExpoKeyeventModuleSharedObject;
}

export default requireNativeModule<ExpoKeyeventModule>('ExpoKeyevent');
