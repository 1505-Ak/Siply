import { Response } from 'express';
import { AuthRequest } from '../middleware/auth';
import {prisma} from '../config/prisma';

// --- FEED ---
export const getFeed = async (req: AuthRequest, res: Response) => {
  const limit = parseInt(req.query.limit as string) || 20;

  const feed = await prisma.feedPost.findMany({
    take: limit,
    orderBy: { createdAt: 'desc' },
    include: {
      user: {
        select: { id: true, username: true, displayName: true, avatarUrl: true }
      },
      drink: true
    }
  });

  res.json(feed);
};

// --- FOLLOWING ---
export const followUser = async (req: AuthRequest, res: Response) => {
  const targetUserId = req.params.userId;
  const followerId = req.user.id;

  if (targetUserId === followerId) {
    return res.status(400).json({ message: "You cannot follow yourself" });
  }

  // Use a transaction to ensure both records update or none do
  await prisma.$transaction([
    prisma.follow.create({
      data: { followerId, followingId: targetUserId }
    }),
    prisma.user.update({
      where: { id: followerId },
      data: { followingCount: { increment: 1 } }
    }),
    prisma.user.update({
      where: { id: targetUserId },
      data: { followersCount: { increment: 1 } }
    })
  ]);

  res.sendStatus(200);
};

export const unfollowUser = async (req: AuthRequest, res: Response) => {
  const targetUserId = req.params.userId;
  const followerId = req.user.id;

  await prisma.$transaction([
    prisma.follow.delete({
      where: { followerId_followingId: { followerId, followingId: targetUserId } }
    }),
    prisma.user.update({
      where: { id: followerId },
      data: { followingCount: { decrement: 1 } }
    }),
    prisma.user.update({
      where: { id: targetUserId },
      data: { followersCount: { decrement: 1 } }
    })
  ]);

  res.sendStatus(204);
};

// --- LIKES ---
export const likeDrink = async (req: AuthRequest, res: Response) => {
  const { drinkId } = req.params;
  const userId = req.user.id;

  await prisma.$transaction([
    prisma.like.create({
      data: { userId, drinkId }
    }),
    prisma.drink.update({
      where: { id: drinkId },
      data: { likesCount: { increment: 1 } }
    })
  ]);

  res.sendStatus(200);
};

export const unlikeDrink = async (req: AuthRequest, res: Response) => {
  const { drinkId } = req.params;
  const userId = req.user.id;

  await prisma.$transaction([
    prisma.like.delete({
      where: { userId_drinkId: { userId, drinkId } }
    }),
    prisma.drink.update({
      where: { id: drinkId },
      data: { likesCount: { decrement: 1 } }
    })
  ]);

  res.sendStatus(204);
};

// --- COMMENTS ---
export const addComment = async (req: AuthRequest, res: Response) => {
  const { drinkId } = req.params;
  const { content } = req.body;

  if (!content) return res.status(400).json({ message: "Content is required" });

  const comment = await prisma.$transaction(async (tx) => {
    const newComment = await tx.comment.create({
      data: { userId: req.user.id, drinkId, content },
      include: { user: { select: { displayName: true, username: true } } }
    });

    await tx.drink.update({
      where: { id: drinkId },
      data: { commentsCount: { increment: 1 } }
    });

    return newComment;
  });

  res.status(201).json(comment);
};

export const getComments = async (req: AuthRequest, res: Response) => {
  const { drinkId } = req.params;

  const comments = await prisma.comment.findMany({
    where: { drinkId },
    include: {
      user: { select: { displayName: true, avatarUrl: true } }
    },
    orderBy: { createdAt: 'asc' }
  });

  res.json(comments);
};