import { ProfileScreen } from '@/src/screens/ProfileScreen';
import { useRouter } from 'expo-router';
import React from 'react';

export default function ProfileRoute() {
  const router = useRouter();

  return (
    <ProfileScreen 
      onNavigate={(destination: string) => {
        if (destination === 'settings') router.push('/(tabs)/profile/settings');
        if (destination === 'journal') router.push('/(tabs)/home/journal');
        if (destination === 'achievements') router.push('/(tabs)/home/achievements');
        if (destination === 'map') router.push('/(tabs)/find');
      }}
    />
  );
}