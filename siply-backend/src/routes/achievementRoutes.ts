import { Router } from 'express';
import * as achievementController from '../controllers/achievementController';
import { authenticate } from '../middleware/auth';

const router = Router();

router.use(authenticate);

router.get('/', achievementController.listAllAchievements);
router.get('/user', achievementController.getUserAchievements);
router.post('/check', achievementController.checkAchievements);

export default router;