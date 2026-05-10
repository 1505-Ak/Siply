import { Ionicons, MaterialCommunityIcons } from "@expo/vector-icons";
import { LinearGradient } from "expo-linear-gradient";
import { useRouter } from "expo-router";
import React from "react";
import { Image, Text, TouchableOpacity, View } from "react-native";

interface FeedCardProps {
  post: any;
  onOpenComments: (postId: string) => void;
}

export const FeedCard = ({ post, onOpenComments }: FeedCardProps) => {
  const router = useRouter();

  const handlePress = () => {
    router.push({
      pathname: `/(tabs)/home/${post.drinkId}`,
      params: {
        // We pass the entire object as a string
        postData: JSON.stringify(post),
      },
    });
  };

  return (
    <TouchableOpacity
      onPress={handlePress}
      className={`mx-5 rounded-xl mb-8 overflow-hidden bg-[#32363B] border border-white/5`}
    >
      {/* User Row */}
      <View className="flex-row justify-between items-center px-2 py-4">
        <View className="flex-row items-center">
          <View className="w-10 h-10 rounded-full bg-[#8E8D6F] items-center justify-center overflow-hidden">
            {post.user.avatarUrl ? (
              <Image
                source={{ uri: post.user.avatarUrl }}
                className="w-full h-full"
              />
            ) : (
              <Text className="text-white font-bold">
                {post.user.displayName[0]}
              </Text>
            )}
          </View>
          <View className="ml-3">
            <Text className="text-white font-bold text-sm">
              {post.user.displayName}
            </Text>
            <Text className="text-gray-500 text-[10px] mt-[2px]">
              📍 {post.location} • {post.time}
            </Text>
          </View>
        </View>
        <Ionicons name="ellipsis-vertical" size={18} color="gray" />
      </View>

      {/* Body Image Area */}
      <View className="h-72 w-full bg-[#2D3035]">
        {post.imageUrl ? (
          <Image
            source={{ uri: post.imageUrl }}
            className="w-full h-full"
            resizeMode="cover"
          />
        ) : (
          <LinearGradient
            colors={["#5A4E63", "#83935A"]}
            className="h-full w-full items-center justify-center"
          >
            <MaterialCommunityIcons
              name={post.category === "Coffee" ? "coffee" : "glass-cocktail"}
              size={80}
              color="white"
            />
            <Text className="text-white mt-4 font-bold tracking-widest uppercase opacity-70">
              {post.category}
            </Text>
          </LinearGradient>
        )}
      </View>

      {/* Actions Bar */}
      <View className="flex-row justify-between items-center px-4 py-4">
        <View className="flex-row gap-2">
          <View className="flex-row items-center">
            <Ionicons name="heart-outline" size={24} color="white" />
            <Text className="text-white ml-1 text-xs font-medium">
              {post.likes}
            </Text>
          </View>
          <TouchableOpacity
            onPress={() => onOpenComments(post.id)}
            className="flex-row items-center"
          >
            <Ionicons name="chatbubble-outline" size={20} color="white" />
            <Text className="text-white ml-1 text-xs font-medium">
              {post.comments}
            </Text>
          </TouchableOpacity>
        </View>
        <Ionicons name="bookmark-outline" size={22} color="white" />
      </View>

      {/* Feed Content Info */}
      <View className="px-2 pb-4">
        <Text className="text-siplyLime text-xs font-bold">
          {"★".repeat(Math.round(post.rating))}
        </Text>
        <Text className="text-white text-md font-bold mt-1 tracking-tight">
          {post.drinkName}
        </Text>
        <Text className="text-gray-500 text-xs mt-1 font-medium">
          {post.category} •{" "}
          <Text className="text-[#BF875D] font-bold">{post.price}</Text>
        </Text>
      </View>
    </TouchableOpacity>
  );
};
