import { requireNativeView } from 'expo';
import { type PrimitiveBaseProps } from '@expo/ui/jetpack-compose';
import { createViewModifierEventListener } from '@expo/ui/jetpack-compose/modifiers';
import * as React from 'react';

export interface ExpoKeyeventComposeViewProps extends PrimitiveBaseProps {
  title: string;
  children?: React.ReactNode;
}

const NativeExpoKeyeventComposeView = requireNativeView<ExpoKeyeventComposeViewProps>(
  'ExpoKeyevent',
  'ExpoKeyeventComposeView'
);

export default function ExpoKeyeventComposeView({
  modifiers,
  ...rest
}: ExpoKeyeventComposeViewProps) {
  return (
    <NativeExpoKeyeventComposeView
      modifiers={modifiers}
      {...(modifiers ? createViewModifierEventListener(modifiers) : undefined)}
      {...rest}
    />
  );
}
