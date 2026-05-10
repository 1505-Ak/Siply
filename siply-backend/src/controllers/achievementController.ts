import { Response } from "express";
import { AuthRequest } from "../middleware/auth";
import { prisma } from "../config/prisma";

// --- LIST CATALOG ---
export const listAllAchievements = async (req: AuthRequest, res: Response) => {
  const achievements = await prisma.achievement.findMany();
  res.json(achievements);
};

// --- GET USER TROPHIES ---
export const getUserAchievements = async (req: AuthRequest, res: Response) => {
  const userId = req.user.id;

  const unlocked = await prisma.userAchievement.findMany({
    where: { userId },
    include: { achievement: true },
    orderBy: { unlockedAt: "desc" },
  });

  res.json(unlocked);
};

// --- CHECK & UNLOCK LOGIC ---
export const checkAchievements = async (req: AuthRequest, res: Response) => {
  const userId = req.user.id;

  // 1. Fetch user statistics from the DB
  const drinkCount = await prisma.drink.count({ where: { userId } });

  const locations = await prisma.drink.groupBy({
    by: ["locationName"],
    where: { userId, NOT: { locationName: null } },
  });
  const locationCount = locations.length;

  const fiveStarDrinks = await prisma.drink.count({
    where: { userId, rating: 5.0 },
  });

  // 2. Fetch all achievement definitions
  const allAchievements = await prisma.achievement.findMany();

  // 3. Fetch already unlocked achievements to avoid duplicates
  const alreadyUnlocked = await prisma.userAchievement.findMany({
    where: { userId },
    select: { achievementId: true },
  });
  const unlockedIds = new Set(alreadyUnlocked.map((a) => a.achievementId));

  const newlyUnlocked = [];

  // 4. Achievement Logic Rules (Matching Achievement.swift)
  for (const achievement of allAchievements) {
    if (unlockedIds.has(achievement.id)) continue;

    let isEligible = false;

    switch (achievement.code) {
      case "FIRST_DRINK":
        if (drinkCount >= 1) isEligible = true;
        break;
      case "TEN_DRINKS":
        if (drinkCount >= 10) isEligible = true;
        break;
      case "EXPLORER":
        if (locationCount >= 10) isEligible = true;
        break;
      case "PERFECTIONIST":
        if (fiveStarDrinks >= 1) isEligible = true;
        break;
      case "LEGEND":
        if (drinkCount >= 100) isEligible = true;
        break;
    }

    if (isEligible) {
      const record = await prisma.userAchievement.create({
        data: { userId, achievementId: achievement.id },
        include: { achievement: true },
      });
      newlyUnlocked.push(record);
    }
  }

  res.json({
    message:
      newlyUnlocked.length > 0
        ? `Unlocked ${newlyUnlocked.length} new achievements!`
        : "No new achievements",
    newlyUnlocked,
    stats: { drinkCount, locationCount, fiveStarDrinks },
  });
};
