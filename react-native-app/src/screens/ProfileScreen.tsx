import { Ionicons, MaterialCommunityIcons } from "@expo/vector-icons";
import { LinearGradient } from "expo-linear-gradient";
import React, { useEffect, useState } from "react";
import {
  ScrollView,
  StatusBar,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { COLORS } from "../constants/colors";
import { profileService } from "../services/profile.service";

export const ProfileScreen = ({ onNavigate, onLogout }: any) => {
  const [user, setUser] = useState<any>(null);
  const [settingsVisible, setSettingsVisible] = useState(false); // New state to control modal

  useEffect(() => {
    profileService.getUserProfile().then(setUser);
  }, []);

  if (!user) return null;

  return (
    <View style={{ flex: 1, backgroundColor: "#24272B" }}>
      <StatusBar barStyle="light-content" />
      <SafeAreaView style={{ flex: 1 }} edges={["top"]}>
        {/* --- HEADER --- */}
        <View className="flex-row justify-between items-center px-6 py-4 border-b border-gray-600">
          <Text className="text-white text-3xl font-bold">Profile</Text>
          <TouchableOpacity
            onPress={() => onNavigate("settings")} // Ensure your app/(tabs)/profile.tsx passes the push logic for 'settings'
            className="bg-[#32363B] w-10 h-10 rounded-full items-center justify-center border border-white/5"
          >
            <Ionicons
              name="settings-sharp"
              size={20}
              color={COLORS.siplyLime}
            />
          </TouchableOpacity>
        </View>

        <ScrollView
          className="flex-1"
          showsVerticalScrollIndicator={false}
          contentContainerStyle={{ paddingBottom: 140 }}
        >
          {/* --- AVATAR SECTION --- */}
          <View className="items-center mt-6 mb-8 gap-2">
            <View className="relative">
              <LinearGradient
                colors={["#7F4B52", "#BED041"]}
                start={{ x: 0.3, y: 0 }}
                end={{ x: 1, y: 1 }}
                style={{
                  width: 128,
                  height: 128,
                  borderRadius: 64,
                  alignItems: "center",
                  justifyContent: "center",
                }}
              >
                <Text className="text-white text-5xl font-bold">A</Text>
              </LinearGradient>
              {/* Small 'S' Badge */}
              {/* <View className="absolute bottom-1 right-1 bg-siplyLime w-8 h-8 rounded-full border-4 border-[#24272B] items-center justify-center">
                <Text className="text-black font-black text-[10px]">S</Text>
              </View> */}
            </View>
            <Text className="text-white text-3xl font-semibold mt-2">
              {user.name}
            </Text>
            <Text className="text-gray-500 text-base">{user.handle}</Text>
          </View>

          {/* --- FOLLOW STATS --- */}
          <View className="flex-row px-6 gap-4 mb-6">
            <LinearGradient
              colors={["#554451", "#646F4A"]}
              start={{ x: 0, y: 0 }}
              end={{ x: 1, y: 1 }}
              style={{
                flex: 1,
                padding: 20,
                borderRadius: 16,
                alignItems: "center",
                justifyContent: "center",
              }}
            >
              <Text className="text-white text-center text-3xl font-semibold">
                {user.followers}
              </Text>
              <Text className="text-gray-500 text-xs text-center font-medium mt-1">
                Followers
              </Text>
            </LinearGradient>
            <LinearGradient
              colors={["#554451", "#646F4A"]}
              start={{ x: 0, y: 0 }}
              end={{ x: 1, y: 1 }}
              style={{
                flex: 1,
                padding: 20,
                borderRadius: 16,
                alignItems: "center",
                justifyContent: "center",
              }}
            >
              <Text className="text-white text-3xl text-center font-semibold">
                {user.following}
              </Text>
              <Text className="text-gray-500 text-xs text-center font-medium mt-1">
                Following
              </Text>
            </LinearGradient>
          </View>

          {/* --- YOUR STATS GRID --- */}
          <Text className="text-white text-xl font-bold px-6 mb-4">
            Your Stats
          </Text>
          <View className="flex-row flex-wrap px-6 justify-between gap-y-4">
            {/* Drinks */}
            <View className="w-[48%] bg-[#32363B] p-6 rounded-2xl items-center border border-white/5">
              <View className="bg-[#83935A]/20 p-3 rounded-full mb-3">
                <MaterialCommunityIcons
                  name="coffee"
                  size={24}
                  color="#83935A"
                />
              </View>
              <Text className="text-white text-2xl font-bold">
                {user.stats.drinks}
              </Text>
              <Text className="text-gray-500 text-xs mt-1">Drinks</Text>
            </View>
            {/* Rating */}
            <View className="w-[48%] bg-[#32363B] p-6 rounded-2xl items-center border border-white/5">
              <View className="bg-siplyLime/10 p-3 rounded-full mb-3">
                <Ionicons name="star" size={24} color={COLORS.siplyLime} />
              </View>
              <Text className="text-white text-2xl font-bold">
                {user.stats.avgRating}
              </Text>
              <Text className="text-gray-500 text-xs mt-1">Avg Rating</Text>
            </View>
            {/* Cities */}
            <View className="w-[48%] bg-[#32363B] p-6 rounded-2xl items-center border border-white/5">
              <View className="bg-[#6C244C]/20 p-3 rounded-full mb-3">
                <MaterialCommunityIcons
                  name="office-building"
                  size={24}
                  color="#6C244C"
                />
              </View>
              <Text className="text-white text-2xl font-bold">
                {user.stats.cities}
              </Text>
              <Text className="text-gray-500 text-xs mt-1">Cities</Text>
            </View>
            {/* Countries */}
            <View className="w-[48%] bg-[#32363B] p-6 rounded-2xl items-center border border-white/5">
              <View className="bg-[#BF875D]/20 p-3 rounded-full mb-3">
                <Ionicons name="globe-outline" size={24} color="#BF875D" />
              </View>
              <Text className="text-white text-2xl font-bold">
                {user.stats.countries}
              </Text>
              <Text className="text-gray-500 text-xs mt-1">Countries</Text>
            </View>
          </View>

          {/* --- QUICK ACTIONS --- */}
          <Text className="text-white text-xl font-bold px-6 mt-6 mb-4">
            Quick Actions
          </Text>
          <View className="px-6 gap-4">
            {/* My Journal */}
            <TouchableOpacity
              onPress={() => onNavigate("journal")}
              className="bg-[#32363B] p-5 rounded-2xl flex-row items-center border border-white/5"
            >
              <View className="bg-[#83935A] p-2 rounded-lg">
                <MaterialCommunityIcons
                  name="book-open-variant"
                  size={22}
                  color="white"
                />
              </View>
              <View className="ml-4 flex-1">
                <Text className="text-white font-bold text-base">
                  My Journal
                </Text>
                <Text className="text-gray-500 text-xs">
                  {user.journalCount} drinks
                </Text>
              </View>
              <Ionicons name="chevron-forward" size={20} color="#4B5563" />
            </TouchableOpacity>

            {/* Signature Drink */}
            <TouchableOpacity className="bg-[#32363B] p-5 rounded-2xl flex-row items-center border border-white/5">
              <View className="bg-[#6C244C] p-2 rounded-lg">
                <Ionicons name="heart" size={22} color="white" />
              </View>
              <View className="ml-4 flex-1">
                <Text className="text-white font-bold text-base">
                  Signature Drink
                </Text>
                <Text className="text-gray-500 text-xs">
                  {user.signatureDrink}
                </Text>
              </View>
              <Ionicons name="chevron-forward" size={20} color="#4B5563" />
            </TouchableOpacity>

            {/* My Map */}
            <TouchableOpacity
              onPress={() => onNavigate("map")}
              className="bg-[#32363B] p-5 rounded-2xl flex-row items-center border border-white/5"
            >
              <View className="bg-[#BF875D] p-2 rounded-lg">
                <MaterialCommunityIcons
                  name="map-marker-radius"
                  size={22}
                  color="white"
                />
              </View>
              <View className="ml-4 flex-1">
                <Text className="text-white font-bold text-base">My Map</Text>
                <Text className="text-gray-500 text-xs">
                  View your drink locations
                </Text>
              </View>
              <Ionicons name="chevron-forward" size={20} color="#4B5563" />
            </TouchableOpacity>
          </View>

          {/* --- ACHIEVEMENTS SECTION --- */}
          <View className="flex-row justify-between items-center px-6 mt-6 mb-4">
            <Text className="text-white text-xl font-bold">Achievements</Text>
            <TouchableOpacity onPress={() => onNavigate("achievements")}>
              <Text className="text-siplyLime font-bold">
                View All <Ionicons name="chevron-forward" size={12} />
              </Text>
            </TouchableOpacity>
          </View>

          <View className="mx-6 bg-[#32363B] px-8 py-6 rounded-2xl items-center border border-white/5">
            <MaterialCommunityIcons
              name="trophy-outline"
              size={60}
              color="#4A4E52"
            />
            <Text className="text-gray-500 text-sm mt-4">
              No achievements yet
            </Text>
            <Text className="text-gray-500 text-sm text-center mt-2 px-6">
              Start logging drinks to unlock achievements!
            </Text>
          </View>
        </ScrollView>
      </SafeAreaView>
    </View>
  );
};
