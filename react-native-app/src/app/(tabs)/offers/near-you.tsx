import { NearYouScreen } from '@/src/screens/NearYouScreen';
import { offersService } from '@/src/services/offers.service';
import { useRouter } from 'expo-router';
import React, { useEffect, useState } from 'react';

export default function NearYouRoute() {
  const router = useRouter();
  const [venues, setVenues] = useState([]);

  useEffect(() => {
    // Fetch dynamic data from service
    offersService.getNearYouVenues().then(setVenues);
  }, []);

  return (
    <NearYouScreen 
      venues={venues}
      onBack={() => router.back()} 
    />
  );
}