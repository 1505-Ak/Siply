import { Ionicons } from '@expo/vector-icons';
import React, { useState } from 'react';
import { FlatList, Modal, SafeAreaView, Text, TextInput, TouchableOpacity, View } from 'react-native';

export const CitySelectModal = ({ visible, onClose, onSelect, cities, selectedCityId }: any) => {
  const [search, setSearch] = useState('');
  const filtered = cities.filter((c: any) => c.name.toLowerCase().includes(search.toLowerCase()));

  return (
    <Modal visible={visible} animationType="slide" transparent={false}>
      <View style={{ flex: 1, backgroundColor: '#24272B' }}>
        <SafeAreaView className="flex-1">
          <View className="flex-row justify-between items-center px-6 py-4">
            <Text className="text-white text-2xl font-semibold">Select Location</Text>
            <TouchableOpacity onPress={onClose}>
              <Text className="text-siplyLime text-lg font-semibold">Done</Text>
            </TouchableOpacity>
          </View>

          <View className="px-6 mb-6">
            <View className="bg-[#32363B] flex-row items-center px-4 h-14 rounded-xl border border-white/5">
              <Ionicons name="search" size={20} color="gray" />
              <TextInput 
                placeholder="Search cities..." 
                placeholderTextColor="#6B7280"
                className="flex-1 ml-3 text-white text-base"
                value={search}
                onChangeText={setSearch}
              />
            </View>
          </View>

          <FlatList
            data={filtered}
            keyExtractor={(item) => item.id}
            contentContainerStyle={{ paddingHorizontal: 24, paddingBottom: 40 }}
            renderItem={({ item }) => (
              <TouchableOpacity 
                onPress={() => onSelect(item)}
                className={`flex-row items-center p-4 rounded-xl mb-4 border border-white/5 ${selectedCityId === item.id ? 'bg-[#404530]' : 'bg-[#32363B]'}`}
              >
                <View className="w-5 h-5 rounded-full bg-siplyLime items-center justify-center">
                  <Ionicons name="location" size={10} color="black" />
                </View>
                <View className="ml-4 flex-1">
                  <Text className="text-white text-lg font-bold">{item.name}</Text>
                  <Text className="text-gray-500 text-xs uppercase font-medium">{item.country}</Text>
                </View>
                {selectedCityId === item.id && (
                  <Ionicons name="checkmark-circle" size={20} color="#D0FF14" />
                )}
              </TouchableOpacity>
            )}
          />
        </SafeAreaView>
      </View>
    </Modal>
  );
};