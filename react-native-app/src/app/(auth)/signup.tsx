import SignUpScreen from "@/src/screens/SignUpScreen";
import { useRouter } from "expo-router";

export default function SignUpRoute() {
  const router = useRouter();

  return (
    <SignUpScreen
      onNavigateToLogin={() => router.back()}
      onSignUpSuccess={() => router.replace("/(tabs)/home")}
    />
  );
}
