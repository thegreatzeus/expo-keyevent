import { requireNativeView } from 'expo';
import { type CommonViewModifierProps } from '@expo/ui/swift-ui';
import { createViewModifierEventListener } from '@expo/ui/swift-ui/modifiers';
import * as React from 'react';

export interface ExpoKeyeventSwiftUIViewProps extends CommonViewModifierProps {
  title: string;
  children?: React.ReactNode;
}

const NativeExpoKeyeventSwiftUIView = requireNativeView<ExpoKeyeventSwiftUIViewProps>(
  'ExpoKeyevent',
  'ExpoKeyeventSwiftUIView'
);

export default function ExpoKeyeventSwiftUIView({
  modifiers,
  ...rest
}: ExpoKeyeventSwiftUIViewProps) {
  return (
    <NativeExpoKeyeventSwiftUIView
      modifiers={modifiers}
      {...(modifiers ? createViewModifierEventListener(modifiers) : undefined)}
      {...rest}
    />
  );
}
