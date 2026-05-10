import { VisitCounterScreen } from '@/src/screens/VisitCounterScreen';
import { useRouter } from 'expo-router';
import React from 'react';

export default function VisitCounterRoute() {
  const router = useRouter();

  return (
    <VisitCounterScreen 
      onBack={() => router.back()} 
    />
  );
}