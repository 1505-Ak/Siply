import HomeScreen from '@/src/screens/HomeScreen';
import { useRouter } from 'expo-router';

export default function HomeRoute() {
  const router = useRouter();

  return (
    <HomeScreen 
      onSeeAll={() => router.push('/(tabs)/home/journal')} // Assuming Journal is in Profile tab
    //   onNavigateToDetail={(id) => router.push(`/(tabs)/home/${id}`)}
    />
  );
}