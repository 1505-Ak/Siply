export const commentService = { // Changed from comment.service to commentService
  // Mock fetching comments for a specific drink/post
  getCommentsByPostId: async (postId: string) => {
    // Simulated delay
    await new Promise(resolve => setTimeout(resolve, 400));
    
    return [
      {
        id: 'c1',
        userName: 'Jess',
        text: 'Looks amazing!',
        time: '12:02 AM'
      },
      {
        id: 'c2',
        userName: 'Leo',
        text: 'Need to try this place.',
        time: '12:05 AM'
      }
    ];
  },

  // Mock adding a new comment
  addComment: async (postId: string, text: string) => {
    console.log(`Adding comment to ${postId}: ${text}`);
    return { success: true };
  }
};