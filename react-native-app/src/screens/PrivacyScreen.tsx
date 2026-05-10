import { Ionicons } from '@expo/vector-icons';
import React from 'react';
import { StatusBar, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

interface Props {
  onBack: () => void;
}

export const PrivacyScreen = ({ onBack }: Props) => {
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
              <Text className="text-white text-xl font-bold">Privacy</Text>
            </View>
          </View>

          {/* Centered Content */}
          <View className="flex-1 items-center justify-center">
            <Text className="text-white text-xl font-medium">Privacy Settings</Text>
          </View>
        </SafeAreaView>
      </View>
    </View>
  );
};