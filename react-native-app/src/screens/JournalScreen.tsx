import { Ionicons } from "@expo/vector-icons";
import { useRouter } from "expo-router";
import React, { useEffect, useState } from "react";
import {
  ScrollView,
  StatusBar,
  Text,
  TextInput,
  TouchableOpacity,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { FloatingNav } from "../components/HomeComponents/FloatingNav";
import { JournalItem } from "../components/JournalComponents/JournalItem";
import { SortModal } from "../components/JournalComponents/SortModal"; // NEW
import { StatCard } from "../components/JournalComponents/StatCard";
import { COLORS } from "../constants/colors";
import { journalService } from "../services/journal.service";

const JournalScreen = () => {
  const router = useRouter();
  const [stats, setStats] = useState<any>(null);
  const [entries, setEntries] = useState<any[]>([]);
  const [isModalVisible, setModalVisible] = useState(false); // NEW
  const [activeSort, setActiveSort] = useState("Date (Newest)"); // NEW

  useEffect(() => {
    const fetchData = async () => {
      const [s, e] = await Promise.all([
        journalService.getStats(),
        journalService.getEntries(),
      ]);
      setStats(s);
      // Sort the initial data
      setEntries(journalService.sortEntries(e, activeSort));
    };
    fetchData();
  }, []);

  const handleSortSelection = (label: string) => {
    setActiveSort(label);
    const sorted = journalService.sortEntries(entries, label);
    setEntries(sorted);
    setModalVisible(false);
  };

  return (
    <View style={{ flex: 1, backgroundColor: "#24272B" }}>
      <StatusBar barStyle="light-content" />
      <SafeAreaView style={{ flex: 1 }} edges={["top"]}>
        {/* Header */}
        <View className="flex-row justify-between items-center px-6 py-4">
          <TouchableOpacity
            onPress={() => router.back()}
            className="bg-[#32363B] w-10 h-10 rounded-full items-center justify-center border border-white/5"
          >
            <Ionicons name="chevron-back" size={24} color="white" />
          </TouchableOpacity>
          <View className="flex flex-row gap-2">
            <View className="flex-row items-center bg-siplyLime rounded-full px-4 py-2">
              <Ionicons name="map" size={18} color="black" />
              <Text className="text-black font-bold ml-2">Map</Text>
            </View>

            {/* SORT BUTTON */}
            <TouchableOpacity
              onPress={() => setModalVisible(true)}
              className="bg-[#32363B] w-8 h-8 rounded-full items-center justify-center border border-white/5"
            >
              <Ionicons
                name="swap-vertical"
                size={12}
                color={COLORS.siplyLime}
              />
            </TouchableOpacity>
          </View>
        </View>

        <Text className="text-white text-3xl font-bold px-6 mb-6">Journal</Text>

        <ScrollView
          style={{ flex: 1 }}
          showsVerticalScrollIndicator={false}
          contentContainerStyle={{ paddingBottom: 160 }}
        >
          {/* Search Bar */}
          <View className="px-6 mb-6">
            <View className="bg-[#32363B] flex-row items-center px-4 h-14 rounded-xl border border-white/5">
              <Ionicons name="search" size={15} color={COLORS.siplyLime} />
              <TextInput
                placeholder="Search by name or location..."
                placeholderTextColor="#6B7280"
                className="flex-1 ml-3 text-white text-base"
              />
            </View>
          </View>

          {/* Stats Section */}
          {stats && (
            <View className="flex-row px-5 mb-8">
              <StatCard
                label="Total drinks"
                value={stats.totalDrinks}
                icon="water"
                type="drink"
              />
              <StatCard
                label="Places"
                value={stats.places}
                icon="map-marker-outline"
                type="place"
              />
              <StatCard
                label="Avg Rating"
                value={stats.avgRating}
                icon="star"
                type="star"
              />
            </View>
          )}

          {/* List Section */}
          <View className="px-6">
            {entries.map((item) => (
              <JournalItem key={item.id} item={item} />
            ))}
          </View>
        </ScrollView>

        {/* SORT MODAL */}
        <SortModal
          visible={isModalVisible}
          currentSort={activeSort}
          onClose={() => setModalVisible(false)}
          onSelect={handleSortSelection}
        />

        <FloatingNav />
      </SafeAreaView>
    </View>
  );
};

export default JournalScreen;
