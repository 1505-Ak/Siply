import { DiscountsScreen } from '@/src/screens/DiscountsScreen';
import { useRouter } from 'expo-router';

export default function DiscountsRoute() {
  const router = useRouter();

  return (
    <DiscountsScreen 
      // Go back to the main Deals tab
      onBack={() => router.back()} 
      
      // When a grid item is clicked, navigate to its specific page
      onNavigateToCategory={(categoryId: string) => {
        // categoryId will be 'favorites', 'near-you', etc.
        router.push(`/(tabs)/offers/${categoryId}`);
      }}
    />
  );
}