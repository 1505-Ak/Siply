import React, { useState } from "react";
import {
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
  onNavigateToLogin: () => void;
  onSignUpSuccess?: () => void;
}

const SignUpScreen = ({ onNavigateToLogin, onSignUpSuccess }: Props) => {
  const [form, setForm] = useState({
    username: "",
    email: "",
    displayName: "",
    password: "",
    confirmPassword: "",
  });

  const handleRegister = async () => {
    if (form.password !== form.confirmPassword) {
      alert("Passwords do not match");
      return;
    }
    const result: any = await authService.register(form);
    if (result.success && onSignUpSuccess) {
      onSignUpSuccess();
    }
  };

  const updateForm = (key: string, value: string) => {
    setForm({ ...form, [key]: value });
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
            {/* Header Section */}
            <View className="items-center mt-10 mb-10">
              <Text className="text-white text-6xl font-bold">Siply</Text>
              <Text className="text-gray-400 text-base mt-2">
                Track your drinks, discover new venues
              </Text>
            </View>

            {/* Form Section */}
            <View className="flex-1">
              <CustomInput
                label="Username"
                value={form.username}
                onChangeText={(v) => updateForm("username", v)}
              />
              <CustomInput
                label="Email"
                value={form.email}
                onChangeText={(v) => updateForm("email", v)}
              />
              <CustomInput
                label="Display Name"
                value={form.displayName}
                onChangeText={(v) => updateForm("displayName", v)}
              />
              <CustomInput
                label="Password"
                secureTextEntry
                value={form.password}
                onChangeText={(v) => updateForm("password", v)}
              />
              <CustomInput
                label="Confirm Password"
                secureTextEntry
                value={form.confirmPassword}
                onChangeText={(v) => updateForm("confirmPassword", v)}
              />

              <View className="mt-4">
                <CustomButton title="Create Account" onPress={handleRegister} />
              </View>
            </View>

            {/* Footer Section */}
            <View className="flex-row justify-center mb-10 mt-8">
              <Text className="text-gray-400 text-base">
                Already have an account?{" "}
              </Text>
              <TouchableOpacity onPress={onNavigateToLogin}>
                <Text className="text-siplyLime text-base font-bold">
                  Sign In
                </Text>
              </TouchableOpacity>
            </View>
          </ScrollView>
        </KeyboardAvoidingView>
      </SafeAreaView>
    </View>
  );
};

export default SignUpScreen;
