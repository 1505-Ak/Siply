import { Ionicons } from '@expo/vector-icons';
import React, { useEffect, useState } from 'react';
import { KeyboardAvoidingView, Modal, Platform, ScrollView, Text, TextInput, TouchableOpacity, View } from 'react-native';
import { COLORS } from '../../constants/colors';
import { commentService } from '../../services/comment.service';

interface CommentModalProps {
  visible: boolean;
  onClose: () => void;
  postId: string;
}

export const CommentModal = ({ visible, onClose, postId }: CommentModalProps) => {
  const [comments, setComments] = useState<any[]>([]);
  const [newComment, setNewComment] = useState('');

  useEffect(() => {
    if (visible) {
      commentService.getCommentsByPostId(postId).then(setComments);
    }
  }, [visible, postId]);

  const handleSend = async () => {
    if (!newComment.trim()) return;
    await commentService.addComment(postId, newComment);
    // Locally update for instant feedback
    setComments([...comments, { id: Date.now().toString(), userName: 'You', text: newComment, time: 'Just now' }]);
    setNewComment('');
  };

  return (
    <Modal visible={visible} animationType="slide" transparent={false}>
      <View style={{ flex: 1, backgroundColor: '#24272B' }}>
        <View className="flex-1 px-6 pt-14">
          
          {/* Header */}
          <View className="flex-row items-center mb-8">
            <TouchableOpacity 
              onPress={onClose} 
              className="border border-gray-600 rounded-full px-4 py-2"
            >
              <Text className="text-siplyLime font-bold text-base">Close</Text>
            </TouchableOpacity>
          </View>

          <Text className="text-white text-3xl font-bold mb-8">Comments</Text>

          {/* Comments List */}
          <ScrollView showsVerticalScrollIndicator={false} className="flex-1">
            {comments.map((item) => (
              <View key={item.id} className="bg-[#32363B] rounded-2xl p-5 mb-4 self-start max-w-[80%]">
                <Text className="text-siplyLime font-bold text-lg mb-1">{item.userName}</Text>
                <Text className="text-white text-base leading-6">{item.text}</Text>
                <Text className="text-gray-500 text-xs mt-2 uppercase">{item.time}</Text>
              </View>
            ))}
          </ScrollView>

          {/* Input Area */}
          <KeyboardAvoidingView
            behavior={Platform.OS === 'ios' ? 'padding' : 'height'}
            keyboardVerticalOffset={20}
          >
            <View className="flex-row items-center py-6">
              <View className="flex-1 bg-[#1A1D21] h-12 rounded-xl px-4 justify-center border border-white/5">
                <TextInput
                  placeholder="Add a comment..."
                  placeholderTextColor="#4B5563"
                  className="text-white text-base"
                  value={newComment}
                  onChangeText={setNewComment}
                />
              </View>
              <TouchableOpacity 
                onPress={handleSend}
                className="bg-[#32363B] w-12 h-12 rounded-full items-center justify-center ml-3"
              >
                <Ionicons name="send" size={15} color={COLORS.siplyLime} />
              </TouchableOpacity>
            </View>
          </KeyboardAvoidingView>

        </View>
      </View>
    </Modal>
  );
};