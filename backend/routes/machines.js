const express = require('express')
const router = express.Router()

const machine = require('../models/machine_model')
const { createmachine,getallmachines,assignToolToMachine,removeToolFromMachine,deletemachine } = require('../controllers/machinecontroller')

//get all machines
router.get('/',getallmachines);
//get one machines
//router.get('/:id',getsinglemachine);
//post one machines
router.post('/', createmachine);
router.post('/a',assignToolToMachine)
router.delete('/',removeToolFromMachine);
router.delete('/:id',deletemachine);

//delete one machines
//router.delete('/',deletemachine);
//update one machines
//router.patch('/',updatemachine);
//get single machine
/*router.get('/:id',getsinglemachine)
//post single machine
router.post('/', createmachine)

//delete one machine
router.delete('/:id',deletemachine)
//update one machine
router.patch('/:id',updatemachine)*/
module.exports=router