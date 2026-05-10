import { AboutScreen } from '@/src/screens/AboutScreen';
import { useRouter } from 'expo-router';

export default function AboutRoute() {
  const router = useRouter();
  return <AboutScreen onBack={() => router.back()} />;
}