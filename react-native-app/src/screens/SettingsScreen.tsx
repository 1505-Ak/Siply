import { Ionicons, MaterialCommunityIcons } from "@expo/vector-icons";
import { useRouter } from "expo-router";
import React, { useState } from "react";
import {
  ScrollView,
  StatusBar,
  Switch,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { COLORS } from "../constants/colors";

interface SettingsProps {
  onBack: () => void;
  onLogout: () => void;
}

export const SettingsScreen = ({ onBack, onLogout }: SettingsProps) => {
  const [locationEnabled, setLocationEnabled] = useState(true);
  const [notificationsEnabled, setNotificationsEnabled] = useState(true);

  const router = useRouter();

  // Helper for Section Labels
  const SectionLabel = ({ title }: { title: string }) => (
    <Text className="text-gray-500 text-sm font-bold px-1 mb-3 mt-6  tracking-widest">
      {title}
    </Text>
  );

  // Helper for standard rows - Updated to TouchableOpacity to allow navigation
  const SettingRow = ({
    icon,
    title,
    value,
    color = "white",
    showChevron = true,
    onPress,
    children,
  }: any) => (
    <TouchableOpacity
      onPress={onPress}
      disabled={!onPress}
      activeOpacity={0.7}
      className="bg-[#32363B] h-16 rounded-2xl flex-row items-center px-4 mb-3 border border-white/5"
    >
      <View className="w-8 items-center justify-center">{icon}</View>
      <Text className="text-white text-base font-medium ml-3 flex-1">
        {title}
      </Text>
      {value && (
        <Text style={{ color }} className="text-base font-bold mr-2">
          {value}
        </Text>
      )}
      {children}
      {showChevron && (
        <Ionicons name="chevron-forward" size={18} color="#4B5563" />
      )}
    </TouchableOpacity>
  );

  return (
    // Root container is transparent/dimmed to show the screen behind the modal
    <View style={{ flex: 1, backgroundColor: "rgba(0,0,0,0.5)" }}>
      <StatusBar barStyle="light-content" />

      {/* The visible "Modal" part starts here */}
      <View
        className="flex-1 bg-[#24272B] mt-16 rounded-t-[40px] overflow-hidden"
        style={{
          shadowColor: "#000",
          shadowOffset: { width: 0, height: -10 },
          shadowOpacity: 0.3,
          shadowRadius: 20,
          elevation: 20,
        }}
      >
        <SafeAreaView style={{ flex: 1 }} edges={["right", "left"]}>
          {/* --- HEADER --- */}
          <View className="flex-row justify-between items-center px-6 py-5 border-b border-white/5">
            <TouchableOpacity
              onPress={onBack}
              className="bg-[#32363B] w-10 h-10 rounded-full items-center justify-center border border-white/5"
            >
              <Ionicons name="chevron-back" size={24} color="white" />
            </TouchableOpacity>
            <Text className="text-white text-xl font-bold">Settings</Text>
            <TouchableOpacity
              onPress={onBack}
              className="bg-siplyLime px-6 py-2 rounded-full"
            >
              <Text className="text-black font-bold text-base">Done</Text>
            </TouchableOpacity>
          </View>

          <ScrollView
            className="flex-1 px-6"
            showsVerticalScrollIndicator={false}
            contentContainerStyle={{ paddingBottom: 100, paddingTop: 10 }}
          >
            {/* PROFILE SECTION */}
            <SectionLabel title="Profile" />
            <SettingRow
              title="Display Name"
              value="Alex Johnson"
              color={COLORS.siplyLime}
              showChevron={false}
            />
            <SettingRow
              title="Username"
              value="@drinkexplorer"
              color="#6B7280"
              showChevron={false}
            />

            {/* DATA MANAGEMENT */}
            <SectionLabel title="Data Management" />
            <SettingRow
              title="Backup Data"
              icon={
                <MaterialCommunityIcons
                  name="file-upload"
                  size={20}
                  color={COLORS.siplyLime}
                />
              }
            />
            <SettingRow
              title="Restore from Backup"
              icon={
                <MaterialCommunityIcons
                  name="file-download"
                  size={20}
                  color={COLORS.siplyLime}
                />
              }
            />

            {/* Storage Info Card */}
            <View className="bg-[#32363B] p-5 rounded-3xl border border-white/5 mt-2">
              <Text className="text-gray-500 text-[10px] font-bold tracking-widest mb-4">
                Storage Info
              </Text>
              <View className="flex-row justify-between mb-3">
                <Text className="text-white text-base">Total Drinks:</Text>
                <Text className="text-siplyLime font-bold text-base">4</Text>
              </View>
              <View className="flex-row justify-between mb-3">
                <Text className="text-white text-base">Total Spent:</Text>
                <Text className="text-siplyLime font-bold text-base">
                  $32.00
                </Text>
              </View>
              <View className="flex-row justify-between">
                <Text className="text-white text-base">Most Visited:</Text>
                <Text
                  className="text-siplyLime font-bold text-base flex-1 text-right ml-4"
                  numberOfLines={1}
                >
                  Boba Paradise, San Francis...
                </Text>
              </View>
            </View>

            {/* PRIVACY */}
            <SectionLabel title="Privacy" />
            <SettingRow
              title="Location Services"
              showChevron={false}
              icon={
                <Ionicons name="navigate" size={20} color={COLORS.siplyLime} />
              }
            >
              <Switch
                value={locationEnabled}
                onValueChange={setLocationEnabled}
                trackColor={{ false: "#1A1D21", true: COLORS.siplyLime }}
                thumbColor="white"
              />
            </SettingRow>

            {/* Navigates to Privacy Settings */}
            <SettingRow
              title="Privacy Settings"
              onPress={() => router.push("/(tabs)/profile/privacy")}
              icon={
                <Ionicons
                  name="lock-closed"
                  size={20}
                  color={COLORS.siplyLime}
                />
              }
            />

            {/* Navigates to Blocked Users */}
            <SettingRow
              title="Blocked Users"
              onPress={() => router.push("/(tabs)/profile/blocked")}
              icon={
                <Ionicons name="eye-off" size={20} color={COLORS.siplyLime} />
              }
            />

            {/* NOTIFICATIONS */}
            <SectionLabel title="Notifications" />
            <SettingRow
              title="Push Notifications"
              showChevron={false}
              icon={
                <Ionicons
                  name="notifications"
                  size={20}
                  color={COLORS.siplyLime}
                />
              }
            >
              <Switch
                value={notificationsEnabled}
                onValueChange={setNotificationsEnabled}
                trackColor={{ false: "#1A1D21", true: COLORS.siplyLime }}
                thumbColor="white"
              />
            </SettingRow>

            {/* ABOUT */}
            <SectionLabel title="About" />
            <SettingRow
              title="About Siply"
              value="v1.0.0"
              color="#6B7280"
              onPress={() => router.push("/(tabs)/profile/about")}
              icon={
                <Ionicons
                  name="information-circle"
                  size={22}
                  color={COLORS.siplyLime}
                />
              }
            />
            <SettingRow
              title="Terms & Privacy"
              onPress={() => router.push("/(tabs)/profile/terms")}
              icon={
                <Ionicons
                  name="document-text"
                  size={20}
                  color={COLORS.siplyLime}
                />
              }
            />

            {/* DANGER ZONE */}
            <Text className="text-red-500 text-base font-bold px-1 mb-3 mt-10">
              Danger Zone
            </Text>
            <TouchableOpacity className="bg-[#32363B] h-16 rounded-2xl flex-row items-center px-4 mb-3 border border-red-500/10">
              <Ionicons name="refresh-outline" size={22} color="#BF875D" />
              <Text className="text-white text-base font-medium ml-3">
                Reset Profile
              </Text>
            </TouchableOpacity>
            <TouchableOpacity className="bg-[#32363B] h-16 rounded-2xl flex-row items-center px-4 mb-3 border border-red-500/10">
              <Ionicons name="trash-outline" size={22} color="#EF4444" />
              <Text className="text-white text-base font-medium ml-3">
                Delete All Drinks
              </Text>
            </TouchableOpacity>
            <TouchableOpacity
              onPress={onLogout}
              className="bg-[#EF4444]/10 h-16 rounded-2xl flex-row items-center px-4 mb-12 border border-red-500/20"
            >
              <Ionicons name="log-out-outline" size={22} color="#EF4444" />
              <Text className="text-[#EF4444] text-base font-bold ml-3">
                Log Out
              </Text>
            </TouchableOpacity>
          </ScrollView>
        </SafeAreaView>
      </View>
    </View>
  );
};
