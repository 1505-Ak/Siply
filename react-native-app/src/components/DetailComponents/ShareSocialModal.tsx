import { COLORS } from '@/src/constants/colors';
import { FontAwesome5, Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Modal, SafeAreaView, StatusBar, Text, TouchableOpacity, View } from 'react-native';

interface ShareSocialModalProps {
  visible: boolean;
  onClose: () => void;
  drinkData: any;
}

export const ShareSocialModal = ({ visible, onClose, drinkData }: ShareSocialModalProps) => {
  if (!drinkData) return null;

  return (
    <Modal visible={visible} animationType="slide" transparent={false}>
      <View style={{ flex: 1, backgroundColor: '#24272B' }}>
        <StatusBar barStyle="light-content" />
        <SafeAreaView className="flex-1">
          <View className="flex-row justify-between items-center px-6 py-4">
            <View className="w-10" />
            <Text className="text-white text-xl font-bold">Share to Social Media</Text>
            <TouchableOpacity 
              onPress={onClose}
              className="bg-black/20 p-2 rounded-full border border-siplyLime/20"
            >
              <Text className="text-siplyLime px-1 text-lg">Done</Text>
            </TouchableOpacity>
          </View>

          <View className="px-6 mt-8">
            {/* Drink Preview Card */}
            <View className="bg-[#32363B] p-6 rounded-xl border border-white/5 mb-10">
              <View className="flex-row justify-between items-start">
                <View>
                  <Text className="text-white text-xl font-semibold">{drinkData.name}</Text>
                  <View className="flex-row items-center mt-2">
                    <MaterialCommunityIcons name={drinkData.icon || 'glass-cocktail'} size={18} color={COLORS.siplyLime} />
                    <Text className="text-siplyLime ml-2">{drinkData.category}</Text>
                  </View>
                </View>
                <View className="flex-row items-center  px-3 py-1">
                  <Ionicons name="star" size={14} color={COLORS.siplyLime} />
                  <Text className="text-white font-bold ml-1">{drinkData.rating}</Text>
                </View>
              </View>
              <Text className="text-gray-500 mt-4">
                {drinkData.locationName || drinkData.venue}, {drinkData.locationCity || drinkData.location}
              </Text>
            </View>

            {/* Share Buttons List */}
            <View className="gap-4">
              {/* Instagram */}
              <TouchableOpacity activeOpacity={0.8} className="bg-[#6C244C] h-16 rounded-xl flex-row items-center px-6">
                <Ionicons name="camera" size={24} color="white" />
                <Text className="text-white text-lg font-medium ml-4 flex-1">Share to Instagram</Text>
                <Ionicons name="chevron-forward" size={20} color="white" style={{ opacity: 0.5 }} />
              </TouchableOpacity>

              {/* Twitter */}
              <TouchableOpacity activeOpacity={0.8} className="bg-[#2D4A63] h-16 rounded-xl flex-row items-center px-6">
                <FontAwesome5 name="twitter" size={22} color="white" />
                <Text className="text-white text-lg font-medium ml-4 flex-1">Share to Twitter</Text>
                <Ionicons name="chevron-forward" size={20} color="white" style={{ opacity: 0.5 }} />
              </TouchableOpacity>

              {/* Copy Link */}
              <TouchableOpacity activeOpacity={0.8} className="bg-[#4C5F2D] h-16 rounded-xl flex-row items-center px-6">
                <Ionicons name="link" size={24} color="white" />
                <Text className="text-white text-lg font-medium ml-4 flex-1">Copy Link</Text>
                <Ionicons name="chevron-forward" size={20} color="white" style={{ opacity: 0.5 }} />
              </TouchableOpacity>
            </View>
          </View>
        </SafeAreaView>
      </View>
    </Modal>
  );
};