import { Request, Response } from "express";
import bcrypt from "bcryptjs";
import jwt from "jsonwebtoken";
import crypto from "crypto";
import { prisma } from "../config/prisma.js";
import { JWT_CONFIG } from "../config/auth.js";

// Helper to hash refresh tokens (parities with Java hash() method)
const hashToken = (token: string) =>
  crypto.createHash("sha256").update(token).digest("hex");

const generateTokens = async (user: any) => {
  const accessToken = jwt.sign({ username: user.username }, JWT_CONFIG.secret, {
    expiresIn: JWT_CONFIG.accessTtl,
  });

  // Generate a UUID style refresh token like the Java backend
  const plainRefreshToken = crypto.randomUUID();
  const expiresAt = new Date();
  expiresAt.setDate(expiresAt.getDate() + JWT_CONFIG.refreshTtlDays);

  // Clean old tokens and save new hashed one
  await prisma.refreshToken.deleteMany({ where: { userId: user.id } });
  await prisma.refreshToken.create({
    data: {
      userId: user.id,
      tokenHash: hashToken(plainRefreshToken),
      expiresAt,
    },
  });

  return { accessToken, refreshToken: plainRefreshToken };
};

export const register = async (req: Request, res: Response) => {
  const { username, email, password, displayName } = req.body;

  const existing = await prisma.user.findFirst({
    where: { OR: [{ username }, { email }] },
  });
  if (existing)
    return res.status(400).json({ message: "Username or email already taken" });

  const passwordHash = await bcrypt.hash(password, 10);

  const user = await prisma.user.create({
    data: { username, email, passwordHash, displayName },
  });

  const { accessToken, refreshToken } = await generateTokens(user);

  // Return structure matching UserResponse.java
  const { passwordHash: _, ...userResponse } = user;
  res.status(201).json({ accessToken, refreshToken, user: userResponse });
};

export const login = async (req: Request, res: Response) => {
  const { username, password } = req.body;

  const user = await prisma.user.findUnique({ where: { username } });
  if (!user || !(await bcrypt.compare(password, user.passwordHash))) {
    return res.status(401).json({ message: "Invalid credentials" });
  }

  const { accessToken, refreshToken } = await generateTokens(user);
  const { passwordHash: _, ...userResponse } = user;
  res.json({ accessToken, refreshToken, user: userResponse });
};

export const me = async (req: any, res: Response) => {
  const { passwordHash: _, ...userResponse } = req.user;
  res.json(userResponse);
};

export const refresh = async (req: Request, res: Response) => {
  const authHeader = req.headers.authorization;
  if (!authHeader?.startsWith("Bearer ")) return res.sendStatus(401);

  const plainToken = authHeader.split(" ")[1];
  const hashed = hashToken(plainToken);

  const storedToken = await prisma.refreshToken.findUnique({
    where: { tokenHash: hashed },
    include: { user: true },
  });

  if (!storedToken || storedToken.expiresAt < new Date()) {
    return res
      .status(401)
      .json({ message: "Refresh token expired or invalid" });
  }

  const { accessToken, refreshToken } = await generateTokens(storedToken.user);
  const { passwordHash: _, ...userResponse } = storedToken.user;
  res.json({ accessToken, refreshToken, user: userResponse });
};
