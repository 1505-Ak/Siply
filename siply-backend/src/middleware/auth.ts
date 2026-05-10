import { Request, Response, NextFunction } from "express";
import jwt from "jsonwebtoken";
import { JWT_CONFIG } from "../config/auth";
import { prisma } from "../config/prisma";

export interface AuthRequest extends Request {
  user?: any;
}

export const authenticate = async (
  req: AuthRequest,
  res: Response,
  next: NextFunction,
) => {
  const authHeader = req.headers.authorization;

  if (!authHeader?.startsWith("Bearer ")) {
    return res.status(401).json({ message: "Not authenticated" });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, JWT_CONFIG.secret) as {
      username: string;
    };
    const user = await prisma.user.findUnique({
      where: { username: decoded.username },
    });

    if (!user) throw new Error();

    req.user = user;
    next();
  } catch (error) {
    return res.status(401).json({ message: "Invalid or expired token" });
  }
};
