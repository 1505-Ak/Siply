import { Ionicons } from '@expo/vector-icons';
import React from 'react';
import { Modal, Text, TouchableOpacity, TouchableWithoutFeedback, View } from 'react-native';

interface OptionsModalProps {
  visible: boolean;
  onClose: () => void;
  onShare: () => void;
  onDelete: () => void;
}

export const OptionsModal = ({ visible, onClose, onShare, onDelete }: OptionsModalProps) => {
  return (
    <Modal visible={visible} transparent animationType="fade">
      <TouchableWithoutFeedback onPress={onClose}>
        {/* Semi-transparent backdrop */}
        <View className="flex-1 bg-black/20">
          
          {/* Menu Box positioned to align with top-right button */}
          <View 
            style={{ 
                top: 75, 
                right: 24,
                shadowColor: '#000',
                shadowOffset: { width: 0, height: 10 },
                shadowOpacity: 0.5,
                shadowRadius: 20,
                elevation: 10
            }}
            className="absolute w-52 bg-[#2D3035] rounded-[32px] overflow-hidden py-2 border border-white/10 opacity-80"
          >
            {/* Share Option */}
            <TouchableOpacity 
              onPress={() => { onShare(); onClose(); }}
              className="flex-row items-center px-6 py-2"
              activeOpacity={0.7}
            >
              <Ionicons name="share-outline" size={22} color="white" />
              <Text className="text-white text-base font-semibold ml-4">Share</Text>
            </TouchableOpacity>

            {/* Hairline Separator */}
            <View className="h-[1px] bg-white/5 mx-5" />

            {/* Delete Option */}
            <TouchableOpacity 
              onPress={() => { onDelete(); onClose(); }}
              className="flex-row items-center px-6 py-2"
              activeOpacity={0.7}
            >
              <Ionicons name="trash-outline" size={22} color="#EF4444" />
              <Text className="text-[#EF4444] text-base font-semibold ml-4">Delete</Text>
            </TouchableOpacity>
          </View>

        </View>
      </TouchableWithoutFeedback>
    </Modal>
  );
};