import { LoyaltySchemesScreen } from '@/src/screens/LoyaltySchemesScreen';
import { useRouter } from 'expo-router';

export default function LoyaltyRoute() {
  const router = useRouter();

  return (
    <LoyaltySchemesScreen 
  onBack={() => router.back()} 
  onNavigate={(id) => router.push(`/(tabs)/offers/member-offers`)} 
/>
  );
}