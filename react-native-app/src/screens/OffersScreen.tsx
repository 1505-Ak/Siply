import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import React, { useEffect, useState } from 'react';
import { ScrollView, StatusBar, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { COLORS } from '../constants/colors';
import { offersService } from '../services/offers.service';

export const OffersScreen = ({ onNavigate }: any) => {
  const [data, setData] = useState<any>(null);

  useEffect(() => {
    offersService.getOverview().then(setData);
  }, []);

  return (
    <View style={{ flex: 1, backgroundColor: '#24272B' }}>
      <StatusBar barStyle="light-content" />
      <SafeAreaView style={{ flex: 1 }} edges={['top']}>
        
        {/* Header */}
        <View className="flex-row justify-between items-center px-6 py-4">
          <Text className="text-white text-3xl font-bold">Deals</Text>
          <View className="bg-[#32363B] flex-row items-center px-3 py-1.5 rounded-full border border-white/5">
            <Ionicons name="star" size={16} color={COLORS.siplyLime} />
            <Text className="text-white font-bold ml-2">{data?.userPoints || 0}</Text>
          </View>
        </View>

        <ScrollView className="px-6" showsVerticalScrollIndicator={false}>
          <View className="mt-4 mb-10">
            <Text className="text-white text-4xl font-bold tracking-tight">Save more with Siply</Text>
            <Text className="text-gray-500 text-base mt-2 leading-6">
              Unlock exclusive deals and earn rewards at your favorite spots
            </Text>
          </View>

          {/* Discounts Entry Card */}
          <TouchableOpacity 
            onPress={() => onNavigate('discounts')}
            className="bg-[#32363B] p-6 rounded-2xl flex-row items-center mb-6 border border-white/5 shadow-sm"
          >
            <View className="w-16 h-16 bg-[#6C244C]/30 rounded-2xl items-center justify-center">
              <MaterialCommunityIcons name="tag" size={32} color="#6C244C" />
            </View>
            <View className="ml-5 flex-1">
              <Text className="text-white text-xl font-semibold">Discounts</Text>
              <Text className="text-gray-500 text-sm mt-1">Find deals near you</Text>
              <Text className="text-siplyLime text-xs mt-2">{data?.discountsCount} venues with deals</Text>
            </View>
            <Ionicons name="chevron-forward" size={24} color="#4B5563" />
          </TouchableOpacity>

          {/* Loyalty Entry Card */}
          <TouchableOpacity 
            onPress={() => onNavigate('loyalty')}
            className="bg-[#32363B] p-6 rounded-2xl flex-row items-center border border-white/5 shadow-sm"
          >
            <View className="w-16 h-16 bg-siplyLime rounded-2xl items-center justify-center">
              <Ionicons name="star" size={32} color="black" />
            </View>
            <View className="ml-5 flex-1">
              <Text className="text-white text-xl font-semibold">Loyalty Schemes</Text>
              <Text className="text-gray-500 text-sm mt-1">Track your rewards</Text>
              <Text className="text-siplyLime text-xs mt-2">{data?.loyaltyProgramsCount} programs available</Text>
            </View>
            <Ionicons name="chevron-forward" size={24} color="#4B5563" />
          </TouchableOpacity>

        </ScrollView>
      </SafeAreaView>
    </View>
  );
};