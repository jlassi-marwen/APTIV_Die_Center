const Repair = require('../models/repair_model')
const mongoose =require('mongoose')
const admin = require('firebase-admin');
const serviceAccount = require('../notifications-3b64f-firebase-adminsdk-dh5gw-2d7e4c2689.json');

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
  databaseURL: 'https://notifications-3b64f.firebaseio.com'
});
//create new repair
/*const createrepair = async (req, res) => {
    const { Machine_name, description } = req.body;

    try {
        // Check if Machine_name and desc is provided
        if (!Machine_name || !description) {
            return res.status(400).json({ error: 'Machine_name and description are required' });
        }

       

        // Create the repair
        const repair = await Repair.create({ Machine_name, description });
        res.status(200).json(repair);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
    
};*/
/*const createrepair = async (req, res) => {
    const { Machine_name, description } = req.body;
  
    try {
      if (!Machine_name || !description) {
        return res.status(400).json({ error: 'Machine_name and description are required' });
      }
  
      // Create the repair
      const repair = await Repair.create({ Machine_name, description });
  
      // Retrieve admin user
      const adminUser = await User.findOne({ username: 'admin' });
  
      if (adminUser && adminUser.fcmToken) {
        // Define the notification payload
        const payload = {
          notification: {
            title: 'New Repair Created',
            body: `Repair for machine ${Machine_name} created.`,
          },
          data: {
            Machine_name,
            description,
          },
        };
  
        // Send notification to the admin's FCM token
        await admin.messaging().sendToDevice(adminUser.fcmToken, payload);
      } else {
        console.log('Admin user not found or FCM token is missing');
      }
  
      res.status(200).json(repair);
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  };*/
  const createrepair = async (req, res) => {
    const { Machine_name, description } = req.body;
  
    try {
      if (!Machine_name || !description) {
        return res.status(400).json({ error: 'Machine_name and description are required' });
      }
  
      // Create the repair
      const repair = await Repair.create({ Machine_name, description });
  
      // Get all users with FCM tokens (you might need to adjust this query based on your user schema)
      //const usersWithFCM = await User.find({ fcmToken: { $exists: true } });
  
      //if (usersWithFCM.length > 0) {
        // Define the notification payload
        const payload = {
          notification: {
            title: 'New Repair Created',
            body: `Repair for machine ${Machine_name} created.`,
          },
          data: {
            Machine_name,
            description,
          },
        };
  
        // Array of all FCM tokens
        /*const fcmTokens = usersWithFCM.map(user => user.fcmToken);
  
        // Send notification to all users with FCM tokens
        await admin.messaging().sendToDevice(fcmTokens, payload);
      } else {
        console.log('No users found with FCM tokens');
      }
      */
      res.status(200).json(repair);
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  };
  


//get all repairs
const getrepair=async(req,res)=>{
    const repairs=await Repair.find({}).sort({createdAt:-1})//sort by date , newest at top , if i do find{Machine_name:333} it will display all repairs with same Machine_name
    res.status(200).json({repairs})
}
//get one repair
const getsinglerepair=async(req,res)=>{
    const { id }=req.params// TO DO : replace id with Machine_name later
    if(!mongoose.Types.ObjectId.isValid(id)){
        return res.status(404).json({error:'no such repair'})
    }
    const getsinglerepair=await repair.findById(id)

    if(!Repair){
       return res.status(200).json({msg:'repairs does not exist'})
    }

    res.status(200).json(getsinglerepair)
    
}
//delete a repair
const deleterepair=async(req,res)=>{
    const{id}=req.params
    if(!mongoose.Types.ObjectId.isValid(id)){
        return res.status(404).json({error:'no such repair'})
    }
    const deleterepair=await Repair.findByIdAndDelete({_id: id})
    if(!Repair){
        return res.status(400).json({msg:'repair does not exist'})
     }
 
     res.status(200).json(deleterepair)
}

// update a repair
/*const updaterepair=async(req,res)=>{
    const{id}=req.params
    
    if(!mongoose.Types.ObjectId.isValid(id)){
        return res.status(404).json({error:'no such repair'})
    }
    const updaterepair=await Repair.findByIdAndUpdate({_id: id},{
        ...req.body
    })
    if(!Repair){
        return res.status(400).json({msg:'repair does not exist'})
     }
 
     res.status(200).json(updaterepair)
}*/
const updaterepair = async (req, res) => {
    const { id } = req.params;

    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: 'No such repair' });
    }

    try {
        // Define which fields can be updated
        const allowedFields = ['Machine_name', 'description', 'createdAt'];

        // Pick only allowed fields from req.body
        const updateFields = {};
        for (let field of allowedFields) {
            if (req.body[field]) {
                updateFields[field] = req.body[field];
            }
        }

        const updaterepair = await Repair.findByIdAndUpdate(id, updateFields, {
            new: true, // Return the updated document
            runValidators: true, // Run model validators
        });

        if (!updaterepair) {
            return res.status(400).json({ msg: 'Repair does not exist' });
        }

        res.status(200).json(updaterepair);
    } catch (error) {
        console.error('Error updating repair:', error);
        res.status(500).json({ error: 'Server error' });
    }
};


module.exports={
    createrepair,
    getrepair,
    getsinglerepair,
    deleterepair,
    updaterepair
}