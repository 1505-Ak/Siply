import { OffersScreen } from '@/src/screens/OffersScreen';
import { useRouter } from 'expo-router';

export default function OffersRoute() {
  const router = useRouter();
  return <OffersScreen onNavigate={(screen: string) => router.push(`/(tabs)/offers/${screen}`)} />;
}