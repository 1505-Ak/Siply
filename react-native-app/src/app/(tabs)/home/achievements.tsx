import { AchievementScreen } from '@/src/screens/AchievementScreen';
import { useRouter } from 'expo-router';
import React from 'react';

export default function AchievementsRoute() {
  const router = useRouter();
  return <AchievementScreen onBack={() => router.back()} />;
}