import { Ionicons, MaterialCommunityIcons } from "@expo/vector-icons";
import React, { useEffect, useState } from "react";
import {
  ActivityIndicator,
  ScrollView,
  StatusBar,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { COLORS } from "../constants/colors";
import { achievementService } from "../services/achievement.service";

export const AchievementScreen = ({ onBack }: { onBack: () => void }) => {
  const [loading, setLoading] = useState(true);
  const [stats, setStats] = useState<any>(null);
  const [list, setList] = useState<any[]>([]);

  useEffect(() => {
    const loadData = async () => {
      // We fetch the list first, then calculate stats from it (or use the service helper)
      const fullList = await achievementService.getAllAchievements();

      const unlockedCount = fullList.filter((i: any) => i.unlocked).length;
      const total = fullList.length;

      setStats({
        unlocked: unlockedCount,
        locked: total - unlockedCount,
        total,
        progressPercentage:
          total === 0 ? 0 : Math.round((unlockedCount / total) * 100),
      });

      // Sort: Unlocked first, then Locked
      const sorted = [...fullList].sort(
        (a, b) => Number(b.unlocked) - Number(a.unlocked),
      );
      setList(sorted);
      setLoading(false);
    };
    loadData();
  }, []);

  if (loading) {
    return (
      <View
        style={{
          flex: 1,
          backgroundColor: "#24272B",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <ActivityIndicator color={COLORS.siplyLime} size="large" />
      </View>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: "#24272B" }}>
      <StatusBar barStyle="light-content" />
      <SafeAreaView style={{ flex: 1 }} edges={["top"]}>
        {/* Header Bar */}
        <View className="flex-row justify-between items-center px-6 py-2">
          <TouchableOpacity
            onPress={onBack}
            className="bg-[#32363B] w-10 h-10 rounded-full items-center justify-center border border-white/5"
          >
            <Ionicons name="chevron-back" size={24} color="white" />
          </TouchableOpacity>
          <Text className="text-white font-bold text-lg">Achievements</Text>
          <View className="w-10" />
        </View>

        <ScrollView
          style={{ flex: 1 }}
          showsVerticalScrollIndicator={false}
          contentContainerStyle={{ paddingBottom: 140 }}
        >
          {/* Hero Section */}
          <View className="items-center mt-8 mb-10">
            <MaterialCommunityIcons
              name="trophy"
              size={80}
              color={COLORS.siplyLime}
            />
            <Text className="text-white text-4xl font-bold mt-4">
              Achievements
            </Text>

            {/* Quick Stats */}
            <View className="flex-row mt-8 px-6 gap-3">
              {[
                {
                  label: "Unlocked",
                  value: stats?.unlocked,
                  color: COLORS.siplyLime,
                  bg: "#32363B",
                },
                {
                  label: "Locked",
                  value: stats?.locked,
                  color: "gray",
                  bg: "#32363B",
                },
                {
                  label: "Progress",
                  value: `${stats?.progressPercentage}%`,
                  color: "#BF875D",
                  bg: "#32363B",
                },
              ].map((stat, i) => (
                <View
                  key={i}
                  className="flex-1 p-4 rounded-2xl items-center border border-white/5"
                  style={{ backgroundColor: stat.bg }}
                >
                  <Text
                    style={{ color: stat.color }}
                    className="text-2xl font-bold"
                  >
                    {stat.value}
                  </Text>
                  <Text className="text-gray-500 text-[10px] font-medium uppercase mt-1">
                    {stat.label}
                  </Text>
                </View>
              ))}
            </View>
          </View>

          {/* Progress Bar Section */}
          <View className="px-6 mb-10">
            <View className="flex-row justify-between items-end mb-3">
              <Text className="text-white text-xl font-bold">
                Overall Progress
              </Text>
              <Text className="text-siplyLime font-bold">
                {stats?.unlocked}/{stats?.total}
              </Text>
            </View>
            <View className="h-3 w-full bg-[#32363B] rounded-full overflow-hidden">
              <View
                style={{ width: `${stats?.progressPercentage || 0}%` }}
                className="h-full bg-siplyLime rounded-full"
              />
            </View>
          </View>

          {/* Achievements Grid */}
          <Text className="text-white text-2xl font-bold px-6 mb-6">
            Trophy Case
          </Text>
          <View className="flex-row flex-wrap px-4">
            {list.map((item) => (
              <View key={item.id} className="w-1/2 p-2">
                <View
                  className={`rounded-3xl p-6 items-center border border-white/5 ${item.unlocked ? "bg-[#32363B]" : "bg-[#2A2D31] opacity-50"}`}
                >
                  <View
                    className={`w-16 h-16 rounded-full items-center justify-center mb-4 ${item.unlocked ? "bg-siplyLime/10" : "bg-[#454A50]"}`}
                  >
                    <MaterialCommunityIcons
                      name={item.icon}
                      size={32}
                      color={item.unlocked ? COLORS.siplyLime : "gray"}
                    />
                  </View>
                  <Text
                    className={`font-bold text-base text-center ${item.unlocked ? "text-white" : "text-gray-500"}`}
                  >
                    {item.name}
                  </Text>
                  <Text className="text-gray-500 text-[11px] text-center mt-2 font-medium leading-4">
                    {item.desc}
                  </Text>
                </View>
              </View>
            ))}
          </View>
        </ScrollView>
      </SafeAreaView>
    </View>
  );
};
