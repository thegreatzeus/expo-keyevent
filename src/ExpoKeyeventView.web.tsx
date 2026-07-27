import { ExpoKeyeventViewProps } from './ExpoKeyevent.types';

// ExpoKeyeventView is not available on the web platform.
export default function ExpoKeyeventView(_props: ExpoKeyeventViewProps) {
  throw new Error('ExpoKeyeventView is not available on the web platform.');
}
