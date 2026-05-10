import { FontAwesome, Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Text, TouchableOpacity, View } from 'react-native';

export const JournalItem = ({ item, onPress }: any) => (
  <TouchableOpacity onPress={onPress} activeOpacity={0.8} className="bg-[#32363B] rounded-xl p-4 mb-4 flex-row items-center border border-white/5">
    {/* Icon Container */}
    <View className="w-14 h-14 bg-[#454A50] rounded-xl items-center justify-center">
      <MaterialCommunityIcons name={item.icon} size={28} color="white" />
    </View>

    {/* Content */}
    <View className="flex-1 ml-4">
      <Text className="text-white font-semibold text-lg">{item.name}</Text>
      
      <View className="flex-row items-center mt-1">
        <View className="flex-row gap-2">
          {[1, 2, 3, 4, 5].map((s) => (
            <FontAwesome key={s} name="star" size={14} color={s <= Math.floor(item.rating) ? "#D0FF14" : "#4A4E52"} style={{ marginRight: 2 }} />
          ))}
        </View>
        <Text className="text-gray-500 text-xs ml-2">{item.rating.toFixed(1)}</Text>
      </View>

      <View className="flex-row gap-1 items-center mt-2">
        <Ionicons name="location-sharp" size={12} color="#BF875D" />
        <Text className="text-gray-400 text-[10px] ml-1">{item.venue}, {item.location}</Text>
      </View>
      <Text className="text-gray-400 text-[10px] mt-1">{item.date}</Text>
    </View>

    {/* Favorite Icon */}
    <TouchableOpacity>
      <Ionicons 
        name={item.isFavorite ? "heart" : "heart-outline"} 
        size={24} 
        color={item.isFavorite ? "#FF4D4D" : "#4A4E52"} 
      />
    </TouchableOpacity>
  </TouchableOpacity>
);