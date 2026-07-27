import { registerWebModule, NativeModule } from 'expo';

import { ExpoKeyeventModuleEvents } from './ExpoKeyevent.types';

// ExpoKeyeventModule is not available on the web platform.
class ExpoKeyeventModule extends NativeModule<ExpoKeyeventModuleEvents> {}

export default registerWebModule(ExpoKeyeventModule, 'ExpoKeyeventModule');
