import React, { useState } from "react";
import {
  ActivityIndicator,
  KeyboardAvoidingView,
  Platform,
  ScrollView,
  Text,
  TouchableOpacity,
  View,
} from "react-native";
import { SafeAreaView } from "react-native-safe-area-context";
import { CustomButton } from "../components/CustomButton";
import { CustomInput } from "../components/CustomInput";
import { authService } from "../services/auth.service";

interface Props {
  onNavigateToSignUp: () => void;
  onLoginSuccess: () => void; // New Prop
}

const LoginScreen = ({ onNavigateToSignUp, onLoginSuccess }: Props) => {
  const [username, setUsername] = useState("");
  const [password, setPassword] = useState("");
  const [loading, setLoading] = useState(false);

  const handleLogin = async () => {
    if (!username || !password) return;

    setLoading(true);
    const response: any = await authService.login(username, password);
    setLoading(false);

    if (response.success) {
      onLoginSuccess(); // This triggers the screen change in index.tsx
    }
  };

  return (
    <View className="flex-1 bg-siplyCharcoal">
      <SafeAreaView className="flex-1 px-8">
        <KeyboardAvoidingView
          behavior={Platform.OS === "ios" ? "padding" : "height"}
          className="flex-1"
        >
          <ScrollView
            showsVerticalScrollIndicator={false}
            contentContainerStyle={{ flexGrow: 1 }}
          >
            <View className="items-center mt-20 mb-16">
              <Text className="text-white text-6xl font-bold">Siply</Text>
              <Text className="text-gray-400 text-base mt-3 text-center">
                Track your drinks, discover new venues
              </Text>
            </View>

            <View className="flex-1">
              <CustomInput
                label="Username"
                value={username}
                onChangeText={setUsername}
                // placeholder="username"
              />
              <CustomInput
                label="Password"
                secureTextEntry
                value={password}
                onChangeText={setPassword}
                // placeholder="password"
              />

              {loading ? (
                <ActivityIndicator
                  color="#D0FF14"
                  size="large"
                  className="mt-4"
                />
              ) : (
                <CustomButton title="Sign In" onPress={handleLogin} />
              )}
            </View>

            <View className="flex-row justify-center mb-10 mt-6">
              <Text className="text-gray-400 text-base">
                Don't have an account?{" "}
              </Text>
              <TouchableOpacity onPress={onNavigateToSignUp}>
                <Text className="text-siplyLime text-base font-bold">
                  Sign Up
                </Text>
              </TouchableOpacity>
            </View>
          </ScrollView>
        </KeyboardAvoidingView>
      </SafeAreaView>
    </View>
  );
};

export default LoginScreen;
