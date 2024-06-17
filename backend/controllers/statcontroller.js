/*const Tool = require('../models/tool_model');
const Machine = require('../models/machine_model');
const Assignment = require('../models/assignment');

exports.getToolUsageStats = async (req, res) => {
  try {
    const totalTools = await Tool.countDocuments();
    const assignedTools = await Machine['tools'].countDocuments();

    const data = {
      totalTools,
      assignedTools,
      unusedTools: totalTools - assignedTools
    };

    res.status(200).json(data);
  } catch (error) {
    console.error('Error fetching tool usage stats:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};*/
const Tool = require('../models/tool_model');
const Machine = require('../models/machine_model');
const mongoose =require('mongoose')
exports.getToolUsageStats = async (req, res) => {
    try {
      // Count the total number of tools
      const totalTools = await Tool.countDocuments();
  
      // Find all machines and get the number of currently assigned tools
      const machines = await Machine.find().populate('tools');
      let assignedTools = 0;
  
      machines.forEach(machine => {
        assignedTools += machine.tools.length;
      });
      
      const unusedTools = totalTools - assignedTools;
  
      const data = {
        totalTools,
        assignedTools,
        unusedTools
      };
  
      res.status(200).json(data);
    } catch (error) {
      console.error('Error fetching tool usage stats:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };

