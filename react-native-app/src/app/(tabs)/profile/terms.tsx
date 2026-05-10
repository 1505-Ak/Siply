import { TermsPrivacyScreen } from '@/src/screens/TermsPrivacyScreen';
import { useRouter } from 'expo-router';

export default function TermsRoute() {
  const router = useRouter();
  return <TermsPrivacyScreen onBack={() => router.back()} />;
}