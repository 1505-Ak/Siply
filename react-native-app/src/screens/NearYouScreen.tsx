import { Ionicons } from '@expo/vector-icons';
import React from 'react';
import { ScrollView, StatusBar, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { VenueDiscountCard } from '../components/OfferComponents/VenueDiscountCard';
import { COLORS } from '../constants/colors';

interface NearYouScreenProps {
  onBack: () => void;
  venues: any[];
}

export const NearYouScreen = ({ onBack, venues }: NearYouScreenProps) => {
  return (
    <View style={{ flex: 1, backgroundColor: '#24272B' }}>
      <StatusBar barStyle="light-content" />
      <SafeAreaView style={{ flex: 1 }} edges={['top']}>
        
        {/* --- HEADER --- */}
        <View className="px-6 py-4">
          <TouchableOpacity onPress={onBack} className="flex-row items-center">
            <Ionicons name="chevron-back" size={24} color={COLORS.siplyLime} />
            <Text className="text-siplyLime text-lg font-bold ml-1">Back</Text>
          </TouchableOpacity>
          <View className="mt-4">
            <Text className="text-white text-3xl font-bold">Near You</Text>
            <Text className="text-gray-500 text-sm font-medium mt-1">Discounted drinks nearby</Text>
          </View>
        </View>

        <View className="flex-1 px-6">
          {/* --- SEARCH BAR --- */}
          <View className="bg-[#32363B] flex-row items-center px-4 h-14 rounded-2xl mt-4 border border-white/5 mb-6">
            <Ionicons name="search" size={20} color="#6B7280" />
            <TextInput 
              placeholder="Search nearby..." 
              placeholderTextColor="#6B7280" 
              className="flex-1 ml-3 text-white text-base" 
            />
          </View>

          {/* --- VENUE LIST --- */}
          <ScrollView 
            className="flex-1"
            showsVerticalScrollIndicator={false}
            contentContainerStyle={{ paddingBottom: 140 }}
          >
            {venues.map((venue) => (
              <VenueDiscountCard key={venue.id} venue={venue} />
            ))}
          </ScrollView>
        </View>

      </SafeAreaView>
    </View>
  );
};