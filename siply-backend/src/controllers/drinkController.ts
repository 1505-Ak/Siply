import { Response } from "express";
import { AuthRequest } from "../middleware/auth";
import { prisma } from "../config/prisma";

export const createDrink = async (req: AuthRequest, res: Response) => {
  const userId = req.user.id;
  const {
    name,
    category,
    rating,
    price,
    notes,
    locationName,
    locationCity,
    locationCountry,
    latitude,
    longitude,
    imageUrl,
    tags,
    isFavorite,
  } = req.body;

  try {
    const result = await prisma.$transaction(async (tx) => {
      // 1. Create the Drink
      const drink = await tx.drink.create({
        data: {
          userId,
          name,
          category,
          rating: rating.toString(),
          price: price ? price.toString() : null,
          notes,
          locationName,
          locationCity,
          locationCountry,
          latitude: latitude ? latitude.toString() : null,
          longitude: longitude ? longitude.toString() : null,
          imageUrl,
          tags: tags || [],
          isFavorite: isFavorite || false,
        },
      });

      // 2. Create the Feed Post
      await tx.feedPost.create({
        data: {
          userId,
          drinkId: drink.id,
          content: notes,
          imageUrl,
        },
      });

      // 3. Calculate Stats
      const totalDrinks = await tx.drink.count({ where: { userId } });

      const distinctCities = await tx.drink.findMany({
        where: { userId, locationCity: { not: null } },
        distinct: ["locationCity"],
        select: { locationCity: true },
      });

      const distinctCountries = await tx.drink.findMany({
        where: { userId, locationCountry: { not: null } },
        distinct: ["locationCountry"],
        select: { locationCountry: true },
      });

      // --- ADDED: Calculate Average Rating ---
      const ratingAggregation = await tx.drink.aggregate({
        where: { userId },
        _avg: { rating: true },
      });
      const avgRating = ratingAggregation._avg.rating || 0;

      // 4. Update the User Object
      await tx.user.update({
        where: { id: userId },
        data: {
          totalDrinks: totalDrinks,
          totalCities: distinctCities.length,
          totalCountries: distinctCountries.length,
          avgRating: avgRating, // Saving the calculated average!
        },
      });

      return drink;
    });

    res.status(201).json(result);
  } catch (error) {
    console.error("Create Drink Error:", error);
    res.status(500).json({ message: "Failed to create drink" });
  }
};

export const listUserDrinks = async (req: AuthRequest, res: Response) => {
  const drinks = await prisma.drink.findMany({
    where: { userId: req.user.id },
    orderBy: { createdAt: "desc" },
  });
  res.json(drinks);
};

export const getTrending = async (req: AuthRequest, res: Response) => {
  const drinks = await prisma.drink.findMany({
    orderBy: { likesCount: "desc" },
    take: 20,
  });
  res.json(drinks);
};

export const deleteDrink = async (req: AuthRequest, res: Response) => {
  const { id }: any = req.params;
  const userId = req.user.id;

  try {
    const drink = await prisma.drink.findUnique({ where: { id } });

    if (!drink || drink.userId !== userId) {
      return res.status(403).json({ message: "Forbidden or not found" });
    }

    await prisma.$transaction(async (tx) => {
      await tx.drink.delete({ where: { id } });

      // Re-calculate stats upon deletion
      const totalDrinks = await tx.drink.count({ where: { userId } });

      // --- ADDED: Recalculate Average Rating on Delete ---
      const ratingAggregation = await tx.drink.aggregate({
        where: { userId },
        _avg: { rating: true },
      });
      const avgRating = ratingAggregation._avg.rating || 0;

      await tx.user.update({
        where: { id: userId },
        data: {
          totalDrinks,
          avgRating,
        },
      });
    });

    res.sendStatus(204);
  } catch (error) {
    res.status(500).json({ message: "Failed to delete drink" });
  }
};

export const getDrinkById = async (req: AuthRequest, res: Response) => {
  const { id }: any = req.params;

  try {
    const drink = await prisma.drink.findUnique({
      where: { id },
      include: {
        user: {
          select: {
            id: true,
            username: true,
            displayName: true,
            avatarUrl: true,
          },
        },
        _count: {
          select: {
            likes: true,
            comments: true,
          },
        },
      },
    });

    if (!drink) return res.status(404).json({ message: "Drink not found" });

    res.json(drink);
  } catch (error) {
    res.status(500).json({ message: "Error fetching drink details" });
  }
};
