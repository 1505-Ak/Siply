export interface User {
  id: string;
  username: string;
  displayName: string;
  avatarUrl?: string;
}

export interface Drink {
  id: string;
  name: string;
  category: string;
  rating: number;
  price?: number;
  imageUrl?: string;
  locationName?: string;
}

export interface FeedPost {
  id: string;
  user: User;
  drink: Drink;
  likesCount: number;
  commentsCount: number;
  createdAt: string;
}