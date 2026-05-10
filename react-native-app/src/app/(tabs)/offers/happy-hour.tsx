import { HappyHourScreen } from '@/src/screens/HappyHourScreen';
import { offersService } from '@/src/services/offers.service';
import { useRouter } from 'expo-router';
import React, { useEffect, useState } from 'react';

export default function HappyHourRoute() {
  const router = useRouter();
  const [venues, setVenues] = useState([]);

  useEffect(() => {
    offersService.getHappyHourVenues().then(setVenues);
  }, []);

  return (
    <HappyHourScreen 
      venues={venues}
      onBack={() => router.back()} 
    />
  );
}