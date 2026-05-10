import { Stack } from "expo-router";

export default function HomeLayout() {
  return (
    <Stack
      screenOptions={{ headerShown: false, animation: "slide_from_right" }}
    >
      {/* The Main Home Screen */}
      <Stack.Screen name="index" />

      {/* The Detail Screen */}
      <Stack.Screen name="[id]/index" />

      {/* Other screens in this tab */}
      <Stack.Screen name="journal" />
      <Stack.Screen name="achievements" />
    </Stack>
  );
}
