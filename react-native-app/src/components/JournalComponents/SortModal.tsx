import { Ionicons, MaterialCommunityIcons } from '@expo/vector-icons';
import React from 'react';
import { Modal, Text, TouchableOpacity, TouchableWithoutFeedback, View } from 'react-native';

const OPTIONS = [
  { id: 'newest', label: 'Date (Newest)', icon: 'calendar-month', type: 'mc' },
  { id: 'oldest', label: 'Date (Oldest)', icon: 'calendar-blank', type: 'mc' },
  { id: 'high', label: 'Rating (Highest)', icon: 'star', type: 'io' },
  { id: 'low', label: 'Rating (Lowest)', icon: 'star-outline', type: 'io' },
  { id: 'name', label: 'Name (A-Z)', icon: 'format-letter-case', type: 'mc' },
];

export const SortModal = ({ visible, onClose, onSelect, currentSort }: any) => {
  return (
    <Modal visible={visible} transparent animationType="fade">
      <TouchableWithoutFeedback onPress={onClose}>
        {/* The Backdrop */}
        <View className="flex-1 bg-black/40 opacity-90">
          {/* The Menu Box - Positioned absolutely to match the design */}
          <View 
            style={{ top: 70, right: 24 }}
            className="absolute w-[240px] bg-[#2D3035] rounded-[32px] overflow-hidden py-2 shadow-2xl border border-white/10"
          >
            {OPTIONS.map((opt) => (
              <TouchableOpacity 
                key={opt.id} 
                onPress={() => onSelect(opt.label)}
                activeOpacity={0.7}
                className="flex-row items-center px-5 py-3"
              >
                {/* Left Section: Checkmark (Fixed width so icons align) */}
                <View className="w-6 items-center justify-center">
                  {currentSort === opt.label && (
                    <Ionicons name="checkmark" size={18} color="white" />
                  )}
                </View>

                {/* Center Section: Icon */}
                <View className="mx-3">
                  {opt.type === 'mc' ? (
                    <MaterialCommunityIcons name={opt.icon as any} size={20} color="white" />
                  ) : (
                    <Ionicons name={opt.icon as any} size={20} color="white" />
                  )}
                </View>

                {/* Right Section: Text */}
                <Text className="text-white text-[15px] font-medium flex-1">
                  {opt.label}
                </Text>
              </TouchableOpacity>
            ))}
          </View>
        </View>
      </TouchableWithoutFeedback>
    </Modal>
  );
};