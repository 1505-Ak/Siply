import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Text, TouchableOpacity, View } from 'react-native';
import { COLORS } from '../../constants/colors';

export const VenueDiscountCard = ({ venue }: any) => {
  return (
    <View className="bg-[#32363B] rounded-3xl mb-4 overflow-hidden border border-white/5 shadow-sm">
      {/* Upper Section */}
      <View className="p-5 flex-row items-center">
        {/* Venue Icon */}
        <View className="w-14 h-14 bg-[#454A50] rounded-2xl items-center justify-center">
          <MaterialCommunityIcons 
            name={venue.image === 'coffee' ? 'coffee' : 'donut'} 
            size={28} 
            color="white" 
          />
        </View>

        {/* Venue Info */}
        <View className="ml-4 flex-1">
          <Text className="text-white text-lg font-bold">{venue.name}</Text>
          <Text className="text-gray-500 text-xs font-medium">{venue.address}</Text>
          <Text className="text-siplyLime text-[11px] font-bold mt-1 uppercase">
            {venue.distance}
          </Text>
        </View>

        {/* Heart Icon */}
        <TouchableOpacity>
          <Ionicons name="heart-outline" size={24} color={COLORS.siplyMagenta} />
        </TouchableOpacity>
      </View>

      {/* Lower Section (Deals) */}
      {venue.deals && venue.deals.length > 0 && (
        <View className="bg-white/5 p-4 gap-2.5 border-t border-white/5">
          {venue.deals.map((deal: any, index: number) => (
            <View key={index} className="flex-row items-center justify-between">
              <View className="flex-row items-center">
                <MaterialCommunityIcons name="tag" size={14} color={COLORS.siplyMagenta} />
                <Text className="text-gray-300 text-xs ml-2 font-medium">{deal.label}</Text>
              </View>
              
              {/* Lime Discount Pill */}
              {deal.value && (
                <View className="bg-siplyLime/20 px-2 py-0.5 rounded-lg border border-siplyLime/30">
                  <Text className="text-siplyLime text-[10px] font-bold uppercase">
                    {deal.value}
                  </Text>
                </View>
              )}
            </View>
          ))}
        </View>
      )}
    </View>
  );
};