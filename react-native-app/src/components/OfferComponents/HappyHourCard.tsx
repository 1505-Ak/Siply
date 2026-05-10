import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Text, TouchableOpacity, View } from 'react-native';
import { COLORS } from '../../constants/colors';

export const HappyHourCard = ({ venue }: any) => {
  return (
    <View className="bg-[#32363B] rounded-3xl mb-4 overflow-hidden border border-white/5 shadow-sm">
      <View className="p-5 flex-row items-center">
        {/* Venue Icon */}
        <View className="w-14 h-14 bg-[#454A50] rounded-2xl items-center justify-center">
          <MaterialCommunityIcons 
            name={venue.image === 'coffee' ? 'coffee' : 'donut'} 
            size={28} 
            color="white" 
          />
        </View>

        {/* Info & Schedule */}
        <View className="ml-4 flex-1">
          <Text className="text-white text-lg font-bold">{venue.name}</Text>
          <View className="flex-row items-center mt-1">
            <Ionicons name="time-outline" size={14} color="#FFA500" />
            <Text className="text-[#FFA500] text-xs font-bold ml-1">{venue.time}</Text>
          </View>
          <Text className="text-gray-500 text-[10px] mt-1 font-medium">
            {venue.days}
          </Text>
        </View>

        {/* Heart Icon */}
        <TouchableOpacity>
          <Ionicons name="heart-outline" size={24} color={COLORS.siplyMagenta} />
        </TouchableOpacity>
      </View>

      {/* Earthy Footer Deal Section */}
      <View className="bg-[#4E443B] p-4 flex-row items-center">
        <MaterialCommunityIcons name="white-balance-sunny" size={18} color="#FFA500" />
        <Text className="text-white text-[13px] ml-3 font-bold">
          {venue.deal}
        </Text>
      </View>
    </View>
  );
};