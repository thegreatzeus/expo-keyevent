# @thegreatzeus/expo-keyevent

A powerful Expo module that allows you to globally listen and react to hardware keyboard events (`onKeyDown` and `onKeyUp`) on both iOS and Android. 

Additionally, on iOS, this package natively captures input from the **Gamepad API (GameController framework)**, meaning button presses and D-pad inputs from connected game controllers will automatically trigger the same key events, completely seamlessly!

## Installation

```bash
npm install @thegreatzeus/expo-keyevent
# or
yarn add @thegreatzeus/expo-keyevent
```

> **Note:** As this package includes native code, you will need to create a custom development build (using `npx expo run:ios` or `npx expo run:android`) or use EAS Build. This module will not work in the standard Expo Go app.

## Usage

Here is a simple example showing how to listen to key presses and releases in your application:

```tsx
import { useEffect } from 'react';
import { SafeAreaView, Text, View } from 'react-native';
import { useEvent } from 'expo';
import ExpoKeyevent from '@thegreatzeus/expo-keyevent';

export default function App() {
  // Hook into the native key events
  const onKeyDownPayload = useEvent(ExpoKeyevent, 'onKeyDown');
  const onKeyUpPayload = useEvent(ExpoKeyevent, 'onKeyUp');

  useEffect(() => {
    // Start listening for global key events.
    // Passing `true` will consume the events at the native level, preventing them from propagating further.
    ExpoKeyevent.startListening(true);
    
    return () => {
      // Don't forget to stop listening when the component unmounts
      ExpoKeyevent.stopListening();
    };
  }, []);

  return (
    <SafeAreaView style={{ flex: 1, justifyContent: 'center', alignItems: 'center' }}>
      <Text style={{ fontSize: 24, fontWeight: 'bold' }}>ExpoKeyEvent Example</Text>
      
      <View style={{ marginTop: 20 }}>
        <Text>Last Key Down: {onKeyDownPayload ? `${onKeyDownPayload.key} (Code: ${onKeyDownPayload.keyCode})` : 'None'}</Text>
        <Text>Last Key Up: {onKeyUpPayload ? `${onKeyUpPayload.key} (Code: ${onKeyUpPayload.keyCode})` : 'None'}</Text>
      </View>
    </SafeAreaView>
  );
}
```

## API Reference

### `startListening(consumeEvents?: boolean)`
Starts observing key events globally on the native window/application.
* **`consumeEvents`** *(boolean, optional)*: If `true`, the native framework will consume the key events so they are not propagated down to the rest of the application's native views (like scrolling scrollviews, triggering default button actions, etc.). Default is `false`.

### `stopListening()`
Stops observing key events. Always ensure you call this during cleanup (e.g., in a `useEffect` return block) to prevent memory leaks or duplicate event dispatches.

---

### Events

You can listen to events using Expo's `useEvent` hook, or via standard listeners: `ExpoKeyevent.addListener('onKeyDown', callback)`.

#### `onKeyDown`
Triggered when a key is pressed down, or when a game controller button is pressed (iOS).

#### `onKeyUp`
Triggered when a key is released, or when a game controller button is released (iOS).

### Payload Type (`KeyEventPayload`)
Both `onKeyDown` and `onKeyUp` events provide a payload of type `KeyEventPayload`:

```typescript
export type KeyEventPayload = {
  key: string;           // The character or localized name of the key/button (e.g., "a", "Enter", "Button A", "D-Pad Up")
  keyCode: number;       // The native integer code representing the key. Note: Game controllers on iOS will return 0.
  modifierFlags: number; // Bitmask of modifier keys (e.g., Shift, Ctrl) pressed alongside the key.
};
```

## Gamepad API Support (iOS)
On iOS, the module is tightly integrated with the native `GameController` framework. When `startListening()` is called, it will automatically connect to existing and newly discovered Gamepads (e.g. Xbox, PlayStation, MFi controllers). 

Button presses (like Button A, Button X) and D-Pad interactions are piped directly into the `onKeyDown` and `onKeyUp` events. The payload's `key` property will resolve to a readable string based on the button's native localized name (such as `"Button A"` or `"D-Pad Down"`).
