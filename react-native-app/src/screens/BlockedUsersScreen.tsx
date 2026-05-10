import { Ionicons } from '@expo/vector-icons';
import React from 'react';
import { StatusBar, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

interface Props {
  onBack: () => void;
}

export const BlockedUsersScreen = ({ onBack }: Props) => {
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
              <Text className="text-white text-xl font-bold">Blocked Users</Text>
            </View>
          </View>

          {/* Empty State */}
          <View className="flex-1 items-center justify-center px-10 pb-20">
            <Ionicons name="eye-off-outline" size={80} color="#4A4E52" />
            <Text className="text-white text-xl font-bold mt-6 text-center">
              No Blocked Users
            </Text>
            <Text className="text-gray-500 text-sm mt-2 text-center font-medium leading-5">
              Users you block will appear here
            </Text>
          </View>
        </SafeAreaView>
      </View>
    </View>
  );
};