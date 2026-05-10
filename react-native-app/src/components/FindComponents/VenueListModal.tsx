import { Ionicons } from '@expo/vector-icons';
import React from 'react';
import { FlatList, Modal, SafeAreaView, Text, TextInput, TouchableOpacity, View } from 'react-native';

export const VenueListModal = ({ visible, onClose, onSelect, venues }: any) => {
  return (
    <Modal visible={visible} animationType="slide" transparent={false}>
      <View style={{ flex: 1, backgroundColor: '#24272B' }}>
        <SafeAreaView className="flex-1">
          <View className="px-6 py-4 border-b border-gray-800 pb-8">
            <TouchableOpacity 
              onPress={onClose}
              className="bg-siplyLime/10 self-start px-5 py-2 rounded-full border border-siplyLime/30"
            >
              <Text className="text-siplyLime font-bold text-base">Close</Text>
            </TouchableOpacity>
          </View>

          <View className="bg-[#1A1D21] px-6 py-5 flex-row items-center">
            <Ionicons name="search" size={20} color="gray" />
            <TextInput 
                placeholder="Search drinks or location" 
                placeholderTextColor="#4B5563"
                className="flex-1 ml-4 text-white text-base"
            />
          </View>

          <FlatList
            data={venues}
            keyExtractor={(item) => item.id}
            contentContainerStyle={{ paddingHorizontal: 24, paddingVertical: 24 }}
            renderItem={({ item }) => (
              <TouchableOpacity 
                onPress={() => onSelect(item)}
                className="bg-[#32363B] flex-row items-center p-4 rounded-xl mb-6 border border-white/5"
              >
                <View className="flex-1">
                  <Text className="text-white text-lg font-semibold">{item.name}</Text>
                  <Text className="text-gray-500 text-sm mt-1">{item.venue}</Text>
                </View>
                <Ionicons name="chevron-forward" size={20} color="gray" />
              </TouchableOpacity>
            )}
          />
        </SafeAreaView>
      </View>
    </Modal>
  );
};