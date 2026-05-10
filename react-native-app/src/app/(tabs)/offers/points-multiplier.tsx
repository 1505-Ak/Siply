import { PointsMultiplierScreen } from '@/src/screens/PointsMultiplierScreen';
import { useRouter } from 'expo-router';
import React from 'react';

export default function PointsMultiplierRoute() {
  const router = useRouter();

  return (
    <PointsMultiplierScreen 
      onBack={() => router.back()} 
    />
  );
}