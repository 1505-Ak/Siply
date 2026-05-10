import { COLORS } from "@/src/constants/colors";
import {
  FontAwesome,
  Ionicons,
  MaterialCommunityIcons,
} from "@expo/vector-icons";
import { LinearGradient } from "expo-linear-gradient";
import { useLocalSearchParams, useRouter } from "expo-router";
import React, { useMemo } from "react";
import {
  Image,
  ScrollView,
  StatusBar,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import MapView, { Marker } from "react-native-maps";
import { SafeAreaView } from "react-native-safe-area-context";

// Components
import { OptionsModal } from "@/src/components/DetailComponents/OptionsModal";
import { ShareSocialModal } from "@/src/components/DetailComponents/ShareSocialModal";

export const DetailScreen = () => {
  const router = useRouter();

  // 1. Get the JSON string
  const { postData } = useLocalSearchParams();

  // 2. Parse it back to an object
  const data = useMemo(() => {
    if (typeof postData === "string") {
      try {
        return JSON.parse(postData);
      } catch (e) {
        return null;
      }
    }
    return null;
  }, [postData]);

  // Modal States
  const [isOptionsVisible, setOptionsVisible] = React.useState(false);
  const [isSocialVisible, setSocialVisible] = React.useState(false);

  if (!data)
    return (
      <View
        style={{
          flex: 1,
          backgroundColor: "#24272B",
          justifyContent: "center",
          alignItems: "center",
        }}
      >
        <Text className="text-white">Error loading data</Text>
      </View>
    );

  return (
    <View style={{ flex: 1, backgroundColor: "#24272B" }}>
      <StatusBar barStyle="light-content" />

      {/* Header Buttons */}
      <SafeAreaView className="absolute top-0 left-0 right-0 z-10 px-6 py-2 flex-row justify-between items-center">
        <TouchableOpacity
          onPress={() => router.back()}
          className="bg-black/30 w-11 h-11 rounded-full items-center justify-center border border-white/10"
        >
          <Ionicons name="chevron-back" size={24} color="white" />
        </TouchableOpacity>

        <TouchableOpacity
          onPress={() => setOptionsVisible(true)}
          className="bg-black/30 w-11 h-11 rounded-full items-center justify-center border border-white/10"
        >
          <Ionicons
            name="ellipsis-horizontal-circle"
            size={24}
            color={COLORS.siplyLime}
          />
        </TouchableOpacity>
      </SafeAreaView>

      <ScrollView
        style={{ flex: 1 }}
        showsVerticalScrollIndicator={false}
        contentContainerStyle={{ paddingBottom: 220 }}
      >
        {/* --- HERO IMAGE AREA --- */}
        <View className="h-96 w-full">
          {data.imageUrl ? (
            <Image
              source={{ uri: data.imageUrl }}
              className="w-full h-full"
              resizeMode="cover"
            />
          ) : (
            <LinearGradient
              colors={["#5A4E63", "#83935A"]}
              className="h-full items-center justify-center"
            >
              <MaterialCommunityIcons
                name={data.category === "Coffee" ? "coffee" : "glass-cocktail"}
                size={140}
                color="white"
              />
            </LinearGradient>
          )}
        </View>

        <View className="px-6 mt-8">
          {/* Main Title */}
          <Text className="text-white text-3xl font-bold tracking-tight">
            {data.drinkName}
          </Text>
          <Text className="text-siplyLime text-lg mt-1">{data.category}</Text>
          <Text className="text-gray-500 text-sm mt-1">{data.time}</Text>

          {/* --- INFORMATION CARDS --- */}
          <View className="mt-8 gap-4">
            {/* Rating */}
            <View className="bg-[#32363B] p-4 rounded-xl border border-white/5">
              <Text className="text-white font-semibold capitalize tracking-widest mb-3">
                Rating
              </Text>
              <View className="flex-row items-center">
                <View className="flex-row gap-2">
                  {[1, 2, 3, 4, 5].map((s) => (
                    <FontAwesome
                      key={s}
                      name="star"
                      size={20}
                      color={
                        s <= Math.floor(data.rating)
                          ? COLORS.siplyLime
                          : "#4A4E52"
                      }
                    />
                  ))}
                </View>
                <Text className="text-gray-400 ml-4 text-lg font-medium">
                  {data.rating} / 5.0
                </Text>
              </View>
            </View>

            {/* Location */}
            <View className="bg-[#32363B] p-5 rounded-xl border border-white/5">
              <Text className="text-white font-semibold text-lg capitalize tracking-widest mb-3">
                Location
              </Text>
              <View className="flex-row items-center">
                <View className="bg-[#BF875D]/20 p-2.5 rounded-xl">
                  <Ionicons name="location" size={15} color="#BF875D" />
                </View>
                <Text className="text-white text-lg ml-3">
                  {data.location}{" "}
                  {data.locationCity ? `, ${data.locationCity}` : ""}
                </Text>
              </View>
            </View>

            {/* Price & Tags */}
            <View className="flex-row gap-4">
              <View className="flex-1 bg-[#32363B] p-5 rounded-xl border border-white/5">
                <Text className="text-gray-500 text-[10px] tracking-widest mb-2">
                  Price
                </Text>
                <Text className="text-white text-xl font-semibold">
                  {data.price}
                </Text>
              </View>
              <View className="flex-[1.5] bg-[#32363B] p-5 rounded-xl border border-white/5">
                <Text className="text-gray-500 text-[10px] tracking-widest mb-2">
                  Tags
                </Text>
                <View className="flex-row flex-wrap">
                  {data.tags &&
                    data.tags.map((tag: string) => (
                      <View
                        key={tag}
                        className="bg-[#4A4E52] px-3 py-1 rounded-full mr-2 mb-1"
                      >
                        <Text className="text-siplyLime text-[10px] font-bold">
                          #{tag}
                        </Text>
                      </View>
                    ))}
                </View>
              </View>
            </View>

            {/* Notes */}
            <View className="bg-[#32363B] p-5 rounded-xl border border-white/5">
              <Text className="text-white font-semibold text-lg capitalize tracking-widest mb-2">
                Notes
              </Text>
              <Text className="text-gray-400 text-base leading-6">
                {data.notes || "No notes added."}
              </Text>
            </View>

            {/* Social Stats */}
            <View className="flex-row items-center justify-between px-2 py-2">
              <View className="flex-row gap-6">
                <View className="flex-row items-center">
                  <Ionicons
                    name="heart"
                    size={20}
                    color={COLORS.siplyMagenta}
                  />
                  <Text className="text-gray-500 ml-2 font-bold">
                    {data.likes}{" "}
                    <Text className="font-normal text-xs uppercase">Likes</Text>
                  </Text>
                </View>
                <View className="flex-row items-center">
                  <Ionicons
                    name="chatbubble-outline"
                    size={20}
                    color={COLORS.siplyLime}
                  />
                  <Text className="text-gray-500 ml-2 font-bold">
                    {data.comments}{" "}
                    <Text className="font-normal text-xs uppercase">
                      Comments
                    </Text>
                  </Text>
                </View>
              </View>
            </View>

            {/* Map (Conditional) */}
            {data.coordinates ? (
              <View className="mt-4">
                <Text className="text-white text-xl font-bold mb-4">
                  Location on Map
                </Text>
                <View className="h-64 rounded-[32px] overflow-hidden border border-white/5">
                  <MapView
                    style={{ flex: 1 }}
                    initialRegion={{
                      latitude: data.coordinates.latitude,
                      longitude: data.coordinates.longitude,
                      latitudeDelta: 0.012,
                      longitudeDelta: 0.012,
                    }}
                  >
                    <Marker coordinate={data.coordinates}>
                      <View className="bg-[#6C244C] p-2.5 rounded-full border-2 border-white shadow-xl">
                        <MaterialCommunityIcons
                          name="glass-cocktail"
                          size={18}
                          color="white"
                        />
                      </View>
                    </Marker>
                  </MapView>
                </View>
              </View>
            ) : null}
          </View>
        </View>
      </ScrollView>

      {/* Footer Actions */}
      <View
        style={{ bottom: 100 }}
        className="absolute left-0 right-0 px-6 flex-row gap-4"
      >
        <TouchableOpacity className="flex-1 bg-siplyLime h-16 rounded-2xl flex-row items-center justify-center shadow-lg">
          <Ionicons name="heart-outline" size={24} color="black" />
          <Text className="text-black font-bold text-lg ml-2">Like</Text>
        </TouchableOpacity>

        <TouchableOpacity
          onPress={() => setSocialVisible(true)}
          className="flex-1 bg-[#BF875D] h-16 rounded-2xl flex-row items-center justify-center shadow-lg"
        >
          <Ionicons name="share-social-outline" size={24} color="white" />
          <Text className="text-white font-bold text-lg ml-2">Share</Text>
        </TouchableOpacity>
      </View>

      <OptionsModal
        visible={isOptionsVisible}
        onClose={() => setOptionsVisible(false)}
        onShare={() => {}}
        onDelete={() => router.back()}
      />
      <ShareSocialModal
        visible={isSocialVisible}
        onClose={() => setSocialVisible(false)}
        drinkData={data}
      />
    </View>
  );
};
