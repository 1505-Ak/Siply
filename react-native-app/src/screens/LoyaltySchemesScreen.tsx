import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import React, { useEffect, useState } from 'react';
import { ScrollView, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { COLORS } from '../constants/colors';
import { offersService } from '../services/offers.service';

// Added onNavigate to the props interface
export const LoyaltySchemesScreen = ({ onBack, onNavigate }: { onBack: () => void; onNavigate: (id: string) => void }) => {
  const [list, setList] = useState<any[]>([]);

  useEffect(() => {
    offersService.getLoyaltyPrograms().then(setList);
  }, []);

  return (
    <View style={{ flex: 1, backgroundColor: '#24272B' }}>
      <SafeAreaView style={{ flex: 1 }} edges={['top']}>
        {/* Header */}
        <View className="flex-row items-center px-6 py-4">
          <TouchableOpacity onPress={onBack} className="flex-row items-center">
            <Ionicons name="chevron-back" size={24} color={COLORS.siplyLime} />
            <Text className="text-siplyLime text-lg font-bold ml-1">Back</Text>
          </TouchableOpacity>
          <Text className="text-white text-2xl font-bold ml-6">Loyalty Schemes</Text>
        </View>

        <ScrollView className="px-6" showsVerticalScrollIndicator={false} contentContainerStyle={{ paddingBottom: 160 }}>
          {/* Search Bar */}
          <View className="bg-[#1A1D21] flex-row items-center px-4 h-14 rounded-2xl mt-4 mb-8 border border-white/5">
            <Ionicons name="search" size={20} color="gray" />
            <TextInput placeholder="Search programs..." placeholderTextColor="#4B5563" className="flex-1 ml-3 text-white text-base" />
          </View>

          {list.map((item) => (
            <TouchableOpacity 
              key={item.id} 
              onPress={() => onNavigate(item.id)} // Triggers navigation when an item is clicked
              activeOpacity={0.8}
              className="bg-[#32363B] p-5 rounded-3xl flex-row items-center mb-4 border border-white/5 shadow-sm"
            >
              <View style={{ backgroundColor: `${item.color}30` }} className="w-14 h-14 rounded-2xl items-center justify-center">
                 <MaterialCommunityIcons name={item.icon} size={28} color={item.color} />
              </View>
              <View className="ml-4 flex-1">
                <Text className="text-white text-lg font-bold">{item.name}</Text>
                <Text className="text-gray-500 text-xs mt-1 font-medium">{item.desc}</Text>
              </View>
              <View className="flex-row items-center">
                <Text className="text-siplyLime font-bold text-lg mr-3">{item.count}</Text>
                <Ionicons name="chevron-forward" size={20} color="#4B5563" />
              </View>
            </TouchableOpacity>
          ))}
        </ScrollView>
      </SafeAreaView>
    </View>
  );
};