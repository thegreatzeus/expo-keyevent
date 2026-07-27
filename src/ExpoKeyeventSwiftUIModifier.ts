import { createModifier, type ModifierConfig } from '@expo/ui/swift-ui/modifiers';

export const expoKeyeventSwiftUIModifier = (params: {
  color?: string;
  width?: number;
  cornerRadius?: number;
}): ModifierConfig => createModifier('expoKeyeventSwiftUIModifier', params);
