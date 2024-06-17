const express = require('express')
const router = express.Router()
//const { gettool }=require('../models/tool_model');

const Tool = require('../models/tool_model')
const { getToolCount, gettool, createtool, deletetool, updatetool } = require('../controllers/toolcontroller')

//get all tools
router.get('/',gettool);
//get one tools
router.get('/count',getToolCount);
//get one tools
//post one tools
router.post('/', createtool);

//delete one tools
router.delete('/:id',deletetool);
//update one tools
router.patch('/:d',updatetool);
//get single tool
/*router.get('/:id',getsingletool)
//post single tool
router.post('/', createtool)

//delete one tool
router.delete('/:id',deletetool)
//update one tool
router.patch('/:id',updatetool)*/
module.exports=router