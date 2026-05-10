import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { ScrollView, StatusBar, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { COLORS } from '../constants/colors';

interface FavoritesScreenProps {
  onBack: () => void;
  favorites: any[];
}

export const FavoritesScreen = ({ onBack, favorites }: FavoritesScreenProps) => {
  return (
    <View style={{ flex: 1, backgroundColor: '#24272B' }}>
      <StatusBar barStyle="light-content" />
      <SafeAreaView style={{ flex: 1 }} edges={['top']}>
        
        {/* --- HEADER --- */}
        <View className="flex-row items-center px-6 py-4">
          <TouchableOpacity onPress={onBack} className="flex-row items-center">
            <Ionicons name="chevron-back" size={24} color={COLORS.siplyLime} />
            <Text className="text-siplyLime text-lg font-bold ml-1">Back</Text>
          </TouchableOpacity>
          <Text className="text-white text-2xl font-bold ml-6">My Favorites</Text>
        </View>

        <View className="flex-1 px-6">
          {/* --- SEARCH BAR --- */}
          <View className="bg-[#32363B] flex-row items-center px-4 h-14 rounded-2xl mt-4 border border-white/5">
            <Ionicons name="search" size={20} color="#6B7280" />
            <TextInput 
              placeholder="Search favorites..." 
              placeholderTextColor="#6B7280" 
              className="flex-1 ml-3 text-white text-base" 
            />
          </View>

          {/* --- CONTENT / EMPTY STATE --- */}
          <ScrollView 
            contentContainerStyle={{ flexGrow: 1, justifyContent: 'center', paddingBottom: 100 }}
            showsVerticalScrollIndicator={false}
          >
            {favorites.length === 0 ? (
              <View className="items-center justify-center">
                {/* Broken Heart Icon */}
                <MaterialCommunityIcons 
                  name="heart-off-outline" 
                  size={100} 
                  color="#4A4E52" 
                />
                <Text className="text-white text-2xl font-bold mt-8 text-center">
                  No favorites yet
                </Text>
                <Text className="text-gray-500 text-sm mt-3 text-center px-10 leading-5 font-medium">
                  Heart venues to add them to your favorites
                </Text>
              </View>
            ) : (
              <View>
                {/* This section will render actual cards when favorites array has data */}
                <Text className="text-white">Favorites list goes here</Text>
              </View>
            )}
          </ScrollView>
        </View>

      </SafeAreaView>
    </View>
  );
};