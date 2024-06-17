const express = require('express')
const router = express.Router()

const assignment = require('../models/assignment')
const { createAssignment2,createAssignment,deleteAssignmentById,removeToolFromMachine, deleteAllAssignments,getAllAssignments } = require('../controllers/assignmentcontroller')



router.get('/',getAllAssignments);
router.post('/',createAssignment);
router.post('/2',createAssignment2);
router.delete('/:id', deleteAssignmentById);
router.delete('/clear', deleteAllAssignments);


module.exports=router