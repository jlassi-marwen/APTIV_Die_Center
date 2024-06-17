const express = require('express');
const router = express.Router();
//const statsController = require('../controllers/statcontroller');
const { getToolUsageStats } = require('../controllers/statcontroller')

//router.get('/stats/tool-usage', statsController.getToolUsageStats);
router.get('/',getToolUsageStats);

module.exports = router;
