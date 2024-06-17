/*const { Machine, Tool, TimeUsage } = require('./models'); // Import the Mongoose models

// Function to give a machine a tool
const giveToolToMachine = async (machineId, toolId) => {
  try {
    // Check if the machine and tool exist
    const machine = await Machine.findById(machineId);
    const tool = await Tool.findById(toolId);
    if (!machine || !tool) {
      throw new Error('Machine or tool not found');
    }

    // Check if the machine already has 3 tools
    if (machine.tools.length >= 3) {
      throw new Error('Machine already has 3 tools');
    }

    // Add the tool to the machine's list of tools
    machine.tools.push(toolId);
    await machine.save();

    // Create a time usage record for the tool
    const timeUsage = new TimeUsage({
      machine: machineId,
      tool: toolId,
      startTime: new Date(),
      endTime: null // End time will be updated when the tool is returned
    });
    await timeUsage.save();

    return 'Tool added to machine successfully';
  } catch (error) {
    throw new Error(`Failed to give tool to machine: ${error.message}`);
  }
};

module.exports = {
  giveToolToMachine
};

//function remove tool from machine
const { Machine, Tool, TimeUsage } = require('./models'); // Import the Mongoose models

// Function to remove a tool from a machine
const removeToolFromMachine = async (machineId, toolId) => {
  try {
    // Check if the machine and tool exist
    const machine = await Machine.findById(machineId);
    const tool = await Tool.findById(toolId);
    if (!machine || !tool) {
      throw new Error('Machine or tool not found');
    }

    // Remove the tool from the machine's list of tools
    machine.tools = machine.tools.filter(id => id.toString() !== toolId);
    await machine.save();

    // Update the end time of the time usage record for the tool
    const timeUsage = await TimeUsage.findOneAndUpdate(
      { machine: machineId, tool: toolId, endTime: null }, // Find the open time usage record for the tool
      { endTime: new Date() }, // Update the end time to the current time
      { new: true } // Return the updated document
    );

    if (!timeUsage) {
      throw new Error('Time usage record not found');
    }

    return 'Tool removed from machine successfully';
  } catch (error) {
    throw new Error(`Failed to remove tool from machine: ${error.message}`);
  }
};

module.exports = {
  removeToolFromMachine
};
*/