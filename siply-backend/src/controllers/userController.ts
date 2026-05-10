import { Request, Response } from "express";
import { AuthRequest } from "../middleware/auth";
import { prisma } from "../config/prisma";

export const getPublicProfile = async (req: Request, res: Response) => {
  const { username } = req.params;
  const user = await prisma.user.findUnique({
    where: { username },
    select: {
      id: true,
      username: true,
      displayName: true,
      bio: true,
      avatarUrl: true,
      followersCount: true,
      followingCount: true,
      totalDrinks: true,
      favoriteDrink: true,
      totalCities: true,
      totalCountries: true,
      avgRating: true,
    },
  });

  if (!user) return res.status(404).json({ message: "User not found" });
  res.json(user);
};

export const updateProfile = async (req: AuthRequest, res: Response) => {
  const { displayName, bio, avatarUrl, favoriteDrink } = req.body;

  const updatedUser = await prisma.user.update({
    where: { id: req.user.id },
    data: { displayName, bio, avatarUrl, favoriteDrink },
  });

  const { passwordHash: _, ...userResponse } = updatedUser;
  res.json(userResponse);
};

export const searchUsers = async (req: Request, res: Response) => {
  const query = req.query.q as string;
  if (!query) return res.json([]);

  const users = await prisma.user.findMany({
    where: {
      OR: [
        { username: { contains: query, mode: "insensitive" } },
        { displayName: { contains: query, mode: "insensitive" } },
      ],
    },
    select: { id: true, username: true, displayName: true, avatarUrl: true },
    take: 10,
  });

  res.json(users);
};
