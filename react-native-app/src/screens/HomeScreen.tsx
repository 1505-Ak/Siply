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

// Services
import { drinkService } from "../services/drink.service";

// Components
import { useRouter } from "expo-router";
import { CommentModal } from "../components/HomeComponents/CommentModal"; // Added Import
import { DiscoverTrending } from "../components/HomeComponents/DiscoverTrending";
import { FeedCard } from "../components/HomeComponents/FeedCard";
import { FloatingNav } from "../components/HomeComponents/FloatingNav";

interface HomeScreenProps {
  onSeeAll: () => void;
}

const HomeScreen = ({ onSeeAll }: HomeScreenProps) => {
  const [loading, setLoading] = useState(true);
  const [commentModalVisible, setCommentModalVisible] = useState(false); // Added State
  const [selectedPostId, setSelectedPostId] = useState<string | null>(null); // Added State

  const router = useRouter();

  const [data, setData] = useState<any>({
    feed: [],
    trending: [],
    discovery: [],
    categories: [],
  });

  useEffect(() => {
    const loadHomeData = async () => {
      const [feed, trending, discovery, categories] = await Promise.all([
        drinkService.getFeed(),
        drinkService.getTrending(),
        drinkService.getDiscovery(),
        drinkService.getCategories(),
      ]);

      setData({ feed, trending, discovery, categories });
      setLoading(false);
    };

    loadHomeData();
  }, []);

  // Added Helper Function
  const openComments = (postId: string) => {
    setSelectedPostId(postId);
    setCommentModalVisible(true);
  };

  if (loading) {
    return (
      <View className="flex-1 bg-[#24272B] items-center justify-center">
        <ActivityIndicator color={COLORS.siplyLime} size="large" />
      </View>
    );
  }

  return (
    <View style={{ flex: 1, backgroundColor: "#24272B" }}>
      <StatusBar barStyle="light-content" />
      <SafeAreaView style={{ flex: 1 }} edges={["top"]}>
        {/* HEADER */}
        <View className="flex-row justify-between items-center px-6 py-2">
          <View className="w-11 h-11 rounded-full border border-siplyLime/30 items-center justify-center bg-siplyLime/10">
            <View className="w-9 h-9 rounded-full border border-siplyLime/50 items-center justify-center">
              <Text className="text-siplyLime font-bold text-lg">S</Text>
            </View>
          </View>
          <TouchableOpacity
            onPress={() => router.push("/(tabs)/home/achievements")}
            className="bg-[#32363B] w-11 h-11 rounded-full items-center justify-center relative border border-white/5"
          >
            <Ionicons name="notifications" size={20} color={COLORS.siplyLime} />
            <View className="absolute top-2.5 right-2.5 w-2 h-2 bg-red-500 rounded-full border border-[#32363B]" />
          </TouchableOpacity>
        </View>

        <ScrollView
          style={{ flex: 1 }}
          contentContainerStyle={{ paddingBottom: 160, flexGrow: 1 }}
          showsVerticalScrollIndicator={false}
        >
          {/* DISCOVER & TRENDING (Passing dynamic data as props) */}
          <DiscoverTrending
            discovery={data.discovery}
            trending={data.trending}
          />

          {/* POSTS SECTION */}
          <View className="flex-row justify-between items-center px-6 mb-5">
            <View className="flex-row items-center">
              {/* <MaterialCommunityIcons name="account-group" size={24} color={COLORS.siplyLime} /> */}
              <Text className="text-white text-2xl font-bold">
                Recent Posts
              </Text>
            </View>
            <TouchableOpacity onPress={onSeeAll}>
              <Text className="text-siplyLime font-semibold text-sm">
                See All
              </Text>
            </TouchableOpacity>
          </View>

          {/* FEED CARDS (Dynamic) */}
          {data.feed.map((post: any) => (
            <FeedCard
              key={post.id}
              post={post}
              onOpenComments={openComments} // Passed Prop to Card
            />
          ))}

          {/* CATEGORIES SECTION (Dynamic) */}
          <Text className="text-white text-2xl font-bold px-6 mb-6">
            Categories
          </Text>
          <ScrollView
            horizontal
            showsHorizontalScrollIndicator={false}
            className="pl-6"
          >
            {data.categories.map((c: any, i: number) => (
              <View key={i} className="items-center mr-6">
                <View className="w-16 h-16 rounded-full bg-[#32363B] items-center justify-center border border-white/5 shadow-lg">
                  <MaterialCommunityIcons
                    name={c.icon || (c.i as any)}
                    size={24}
                    color="white"
                  />
                </View>
                <Text className="text-gray-400 mt-2 text-[10px] font-bold">
                  {c.name}
                </Text>
              </View>
            ))}
          </ScrollView>
        </ScrollView>

        <FloatingNav />

        {/* Comment Modal Component Added */}
        <CommentModal
          visible={commentModalVisible}
          onClose={() => setCommentModalVisible(false)}
          postId={selectedPostId || ""}
        />
      </SafeAreaView>
    </View>
  );
};

export default HomeScreen;
