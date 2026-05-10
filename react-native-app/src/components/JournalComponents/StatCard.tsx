import { FontAwesome, MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Text, View } from 'react-native';

export const StatCard = ({ label, value, icon, type }: any) => (
  <View className="flex-1 bg-[#32363B] p-4 rounded-xl items-center border border-white/5 mx-1">
    <View className="flex-row items-center mb-1">
      {type === 'star' ? (
        <FontAwesome name="star" size={16} color="#FF4D4D" />
      ) : (
        <MaterialCommunityIcons name={icon} size={18} color={type === 'drink' ? '#D0FF14' : '#BF875D'} />
      )}
      <Text className="text-white text-xl font-bold ml-2">{value}</Text>
    </View>
    <Text className="text-gray-500 text-[10px] font-medium capitalize tracking-wider">{label}</Text>
  </View>
);