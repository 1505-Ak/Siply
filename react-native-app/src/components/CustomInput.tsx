import React from "react";
import { Text, TextInput, View } from "react-native";

interface Props {
  label: string;
  placeholder?: string;
  secureTextEntry?: boolean;
  value: string;
  onChangeText: (text: string) => void;
}

export const CustomInput = ({
  label,
  placeholder,
  secureTextEntry,
  value,
  onChangeText,
}: Props) => (
  <View className="w-full mb-5">
    <Text className="text-gray-400 text-base mb-2 ml-1">{label}</Text>
    <TextInput
      value={value}
      autoCapitalize="none"
      onChangeText={onChangeText}
      placeholder={placeholder}
      placeholderTextColor="#6B7280"
      secureTextEntry={secureTextEntry}
      className="w-full h-14 leading-tight bg-[#4A4E52] rounded-xl px-4 text-white text-lg border border-transparent focus:border-siplyLime"
    />
  </View>
);
