const express = require('express')
const router = express.Router()
const User = require('../models/users_model');

const Repair = require('../models/repair_model')
const { getrepair, getsinglerepair, createrepair, deleterepair, updaterepair } = require('../controllers/repair_controller')
// Endpoint to update FCM token

//get all repairs
router.get('/',getrepair);
//get one repairs
router.get('/:id',getsinglerepair);
//post one repairs
router.post('/', createrepair);

//delete one repairs
router.delete('/:id',deleterepair);
//update one repairs
router.put('/:id',updaterepair);

module.exports=router