import { Ionicons } from '@expo/vector-icons';
import React from 'react';
import { ScrollView, StatusBar, Text, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';

interface Props {
  onBack: () => void;
}

export const TermsPrivacyScreen = ({ onBack }: Props) => {
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
              <Text className="text-white text-xl font-bold">Terms & Privacy</Text>
            </View>
          </View>

          <ScrollView className="flex-1 px-6 pt-6" showsVerticalScrollIndicator={false} contentContainerStyle={{ paddingBottom: 60 }}>
            <Text className="text-white text-2xl font-bold">Terms of Service</Text>
            <Text className="text-gray-500 text-sm mt-2 mb-8">Last updated: October 4, 2025</Text>

            <View className="gap-y-8">
              <View>
                <Text className="text-white text-lg font-bold mb-3">1. Acceptance of Terms</Text>
                <Text className="text-gray-400 text-base leading-6">
                  By using Siply, you agree to these terms and conditions.
                </Text>
              </View>

              <View>
                <Text className="text-white text-lg font-bold mb-3">2. User Content</Text>
                <Text className="text-gray-400 text-base leading-6">
                  You retain rights to your content. We store your drink logs locally on your device.
                </Text>
              </View>

              <View>
                <Text className="text-white text-lg font-bold mb-3">3. Privacy</Text>
                <Text className="text-gray-400 text-base leading-6">
                  We respect your privacy. Location data is only used to enhance your experience and is stored locally.
                </Text>
              </View>

              <View>
                <Text className="text-white text-lg font-bold mb-3">4. Changes to Terms</Text>
                <Text className="text-gray-400 text-base leading-6">
                  We may update these terms from time to time. Continued use constitutes acceptance.
                </Text>
              </View>
            </View>
          </ScrollView>
        </SafeAreaView>
      </View>
    </View>
  );
};