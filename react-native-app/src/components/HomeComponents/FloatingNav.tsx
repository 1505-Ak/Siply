import { Ionicons } from '@expo/vector-icons';
import { usePathname, useRouter } from 'expo-router';
import React from 'react';
import { TouchableOpacity, View } from 'react-native';
import { COLORS } from '../../constants/colors';

export const FloatingNav = () => {
  const router = useRouter();
  const pathname = usePathname();

  // Helper to check if a tab is active
  const isActive = (path: string) => pathname.includes(path);

  return (
    <View 
      style={{ 
        position: 'absolute', 
        bottom: 30, 
        left: 20, 
        right: 20,
        shadowColor: '#000',
        shadowOffset: { width: 0, height: 10 },
        shadowOpacity: 0.4,
        shadowRadius: 15,
        elevation: 10
      }}
      className="h-16 bg-[#32363B]/95 rounded-3xl flex-row items-center justify-between px-3 border border-white/10 opacity-70"
    >
      {/* Home */}
      <TouchableOpacity 
        onPress={() => router.push('/(tabs)/home')}
        className={`w-12 h-12 rounded-xl items-center justify-center border border-white/5 ${isActive('home') ? 'bg-[#41464C]' : ''}`}
      >
        <Ionicons name="home" size={22} color={isActive('home') ? COLORS.siplyLime : "white"} />
      </TouchableOpacity>

      {/* Find (Map) */}
      <TouchableOpacity 
        onPress={() => router.push('/(tabs)/find')}
        className={`w-12 h-12 rounded-xl items-center justify-center border border-white/5 ${isActive('find') ? 'bg-[#41464C]' : ''}`}
      >
        <Ionicons name="map-outline" size={22} color={isActive('find') ? COLORS.siplyLime : "white"} />
      </TouchableOpacity>

      {/* Create (Add) */}
      <TouchableOpacity 
        onPress={() => router.push('/(tabs)/create')}
        className="w-10 h-10 items-center justify-center"
      >
         <Ionicons name="add-circle-outline" size={32} color={isActive('create') ? COLORS.siplyLime : "white"} />
      </TouchableOpacity>

      {/* Offers (Price Tags) */}
      <TouchableOpacity 
        onPress={() => router.push('/(tabs)/offers')}
        className={`w-12 h-12 rounded-xl items-center justify-center border border-white/5 ${isActive('offers') ? 'bg-[#41464C]' : ''}`}
      >
        <Ionicons name="pricetag-outline" size={22} color={isActive('offers') ? COLORS.siplyLime : "white"} />
      </TouchableOpacity>

      {/* Profile (Journal/Book) */}
      <TouchableOpacity 
        onPress={() => router.push('/(tabs)/profile')}
        className={`w-12 h-12 rounded-xl items-center justify-center border border-white/5 ${isActive('profile') ? 'bg-[#41464C]' : ''}`}
      >
        <Ionicons name="book-outline" size={22} color={isActive('profile') ? COLORS.siplyLime : "white"} />
      </TouchableOpacity>
    </View>
  );
};