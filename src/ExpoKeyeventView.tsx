import { requireNativeView } from 'expo';
import * as React from 'react';

import { ExpoKeyeventViewProps } from './ExpoKeyevent.types';

const NativeView: React.ComponentType<ExpoKeyeventViewProps> = requireNativeView('ExpoKeyevent');

export default function ExpoKeyeventView(props: ExpoKeyeventViewProps) {
  return <NativeView {...props} />;
}
