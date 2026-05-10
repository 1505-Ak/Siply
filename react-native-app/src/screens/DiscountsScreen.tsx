import { Ionicons } from '@expo/vector-icons';
import React, { useEffect, useState } from 'react';
import { ScrollView, StatusBar, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { COLORS } from '../constants/colors';
import { offersService } from '../services/offers.service';

interface DiscountsScreenProps {
  onBack: () => void;
  onNavigateToCategory: (id: string) => void;
}

export const DiscountsScreen = ({ onBack, onNavigateToCategory }: DiscountsScreenProps) => {
  const [categories, setCategories] = useState<any[]>([]);

  useEffect(() => {
    offersService.getDiscountCategories().then(setCategories);
  }, []);

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
          <Text className="text-white text-2xl font-bold ml-6">Discounts</Text>
        </View>

        <ScrollView className="flex-1 px-6" showsVerticalScrollIndicator={false}>
          
          <View className="bg-[#32363B] flex-row items-center px-4 h-14 rounded-2xl mt-4 border border-white/5">
            <Ionicons name="search" size={20} color="#6B7280" />
            <TextInput 
              placeholder="Search venues..." 
              placeholderTextColor="#6B7280" 
              className="flex-1 ml-3 text-white text-base" 
            />
          </View>

          <Text className="text-white text-2xl font-bold mt-10 mb-6">Featured</Text>

          {/* --- 2x2 GRID --- */}
          <View className="flex-row flex-wrap justify-between">
            {categories.map((cat) => (
              <TouchableOpacity 
                key={cat.id} 
                onPress={() => onNavigateToCategory(cat.id)} // THIS MUST MATCH THE ROUTE FILENAME
                activeOpacity={0.8}
                className="w-[48%] bg-[#32363B] p-6 rounded-3xl items-center mb-4 border border-white/5 shadow-sm"
              >
                <View 
                  style={{ backgroundColor: `${cat.color}20` }} 
                  className="w-16 h-16 rounded-full items-center justify-center mb-4"
                >
                   <Ionicons name={cat.icon} size={30} color={cat.color} />
                </View>

                <Text className="text-white font-bold text-center text-base leading-5">
                  {cat.name}
                </Text>
                <Text className="text-gray-500 text-xs mt-1">
                  {cat.count} places
                </Text>
              </TouchableOpacity>
            ))}
          </View>

        </ScrollView>
      </SafeAreaView>
    </View>
  );
};