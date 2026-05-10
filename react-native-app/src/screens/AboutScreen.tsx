import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { ScrollView, StatusBar, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { COLORS } from '../constants/colors';

interface Props {
  onBack: () => void;
}

export const AboutScreen = ({ onBack }: Props) => {
  return (
    <View style={{ flex: 1, backgroundColor: 'rgba(0,0,0,0.5)' }}>
      <StatusBar barStyle="light-content" />
      <View className="flex-1 bg-[#24272B] mt-16 rounded-t-[40px] overflow-hidden">
        <SafeAreaView style={{ flex: 1 }} edges={['right', 'left']}>
          {/* Header */}
          <View className="flex-row items-center px-6 py-5 border-b border-white/5">
            <TouchableOpacity 
              onPress={onBack} 
              className="bg-[#32363B] w-10 h-10 rounded-full items-center justify-center border border-white/5"
            >
              <Ionicons name="chevron-back" size={24} color="white" />
            </TouchableOpacity>
            <View className="flex-1 items-center mr-10">
              <Text className="text-white text-xl font-bold">About Siply</Text>
            </View>
          </View>

          <ScrollView className="flex-1 px-6" showsVerticalScrollIndicator={false}>
            {/* Logo Section */}
            <View className="items-center mt-10 mb-8">
              <View className="w-24 h-24 rounded-full border border-siplyLime/30 items-center justify-center bg-siplyLime/5">
                <View className="w-20 h-20 rounded-full border-2 border-siplyLime/50 items-center justify-center">
                  <Text className="text-siplyLime font-bold text-4xl">S</Text>
                </View>
              </View>
              <Text className="text-white text-5xl font-bold tracking-tighter mt-4">Siply</Text>
              <Text className="text-gray-500 text-base mt-2">Version 1.0.0</Text>
            </View>

            {/* About Card */}
            <View className="bg-[#32363B] p-6 rounded-3xl border border-white/5 mb-6">
              <Text className="text-white text-lg font-bold mb-3">About</Text>
              <Text className="text-gray-400 text-base leading-6">
                Siply is your personal drink journal and discovery app. Track, rate, and discover amazing drinks from around the world.
              </Text>
            </View>

            {/* Links */}
            <TouchableOpacity className="bg-[#32363B] h-16 rounded-2xl flex-row items-center px-5 mb-3 border border-white/5">
              <Ionicons name="link" size={22} color={COLORS.siplyLime} />
              <Text className="text-white text-base font-medium ml-4 flex-1">Website</Text>
              <MaterialCommunityIcons name="arrow-top-right" size={20} color="#4B5563" />
            </TouchableOpacity>

            <TouchableOpacity className="bg-[#32363B] h-16 rounded-2xl flex-row items-center px-5 mb-10 border border-white/5">
              <Ionicons name="mail" size={22} color={COLORS.siplyLime} />
              <Text className="text-white text-base font-medium ml-4 flex-1">Support</Text>
              <MaterialCommunityIcons name="arrow-top-right" size={20} color="#4B5563" />
            </TouchableOpacity>
          </ScrollView>
        </SafeAreaView>
      </View>
    </View>
  );
};