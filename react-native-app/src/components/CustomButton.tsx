import React from 'react';
import { Text, TouchableOpacity } from 'react-native';

interface Props {
  title: string;
  onPress: () => void;
}

export const CustomButton = ({ title, onPress }: Props) => (
  <TouchableOpacity 
    activeOpacity={0.8}
    onPress={onPress}
    className="w-full h-14 bg-siplyLime rounded-xl items-center justify-center mt-4"
  >
    <Text className="text-black text-xl font-bold">{title}</Text>
  </TouchableOpacity>
);