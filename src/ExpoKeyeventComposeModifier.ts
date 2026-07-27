import { createModifier, type ModifierConfig } from '@expo/ui/jetpack-compose/modifiers';

export const expoKeyeventComposeModifier = (params: {
  color?: number;
  width?: number;
  cornerRadius?: number;
}): ModifierConfig => createModifier('expoKeyeventComposeModifier', params);
