const Assignment = require('../models/assignment');
const Machine = require('../models/machine_model'); // Import the Machine model
const Tool = require('../models/tool_model'); // Import the Tool model

// Controller function to create a new assignment
const mongoose = require('mongoose');

/*exports.createAssignment = async (req, res) => {
  try {
    const { machineName, toolNS } = req.body;

    // Find the machine by name
    const machine = await Machine.findOne({ name: machineName });
    if (!machine) {
      return res.status(404).json({ error: 'Machine not found' });
    }

    // Ensure toolNS is an array
    const toolNSArray = Array.isArray(toolNS) ? toolNS : [toolNS];

    // Find the tool by NS
    const tools = await Tool.find({ NS: { $in: toolNSArray } });
    if (tools.length !== toolNSArray.length) {
      return res.status(404).json({ error: 'Some tools not found' });
    }

    // Check if any of the tools are already assigned to another machine
    const existingAssignments = await Assignment.find({ tool: { $in: tools.map(tool => tool._id) } });
    if (existingAssignments.length > 0) {
      const assignedTools = existingAssignments.map(assignment => assignment.tool.toString());
      return res.status(409).json({
        message: 'Some tools already assigned to another machine',
        alreadyAssignedTools: assignedTools
      });
    }

    // Assign the tools to the machine and save assignments
    const assignments = tools.map(tool => ({
      machine: machine._id,
      tool: tool._id
    }));

    const savedAssignments = await Assignment.insertMany(assignments);

    machine.tools.push(...tools.map(tool => tool.NS));
    await machine.save();

    res.status(201).json({
      assignments: savedAssignments,
      machineName: machine.name,
      toolNS: tools.map(tool => tool.NS)
    });
  } catch (error) {
    console.error('Error creating assignment:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};*/

exports.createAssignment = async (req, res) => {
  try {
    const { machineName, toolNS } = req.body;

    // Find the machine by name
    const machine = await Machine.findOne({ name: machineName });
    if (!machine) {
      return res.status(404).json({ error: 'Machine not found' });
    }
    const toolNSArray = Array.isArray(toolNS) ? toolNS : [toolNS];

    // Find the tool by NS
    
    const tool = await Tool.findOne({ NS: toolNS });
    if (!tool) {
      return res.status(404).json({ error: 'Tool not found' });
    }
    
    // Create a new assignment document
    const assignment = new Assignment({
      machine: machine._id, // Assign the machine ObjectId
      tool: tool._id // Assign the tool ObjectId
    });

    // Save the assignment to the database
    const savedAssignment = await assignment.save();
    // li louta kentch cmnt
    machine.tools.push(toolNS);
    await machine.save();
    // Send response with machine name and tool NS
    res.status(201).json({
      _id: savedAssignment._id,
      machineName: machine.name,
      toolNS: tool.NS
    });
  } catch (error) {
    console.error('Error creating assignment:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
exports.createAssignment2 = async (req, res) => {
  try {
    const { machineName, toolNS } = req.body;

    // Find the machine by name
    const machine = await Machine.findOne({ name: machineName });
    if (!machine) {
      return res.status(404).json({ error: 'Machine not found' });
    }
    const toolNSArray = Array.isArray(toolNS) ? toolNS : [toolNS];

    // Find the tool by NS
    
    const tool = await Tool.findOne({ NS: toolNS });
    if (!tool) {
      return res.status(404).json({ error: 'Tool not found' });
    }
    
    // Create a new assignment document
    const assignment = new Assignment({
      machine: machine._id, // Assign the machine ObjectId
      tool: tool._id // Assign the tool ObjectId
    });

    // Save the assignment to the database
    const savedAssignment = await assignment.save();
    // li louta kentch cmnt
    //machine.tools.push(toolNS);
    await machine.save();
    // Send response with machine name and tool NS
    res.status(201).json({
      _id: savedAssignment._id,
      machineName: machine.name,
      toolNS: tool.NS
    });
  } catch (error) {
    console.error('Error creating assignment:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
/*exports.createAssignment = async (req, res) => {
  try {
    const { machineName, toolNS } = req.body;

    // Find the machine by name
    const machine = await Machine.findOne({ name: machineName });
    if (!machine) {
      return res.status(404).json({ error: 'Machine not found' });
    }

    // Find the tool by NS
    const tool = await Tool.findOne({ NS: toolNS });
    if (!tool) {
      console.log('Tool not found');
      return res.status(404).json({ error: 'Tool not found' });
    }

    // Check if the tool is already assigned to another machine
    const existingAssignment = await Machine.findOne({ tool: tool.NS });
    if (existingAssignment) {
      console.log('Tool already assigned to another machine');
      return res.status(409).json({ error: 'Tool already assigned to another machine' });
    }

    // Check if the machine already has this tool assigned
    if (machine.tools.includes(tool.NS)) {
      console.log('Tool already assigned to this machine');
      return res.status(409).json({ error: 'Tool already assigned to this machine' });
    }

    // Create a new assignment document
    const assignment = new Assignment({
      machine: machine._id, // Assign the machine ObjectId
      tool: tool._id // Assign the tool ObjectId
    });

    // Save the assignment to the database
    const savedAssignment = await assignment.save();

    // Update the machine's tools list
    machine.tools.push(tool._id);
    await machine.save();

    // Send response with machine name and tool NS
    res.status(201).json({
      _id: savedAssignment._id,
      machineName: machine.name,
      toolNS: tool.NS
    });
  } catch (error) {
    console.error('Error creating assignment:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};*/


// Controller function to get all assignments
exports.getAllAssignments = async (req, res) => {
  try {
    const assignments = await Assignment.find()
      .populate({ path: 'machine', select: 'name' }) // Populate the machine name
      .populate({ path: 'tool', select: 'NS' }); // Populate the tool NS
    res.json(assignments);
  } catch (error) {
    console.error('Error fetching assignments:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
exports.deleteAllAssignments = async (req, res) => {
  try {
    const result = await Assignment.deleteMany({});
    res.json({ message: `Deleted ${result.deletedCount} assignments.` });
  } catch (error) {
    console.error('Error deleting all assignments:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};
// Controller function to delete an assignment by ID
exports.deleteAssignmentById = async (req, res) => {
  const { id } = req.params;
  try {
    const deletedAssignment = await Assignment.findByIdAndDelete(id);
    if (!deletedAssignment) {
      return res.status(404).json({ error: 'Assignment not found' });
    }
    res.json(deletedAssignment);
  } catch (error) {
    console.error('Error deleting assignment:', error);
    res.status(500).json({ error: 'Internal server error' });
  }
};

// Other controller functions such as updating an assignment, getting assignment by ID, etc., can be added similarly.
