import { PrivacyScreen } from '@/src/screens/PrivacyScreen';
import { useRouter } from 'expo-router';

export default function PrivacyRoute() {
  const router = useRouter();
  return <PrivacyScreen onBack={() => router.back()} />;
}