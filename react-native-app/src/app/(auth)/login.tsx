import LoginScreen from '@/src/screens/LoginScreen';
import { useRouter } from 'expo-router';

export default function LoginRoute() {
  const router = useRouter();

  return (
    <LoginScreen 
      onNavigateToSignUp={() => router.push('/(auth)/signup')}
      onLoginSuccess={() => router.replace('/(tabs)/home')} 
    />
  );
}