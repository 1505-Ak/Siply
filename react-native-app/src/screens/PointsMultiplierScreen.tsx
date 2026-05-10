import { Ionicons } from '@expo/vector-icons';
import React from 'react';
import { StatusBar, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

interface Props {
  onBack: () => void;
}

export const PointsMultiplierScreen = ({ onBack }: Props) => {
  return (
    <View style={{ flex: 1, backgroundColor: '#24272B' }}>
      <StatusBar barStyle="light-content" />
      <SafeAreaView style={{ flex: 1 }} edges={['top']}>
        
        {/* --- HEADER --- */}
        <View className="px-6 py-4">
          <TouchableOpacity 
            onPress={onBack} 
            activeOpacity={0.7}
            className="bg-[#32363B] w-10 h-10 rounded-full items-center justify-center border border-white/5"
          >
            <Ionicons name="chevron-back" size={24} color="white" />
          </TouchableOpacity>
        </View>

        {/* --- CENTERED CONTENT --- */}
        <View className="flex-1 items-center justify-center px-10 pb-20">
          <Text className="text-white text-3xl font-bold text-center tracking-tight">
            Points Multiplier
          </Text>
          <Text className="text-gray-500 text-base text-center mt-4 leading-6 font-medium">
            Coming soon. In the meantime, explore discounts and venues.
          </Text>
        </View>

      </SafeAreaView>
    </View>
  );
};