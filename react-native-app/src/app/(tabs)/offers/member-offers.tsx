import { MemberOffersScreen } from '@/src/screens/MemberOffersScreen';
import { useRouter } from 'expo-router';
import React from 'react';

export default function MemberOffersRoute() {
  const router = useRouter();

  return (
    <MemberOffersScreen 
      onBack={() => router.back()} 
    />
  );
}