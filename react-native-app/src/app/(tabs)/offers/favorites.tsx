import { FavoritesScreen } from '@/src/screens/FavoritesScreen';
import { offersService } from '@/src/services/offers.service';
import { useRouter } from 'expo-router';
import React, { useEffect, useState } from 'react';

export default function FavoritesRoute() {
  const router = useRouter();
  const [favorites, setFavorites] = useState([]);

  useEffect(() => {
    // Fetch data from service
    offersService.getFavorites().then(setFavorites);
  }, []);

  return (
    <FavoritesScreen 
      favorites={favorites}
      onBack={() => router.back()} 
    />
  );
}