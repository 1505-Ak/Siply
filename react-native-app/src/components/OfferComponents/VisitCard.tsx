import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Text, TouchableOpacity, View } from 'react-native';

export const VisitCard = ({ item }: any) => {
  // Calculate percentage for the progress bar
  const progress = (item.currentVisits / item.goalVisits) * 100;

  return (
    <TouchableOpacity 
      activeOpacity={0.8}
      className="bg-[#32363B] rounded-3xl mb-4 p-5 border border-white/5 shadow-sm"
    >
      <View className="flex-row items-center justify-between mb-4">
        <View className="flex-row items-center">
          {/* Icon */}
          <View className="w-12 h-12 bg-[#454A50] rounded-2xl items-center justify-center">
            <MaterialCommunityIcons name={item.icon} size={24} color="white" />
          </View>
          
          {/* Text Info */}
          <View className="ml-4">
            <Text className="text-white text-lg font-bold">{item.name}</Text>
            <Text className="text-gray-500 text-xs font-medium">
              {item.currentVisits}/{item.goalVisits} visits
            </Text>
          </View>
        </View>

        <Ionicons name="chevron-forward" size={20} color="#4B5563" />
      </View>

      {/* Progress Bar Track */}
      <View className="h-1.5 w-full bg-[#454A50] rounded-full overflow-hidden">
        <View 
          style={{ width: `${progress}%` }} 
          className="h-full bg-siplyLime rounded-full" 
        />
      </View>
    </TouchableOpacity>
  );
};