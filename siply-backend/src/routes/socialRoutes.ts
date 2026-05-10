import { Router } from 'express';
import * as socialController from '../controllers/socialController';
import { authenticate } from '../middleware/auth';

const router = Router();

router.use(authenticate);

router.get('/feed', socialController.getFeed);

// Following
router.post('/follow/:userId', socialController.followUser);
router.delete('/follow/:userId', socialController.unfollowUser);

// Likes
router.post('/likes/:drinkId', socialController.likeDrink);
router.delete('/likes/:drinkId', socialController.unlikeDrink);

// Comments
router.get('/comments/:drinkId', socialController.getComments);
router.post('/comments/:drinkId', socialController.addComment);

export default router;