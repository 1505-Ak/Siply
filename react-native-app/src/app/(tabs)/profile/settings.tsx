import { SettingsScreen } from "@/src/screens/SettingsScreen";
import { authService } from "@/src/services/auth.service"; // Import service
import { useRouter } from "expo-router";
import React from "react";

export default function SettingsRoute() {
  const router = useRouter();

  const handleLogout = async () => {
    // 1. Clear tokens
    await authService.logout();

    // 2. Navigate back to auth flow
    router.replace("/(auth)/login");
  };

  return (
    <SettingsScreen onBack={() => router.back()} onLogout={handleLogout} />
  );
}
