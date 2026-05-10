import React, { useState } from 'react';
import { ScrollView, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import { CustomButton } from '../../../src/components/CustomButton';
import { CustomInput } from '../../../src/components/CustomInput';
import { API_URL } from '../../../src/constants/api';
import { storageService } from '../../../src/services/storage.service';

export default function CreateRoute() {
  const [name, setName] = useState('');
  const [notes, setNotes] = useState('');
  const [isPosting, setIsPosting] = useState(false);

  const handlePost = async () => {
    const trimmedName = name.trim();
    if (!trimmedName) {
      alert('Please enter a drink name.');
      return;
    }

    const token = await storageService.getAccessToken();
    if (!token) {
      alert('You are not logged in. Please sign in again.');
      return;
    }

    setIsPosting(true);
    try {
      const response = await fetch(`${API_URL}/drinks`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          name: trimmedName,
          category: 'Coffee',
          rating: 4,
          notes: notes.trim() || null,
          tags: [],
          isFavorite: false,
        }),
      });

      const data = await response.json();
      if (!response.ok) {
        alert(data?.message || 'Failed to post drink.');
        return;
      }

      setName('');
      setNotes('');
      alert('Drink posted to feed.');
    } catch (error) {
      alert('Could not post. Please check your connection.');
    } finally {
      setIsPosting(false);
    }
  };

  return (
    <View style={{ flex: 1, backgroundColor: '#24272B' }}>
      <SafeAreaView style={{ flex: 1 }} edges={['top']}>
        <ScrollView className="px-6" contentContainerStyle={{ paddingBottom: 120 }}>
          <Text className="text-white text-3xl font-bold mt-4 mb-8">Log Drink</Text>
          
          <CustomInput label="Drink Name" value={name} onChangeText={setName} placeholder="e.g. Iced Oat Latte" />
          <CustomInput label="Location" value="" onChangeText={() => {}} placeholder="Search venue..." />
          <CustomInput label="Notes" value={notes} onChangeText={setNotes} placeholder="How was the taste?" />
          
          <View className="mt-4">
             <CustomButton title={isPosting ? "Posting..." : "Post to Feed"} onPress={handlePost} />
          </View>
        </ScrollView>
      </SafeAreaView>
    </View>
  );
}