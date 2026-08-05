
export type KeyEventPayload = {
  key: string;
  keyCode: number;
  modifierFlags: number;
};

export type ExpoKeyeventModuleEvents = {
  onKeyDown: (params: KeyEventPayload) => void;
  onKeyUp: (params: KeyEventPayload) => void;
};
