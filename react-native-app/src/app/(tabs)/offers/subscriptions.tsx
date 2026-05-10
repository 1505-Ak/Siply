import { SubscriptionsScreen } from '@/src/screens/SubscriptionsScreen';
import { useRouter } from 'expo-router';
import React from 'react';

export default function SubscriptionsRoute() {
  const router = useRouter();

  return (
    <SubscriptionsScreen 
      onBack={() => router.back()} 
    />
  );
}