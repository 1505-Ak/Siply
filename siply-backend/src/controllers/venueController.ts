import { Response } from "express";
import { AuthRequest } from "../middleware/auth";
import { prisma } from "../config/prisma";

// --- LIST & SEARCH ---
export const listVenues = async (req: AuthRequest, res: Response) => {
  const { city, category } = req.query;

  const venues = await prisma.venue.findMany({
    where: {
      city: city
        ? { contains: city as string, mode: "insensitive" }
        : undefined,
      category: category
        ? { equals: category as string, mode: "insensitive" }
        : undefined,
    },
    include: {
      loyaltyPrograms: true,
      discounts: { where: { isActive: true } },
    },
  });

  res.json(venues);
};

export const getVenue = async (req: AuthRequest, res: Response) => {
  const { id } = req.params;

  const venue = await prisma.venue.findUnique({
    where: { id },
    include: {
      loyaltyPrograms: true,
      discounts: { where: { isActive: true } },
    },
  });

  if (!venue) return res.status(404).json({ message: "Venue not found" });
  res.json(venue);
};

// --- DEALS ---
export const getStudentDiscounts = async (req: AuthRequest, res: Response) => {
  const venues = await prisma.venue.findMany({
    where: { hasStudentDiscount: true },
    include: {
      discounts: { where: { requiresStudentId: true, isActive: true } },
    },
  });
  res.json(venues);
};

export const getHappyHourDeals = async (req: AuthRequest, res: Response) => {
  const venues = await prisma.venue.findMany({
    where: { hasHappyHour: true },
    include: { discounts: { where: { isActive: true } } },
  });
  res.json(venues);
};

// --- USER LOYALTY PROGRESS ---
export const getMyLoyaltyProgress = async (req: AuthRequest, res: Response) => {
  const userId = req.user.id;

  const progress = await prisma.userLoyaltyProgress.findMany({
    where: { userId },
    include: { venue: true },
  });

  res.json(progress);
};

/**
 * Logic for recording a visit (Punching the card or adding points)
 * Replicates the logic hinted at in VenueManager.swift
 */
export const recordVisit = async (req: AuthRequest, res: Response) => {
  const userId = req.user.id;
  const { venueId } = req.params;
  const { pointsToAdd = 10 } = req.body;

  const progress = await prisma.userLoyaltyProgress.upsert({
    where: {
      userId_venueId: { userId, venueId },
    },
    update: {
      visitCount: { increment: 1 },
      pointsEarned: { increment: pointsToAdd },
      lastVisit: new Date(),
    },
    create: {
      userId,
      venueId,
      visitCount: 1,
      pointsEarned: pointsToAdd,
      lastVisit: new Date(),
    },
  });

  res.json(progress);
};
