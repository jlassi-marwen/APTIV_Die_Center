const Tool = require('../models/tool_model')
const Assignment = require('../models/assignment')

const mongoose =require('mongoose')
const getToolCount = async (req, res) => {
    try {
      // Total tools count
      const totalTools = await Tool.countDocuments({});
  
      // Assigned tools count
      const assignedTools = await Assignment.countDocuments({});
  
      res.status(200).json({
        totalTools,
        assignedTools
      });
    } catch (error) {
      console.error('Error fetching tool count:', error);
      res.status(500).json({ error: 'Internal server error' });
    }
  };
//create new tool
const createtool = async (req, res) => {
    const { NS, ref } = req.body;

    try {
        // Check if NS is provided
        if (!NS || !ref) {
            return res.status(400).json({ error: 'NS and ref are required' });
        }

        // Check if NS is unique
        const existingTool = await Tool.findOne({ NS });
        if (existingTool) {
            return res.status(400).json({ error: 'NS must be unique' });
        }

        // Create the tool
        const tool = await Tool.create({ NS, ref });
        res.status(200).json(tool);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};
/*const createtool = async (req, res) => {
    const tools = req.body;

    if (!Array.isArray(tools)) {
        return res.status(400).json({ error: 'Request body must be an array of tools' });
    }

    try {
        const createdTools = [];

        for (const tool of tools) {
            const { NS, ref } = tool;

            // Check if NS and ref are provided
            if (!NS || !ref) {
                return res.status(400).json({ error: 'NS and ref are required for all tools' });
            }

            // Check if NS is unique
            const existingTool = await Tool.findOne({ NS });
            

            // Create the tool
            const newTool = await Tool.create({ NS, ref });
            createdTools.push(newTool);
        }

        res.status(200).json(createdTools);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};
*/

//get all tools
const gettool=async(req,res)=>{
    const tools=await Tool.find({}).sort({createdAt:-1})//sort by date , newest at top , if i do find{NS:333} it will display all tools with same NS
    res.status(200).json({tools})
}
//get one tool
const getsingletool=async(req,res)=>{
    const { id }=req.params// TO DO : replace id with NS later
    if(!mongoose.Types.ObjectId.isValid(id)){
        return res.status(404).json({error:'no such tool'})
    }
    const getsingletool=await Tool.findById(id)

    if(!Tool){
       return res.status(200).json({msg:'tools does not exist'})
    }

    res.status(200).json(getsingletool)
    
}
//delete a tool
/*const deletetool=async(req,res)=>{
    const{id}=req.params
    if(!mongoose.Types.ObjectId.isValid(id)){
        return res.status(404).json({error:'no such tool'})
    }
    const deletetool=await Tool.findByIdAndDelete({_id: id})
    if(!Tool){
        return res.status(400).json({msg:'tool does not exist'})
     }
 
     res.status(200).json(deletetool)
}*/
const deletetool = async (req, res) => {
    const { id } = req.params;
  
    // Check if the provided ID is a valid ObjectId
    if (!mongoose.Types.ObjectId.isValid(id)) {
      return res.status(404).json({ error: 'No such tool' });
    }
  
    try {
      // Find the tool by ID and delete it
      const deletedTool = await Tool.findByIdAndDelete(id);
  
      // Check if no tool was found with that ID
      if (!deletedTool) {
        return res.status(404).json({ msg: 'Tool does not exist' });
      }
  
      // Return the deleted tool object on success
      res.status(200).json(deletedTool);
    } catch (error) {
      // Handle any errors that occur during the deletion process
      console.error('Error deleting tool:', error);
      res.status(500).json({ msg: 'Server error' });
    }
  };
  
/*const deletetool = async (req, res) => {
    const { NS } = req.params;

    try {
        // Check if NS is provided and valid
        if (!NS) {
            return res.status(404).json({ error: 'NS is required' });
        }

        // Find the tool by NS and delete it
        const deletedTool = await Tool.findOneAndDelete({ NS });

        // Check if the tool exists and was successfully deleted
        if (!deletedTool) {
            return res.status(400).json({ error: 'Tool does not exist' });
        }

        // Return the deleted tool
        res.status(200).json(deletedTool);
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Internal server error' });
    }
};*/

// update a tool
const updatetool=async(req,res)=>{
    const{id}=req.params
    
    if(!mongoose.Types.ObjectId.isValid(id)){
        return res.status(404).json({error:'no such tool'})
    }
    const updatetool=await User.findByIdAndUpdate({_id: id},{
        ...req.body
    })
    if(!Tool){
        return res.status(400).json({msg:'tool does not exist'})
     }
 
     res.status(200).json(updatetool)
}

module.exports={
    getToolCount,
    
    createtool,
    gettool,
    getsingletool,
    deletetool,
    updatetool
}