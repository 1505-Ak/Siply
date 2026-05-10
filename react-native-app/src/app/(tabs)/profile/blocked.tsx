import { BlockedUsersScreen } from '@/src/screens/BlockedUsersScreen';
import { useRouter } from 'expo-router';

export default function BlockedRoute() {
  const router = useRouter();
  return <BlockedUsersScreen onBack={() => router.back()} />;
}