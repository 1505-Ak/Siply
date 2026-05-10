import WelcomeScreen from "@/src/screens/WelcomeScreen";
import { authService } from "@/src/services/auth.service";
import { useRouter } from "expo-router";
import React, { useEffect } from "react";

export default function Page() {
  const router = useRouter();

  useEffect(() => {
    const initAuth = async () => {
      // Artificial delay for splash screen aesthetics (optional)
      // await new Promise(resolve => setTimeout(resolve, 2000));

      const isAuthenticated = await authService.checkAuthState();

      if (isAuthenticated) {
        router.replace("/(tabs)/home");
      } else {
        router.replace("/(auth)/login");
      }
    };

    initAuth();
  }, []);

  return <WelcomeScreen />;
}
