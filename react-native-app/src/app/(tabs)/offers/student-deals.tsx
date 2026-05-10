import { StudentDealsScreen } from '@/src/screens/StudentDealsScreen';
import { offersService } from '@/src/services/offers.service';
import { useRouter } from 'expo-router';
import React, { useEffect, useState } from 'react';

export default function StudentDealsRoute() {
  const router = useRouter();
  const [venues, setVenues] = useState([]);

  useEffect(() => {
    offersService.getStudentDeals().then(setVenues);
  }, []);

  return (
    <StudentDealsScreen 
      venues={venues}
      onBack={() => router.back()} 
    />
  );
}