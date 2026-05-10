import { COLORS } from "@/src/constants/colors";
import { Ionicons, MaterialCommunityIcons } from "@expo/vector-icons";
import { Text, View } from "react-native";

export const DiscoverTrending = ({ discovery, trending }: any) => {
  return (
    <View className="flex-row px-5 justify-between mt-6 mb-8">
      {/* Discover Column */}
      <View className="w-[48%] bg-siplyCharcoal px-2 py-4 rounded-xl border border-white/5">
        <Text className="text-white font-bold text-base mb-4">Discover</Text>
        {discovery.slice(0, 3).map((v: any) => (
          <View
            key={v.id}
            className="flex-row items-center justify-between mb-2 bg-[#32363B] w-full p-2 rounded-lg"
          >
            <View className="flex-row items-center">
              <MaterialCommunityIcons name={v.icon} size={16} color="white" />
              <Text className="text-gray-300 ml-2 text-[11px] font-medium">
                {v.name}
              </Text>
            </View>
            <Ionicons name="chevron-forward" size={10} color="gray" />
          </View>
        ))}
      </View>

      {/* Trending Column */}
      <View className="w-[48%] bg-siplyCharcoal py-4 px-2 rounded-xl border border-white/5">
        <Text className="text-white font-bold text-base mb-4">
          Trending Now
        </Text>
        {/* only top 3 */}
        {trending.slice(0, 3).map((t: any) => (
          <View
            key={t.id}
            className="flex-row items-center mb-2 bg-[#32363B] p-1 rounded-lg"
          >
            <View className="w-8 h-8 bg-[#454A50] rounded-lg items-center justify-center">
              <MaterialCommunityIcons
                name={t.icon}
                size={14}
                color={COLORS.siplyLime}
              />
            </View>
            <View className="ml-2">
              <Text
                className="text-white text-[10px] font-bold"
                numberOfLines={1}
              >
                {t.name}
              </Text>
              <Text className="text-siplyLime text-[8px]">
                {"★".repeat(t.rating)}
              </Text>
            </View>
          </View>
        ))}
      </View>
    </View>
  );
};
