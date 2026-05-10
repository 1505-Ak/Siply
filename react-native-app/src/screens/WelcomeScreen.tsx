import { LinearGradient } from 'expo-linear-gradient';
import React from 'react';
import { StatusBar, Text, View } from 'react-native';
import { SafeAreaView } from 'react-native-safe-area-context';
import LogoRings from '../components/LogoRings';
import { COLORS } from '../constants/colors';

const WelcomeScreen = () => {
  return (
    // Add style={{ flex: 1 }} manually to check if Tailwind is the culprit
    <View style={{ flex: 1, backgroundColor: '#3C4044' }} className="flex-1">
      <StatusBar barStyle="light-content" />
      <LinearGradient
        colors={[COLORS.siplyCharcoal, '#2D1B26', '#121212']}
        style={{ flex: 1 }} // Force flex here too
        className="flex-1"
      >
        <SafeAreaView className="flex-1 items-center justify-center px-6">
          
          {/* Central Logo Section */}
          <View className="mb-10 items-center justify-center">
            <LogoRings />
          </View>

          {/* Text Section */}
          <View className="items-center mt-6">
            {/* Main Brand Title */}
            <Text 
              className="text-white text-5xl font-bold tracking-tighter"
              style={{ includeFontPadding: false }}
            >
              Siply
            </Text>
            
            {/* Tagline */}
            <Text 
              className="text-gray-400 text-sm mt-3 tracking-[4px] uppercase font-medium"
            >
              Rate. Discover. Share.
            </Text>
          </View>

        </SafeAreaView>
      </LinearGradient>
    </View>
  );
};

export default WelcomeScreen;