import { Router } from 'express';
import * as venueController from '../controllers/venueController';
import { authenticate } from '../middleware/auth';

const router = Router();

router.use(authenticate);

// Discovery
router.get('/', venueController.listVenues);
router.get('/deals/student', venueController.getStudentDiscounts);
router.get('/deals/happy-hour', venueController.getHappyHourDeals);
router.get('/:id', venueController.getVenue);

// Loyalty
router.get('/me/progress', venueController.getMyLoyaltyProgress);
router.post('/:venueId/visit', venueController.recordVisit);

export default router;