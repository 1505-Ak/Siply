import { Router } from 'express';
import { handleUpload, upload } from '../controllers/mediaController';
import { authenticate } from '../middleware/auth';

const router = Router();
router.post('/upload', authenticate, upload.single('file'), handleUpload);
export default router;