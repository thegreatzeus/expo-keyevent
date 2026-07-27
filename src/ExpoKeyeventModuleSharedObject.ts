import { SharedObject, useReleasingSharedObject } from 'expo-modules-core';

import ExpoKeyeventModule from './ExpoKeyeventModule';

export declare class ExpoKeyeventModuleSharedObject extends SharedObject {
  count: number;
}

/**
 * Creates a new ExpoKeyeventModuleSharedObject instance.
 * You are responsible for releasing it from memory by calling `release()` when done.
 */
export function createExpoKeyeventModuleSharedObject(): ExpoKeyeventModuleSharedObject {
  return new ExpoKeyeventModule.ExpoKeyeventModuleSharedObject();
}

/**
 * A hook that creates a ExpoKeyeventModuleSharedObject instance and automatically
 * releases it when the component unmounts.
 */
export function useExpoKeyeventModuleSharedObject(): ExpoKeyeventModuleSharedObject {
  return useReleasingSharedObject(() => new ExpoKeyeventModule.ExpoKeyeventModuleSharedObject(), []);
}
