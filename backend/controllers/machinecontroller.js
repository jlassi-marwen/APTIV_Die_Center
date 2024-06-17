const Machine = require('../models/machine_model');
const Tool = require('../models/tool_model');
const Assignment = require('../models/assignment');
const mongoose = require('mongoose');
const { ObjectId } = mongoose.Types;

// Create a new machine
const createmachine = async (req, res) => {
  const { name } = req.body;
  if (!name) {
    return res.status(400).json({ error: 'Name is required' });
  }
  try {
    const machine = await Machine.create({ name });
    res.status(200).json(machine);
  } catch (error) {
    res.status(400).json({ error: error.message });
  }
};

// Get all machines
const getallmachines = async (req, res) => {
  try {
    const machines = await Machine.find();
    res.status(200).json(machines);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
};

// Assign tools to a machine
/*const assignToolToMachine = async (req, res) => {
  try {
    const { name, tools } = req.body;
    console.log('Received request:', { name, tools });

    // Find the machine by name
    const machine = await Machine.findOne({ name }).populate('tools');
    if (!machine) {
      console.error('Machine not found');
      return res.status(404).json({ message: 'Machine not found' });
    }

    // Ensure tools is an array
    const toolNSArray = Array.isArray(tools) ? tools : [tools];

    // Find the tools by NS
    const toolsArray = await Tool.find({ NS: { $in: toolNSArray } });

    // Check if any of the tools are already assigned to another machine
    const existingAssignments = await Assignment.find({ tool: { $in: toolsArray.map(tool => tool._id) } }).populate('machine');
    if (existingAssignments.length > 0) {
      const assignedTools = existingAssignments.map(assignment => assignment.tool.toString());
      const alreadyAssignedTools = toolsArray.filter(tool => assignedTools.includes(tool._id.toString()));
      console.error('Some tools already assigned to another machine:', alreadyAssignedTools.map(tool => tool.NS));
      return res.status(409).json({
        message: 'Some tools already assigned to another machine',
        alreadyAssignedTools: alreadyAssignedTools.map(tool => tool.NS),
        assignedMachines: existingAssignments.map(a => a.machine.name)
      });
    }

    // Check if the machine already has any of the tools
    const existingTools = machine.tools.filter(machineTool => toolsArray.some(tool => tool._id.equals(machineTool._id)));
    if (existingTools.length > 0) {
      console.error('Machine already has some of the tools');
      return res.status(400).json({ message: 'Machine already has some of the tools' });
    }

    // Assign the tools to the machine
    toolsArray.forEach(tool => {
      tool.timestamp = new Date(); // Set the current timestamp
    });

    machine.tools.push(...toolsArray);

    await Promise.all(toolsArray.map(tool => tool.save())); // Save all tools with updated timestamp
    await machine.save();

    // Create assignments
    const assignments = toolsArray.map(tool => ({
      machine: machine._id,
      tool: tool._id
    }));

    const savedAssignments = await Assignment.insertMany(assignments);

    console.log('Tools assigned successfully');
    res.status(200).json(machine);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
};*/
const assignToolToMachine = async (req, res) => {
  try {
    const { name, tools } = req.body;
    console.log('Received request:', { name, tools });

    // Find the machine by name
    const machine = await Machine.findOne({ name }).populate('tools');
    if (!machine) {
      console.error('Machine not found');
      return res.status(404).json({ message: 'Machine not found' });
    }

    // Ensure tools is an array
    const toolNSArray = Array.isArray(tools) ? tools : [tools];

    // Find the tools by NS
    const toolsArray = await Tool.find({ NS: { $in: toolNSArray } });
    if (toolsArray.length !== toolNSArray.length) {
      console.error('Some tools do not exist in the database');
      const existingToolNS = toolsArray.map(tool => tool.NS);
      const nonExistingTools = toolNSArray.filter(ns => !existingToolNS.includes(ns));
      return res.status(404).json({ message: 'Some tools do not exist in the database', nonExistingTools });
    }

    // Check if any of the tools are already assigned to another machine
    const existingAssignments = await Assignment.find({ tool: { $in: toolsArray.map(tool => tool._id) } }).populate('machine');
    if (existingAssignments.length > 0) {
      const assignedTools = existingAssignments.map(assignment => assignment.tool.toString());
      const alreadyAssignedTools = toolsArray.filter(tool => assignedTools.includes(tool._id.toString()));
      console.error('Some tools already assigned to another machine:', alreadyAssignedTools.map(tool => tool.NS));
      return res.status(409).json({
        message: 'Some tools already assigned to another machine',
        alreadyAssignedTools: alreadyAssignedTools.map(tool => tool.NS),
        assignedMachines: existingAssignments.map(a => a.machine.name)
      });
    }

    // Check if the machine already has any of the tools
    const existingTools = machine.tools.filter(machineTool => toolsArray.some(tool => tool._id.equals(machineTool._id)));
    if (existingTools.length > 0) {
      console.error('Machine already has some of the tools');
      return res.status(400).json({ message: 'Machine already has some of the tools' });
    }

    // Assign the tools to the machine
    toolsArray.forEach(tool => {
      tool.timestamp = new Date(); // Set the current timestamp
    });

    machine.tools.push(...toolsArray);

    await Promise.all(toolsArray.map(tool => tool.save())); // Save all tools with updated timestamp
    await machine.save();

    // Create assignments
    const assignments = toolsArray.map(tool => ({
      machine: machine._id,
      tool: tool._id
    }));

    const savedAssignments = await Assignment.insertMany(assignments);

    console.log('Tools assigned successfully');
    res.status(200).json(machine);
  } catch (err) {
    console.error(err);
    res.status(500).json({ message: 'Server Error' });
  }
};



// Remove tools from a machine
/*const removeToolFromMachine = async (req, res) => {
  try {
    const { name, tools } = req.body;

    // Find the machine by name
    const machine = await Machine.findOne({ name }).populate('tools');
    if (!machine) {
      return res.status(404).json({ error: 'Machine not found' });
    }

    // Ensure tools is an array
    const toolNSArray = Array.isArray(tools) ? tools : [tools];

    // Remove the tools from the machine's tools array
    machine.tools = machine.tools.filter(tool => !toolNSArray.includes(tool._id.toString()));
    await machine.save();

    // Remove the corresponding assignments
    await Assignment.deleteMany({
      machine: machine._id,
      tool: { $in: toolNSArray.map(tool => new ObjectId(tool)) }
    });

    res.status(200).json({ message: 'Tools removed from machine successfully' });
  } catch (error) {
    console.error('Error removing tool from machine:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};*/
const removeToolFromMachine = async (req, res) => {
  try {
      const { name, tools } = req.body;

      // Find the machine by name
      const machine = await Machine.findOne({ name: name });
      if (!machine) {
          return res.status(404).json({ error: 'Machine not found' });
      }

      // Check if the tool exists in the machine's tools array
      const toolIndex = machine.tools.indexOf(tools);
      if (toolIndex === -1) {
          return res.status(404).json({ error: 'Tool not found in the machine' });
      }

      // Remove the tool from the machine's tools array
      machine.tools.splice(toolIndex, 1);
      await machine.save();

      res.status(200).json({ message: 'Tool removed from machine successfully' });
  } catch (error) {
      console.error('Error removing tool from machine:', error);
      res.status(500).json({ error: 'Internal server error' });
  }
};

// Delete a machine
const deletemachine = async (req, res) => {
  const { id } = req.params;
  if (!mongoose.Types.ObjectId.isValid(id)) {
    return res.status(404).json({ error: 'Invalid machine ID' });
  }
  try {
    const deletedMachine = await Machine.findByIdAndDelete(id);
    if (!deletedMachine) {
      return res.status(404).json({ message: 'Machine not found' });
    }
    res.status(200).json(deletedMachine);
  } catch (error) {
    console.error('Error deleting machine:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

module.exports = {
  createmachine,
  getallmachines,
  assignToolToMachine,
  removeToolFromMachine,
  deletemachine
};
