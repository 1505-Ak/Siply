import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import authRoutes from './routes/authRoutes';
import drinkRoutes from './routes/drinkRoutes';
import mediaRoutes from './routes/mediaRoutes';
import socialRoutes from './routes/socialRoutes';
import venueRoutes from './routes/venueRoutes';
import achievementRoutes from './routes/achievementRoutes';
import userRoutes from './routes/userRoutes';
import path from 'path';

dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());   // Enable CORS for Expo/ngrok
app.use(express.json()); // Parse JSON bodies

// Serve the 'uploads' folder statically so the app can see the images
app.use('/uploads', express.static(path.join(process.cwd(), 'uploads')));

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/drinks', drinkRoutes);
app.use('/api/media', mediaRoutes);
app.use('/api/social', socialRoutes);
app.use('/api/venues', venueRoutes);
app.use('/api/achievements', achievementRoutes); 
app.use('/api/users', userRoutes);

// Health Check
app.get('/health', (req, res) => res.json({ status: 'ok' }));

// Global Error Handler
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error(err.stack);
  res.status(err.status || 500).json({
    message: err.message || 'Internal Server Error',
  });
});

app.listen(PORT, () => {
  console.log(`🚀 Siply Node Backend running on port ${PORT}`);
});