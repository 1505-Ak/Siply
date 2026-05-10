import { FloatingNav } from "@/src/components/HomeComponents/FloatingNav";
import { Tabs } from "expo-router";
import { View } from "react-native";

export default function TabLayout() {
  return (
    <View style={{ flex: 1, backgroundColor: "#24272B" }}>
      <Tabs
        screenOptions={{
          headerShown: false,
          // We hide the default tab bar because we are using your custom FloatingNav
          tabBarStyle: { display: "none" },
        }}
      >
        <Tabs.Screen name="home" />
        <Tabs.Screen name="find" />
        <Tabs.Screen name="create" />
        <Tabs.Screen name="offers" />
        <Tabs.Screen name="profile" />
      </Tabs>

      {/* 
          By placing this here (outside the Tabs but inside the root View), 
          it stays fixed at the bottom across all tab screens.
      */}
      <FloatingNav />
    </View>
  );
}
