import { Router } from 'express';
import * as userController from '../controllers/userController';
import { authenticate } from '../middleware/auth';

const router = Router();

router.get('/search', authenticate, userController.searchUsers);
router.put('/profile', authenticate, userController.updateProfile);
router.get('/:username', authenticate, userController.getPublicProfile);

export default router;