import { Router } from 'express';
import * as drinkController from '../controllers/drinkController';
import { authenticate } from '../middleware/auth';

const router = Router();

router.use(authenticate); // All drink routes require auth
router.get('/', drinkController.listUserDrinks);
router.post('/', drinkController.createDrink);
router.get('/trending/all', drinkController.getTrending);
router.delete('/:id', drinkController.deleteDrink);

export default router;