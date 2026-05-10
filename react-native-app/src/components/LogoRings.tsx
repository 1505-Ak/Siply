import React from 'react';
import { Text, View } from 'react-native';
import { COLORS } from '../constants/colors';

const LogoRings = () => {
  return (
    <View className="items-center justify-center">
      {/* Outer Ring - Very Faint */}
      <View 
        style={{ borderColor: 'rgba(208, 255, 20, 0.08)' }}
        className="w-72 h-72 rounded-full border-[1px] items-center justify-center"
      >
        {/* Middle Ring - Slightly clearer */}
        <View 
          style={{ borderColor: 'rgba(208, 255, 20, 0.15)' }}
          className="w-56 h-56 rounded-full border-[1px] items-center justify-center"
        >
          {/* Inner Ring - Strongest Border */}
          <View 
            style={{ borderColor: 'rgba(208, 255, 20, 0.3)' }}
            className="w-44 h-44 rounded-full border-[2px] items-center justify-center"
          >
            {/* Core Circle with Glow Effect */}
            <View 
              style={{ 
                backgroundColor: 'rgba(208, 255, 20, 0.12)',
                shadowColor: COLORS.siplyLime,
                shadowOffset: { width: 0, height: 0 },
                shadowOpacity: 0.5,
                shadowRadius: 20,
                elevation: 10 // For Android shadow
              }}
              className="w-32 h-32 rounded-full items-center justify-center border border-siplyLime/40"
            >
              <Text 
                className="text-siplyLime text-6xl font-bold"
                style={{ includeFontPadding: false, textAlignVertical: 'center' }}
              >
                S
              </Text>
            </View>
          </View>
        </View>
      </View>
    </View>
  );
};

export default LogoRings;