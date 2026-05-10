import { Ionicons } from '@expo/vector-icons';
import React, { useEffect, useState } from 'react';
import { ScrollView, StatusBar, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { VisitCard } from '../components/OfferComponents/VisitCard';
import { COLORS } from '../constants/colors';
import { offersService } from '../services/offers.service';

interface Props {
  onBack: () => void;
}

export const VisitCounterScreen = ({ onBack }: Props) => {
  const [cards, setCards] = useState<any[]>([]);

  useEffect(() => {
    offersService.getVisitCards().then(setCards);
  }, []);

  return (
    <View style={{ flex: 1, backgroundColor: '#24272B' }}>
      <StatusBar barStyle="light-content" />
      <SafeAreaView style={{ flex: 1 }} edges={['top']}>
        
        {/* Header */}
        <View className="flex-row items-center px-6 py-4">
          <TouchableOpacity onPress={onBack} className="flex-row items-center">
            <Ionicons name="chevron-back" size={24} color={COLORS.siplyLime} />
            <Text className="text-siplyLime text-lg font-bold ml-1">Back</Text>
          </TouchableOpacity>
          <Text className="text-white text-2xl font-bold ml-6">Visit Counter Cards</Text>
        </View>

        <View className="flex-1 px-6">
          {/* Search Bar */}
          <View className="bg-[#1A1D21] flex-row items-center px-4 h-14 rounded-2xl mt-4 mb-8 border border-white/5">
            <Ionicons name="search" size={20} color="#4B5563" />
            <TextInput 
              placeholder="Search..." 
              placeholderTextColor="#4B5563" 
              className="flex-1 ml-3 text-white text-base" 
            />
          </View>

          {/* List */}
          <ScrollView 
            className="flex-1"
            showsVerticalScrollIndicator={false}
            contentContainerStyle={{ paddingBottom: 140 }}
          >
            {cards.map((item) => (
              <VisitCard key={item.id} item={item} />
            ))}
          </ScrollView>
        </View>

      </SafeAreaView>
    </View>
  );
};