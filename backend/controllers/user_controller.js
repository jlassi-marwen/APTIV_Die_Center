const User = require('../models/users_model')
const mongoose =require('mongoose')

// login a user
const loginuser = async (req, res) => {
    const { username, password } = req.body;
    const user = await User.findOne({ username, password });

    if (!user) {
        return res.status(400).send('Invalid username or password');
    }

    res.status(200).send('Login successful');}



//create new user
const createuser = async (req, res) => {
    const { username, password } = req.body;

    try {
        // Check if username is provided
        if (!username || !password) {
            return res.status(400).json({ error: 'username and password are required' });
        }

        // Check if username is unique
        const existingUser = await User.findOne({ username });
        if (existingUser) {
            return res.status(400).json({ error: 'username must be unique' });
        }

        // Create the User
        const user = await User.create({ username, password });
        res.status(200).json(user);
    } catch (error) {
        res.status(400).json({ error: error.message });
    }
};

//get users
const getuser=async(req,res)=>{
    const users=await User.find({}).sort({createdAt:-1})//sort by date , newest at top 
    res.status(200).json({users})
}


//update user
/*
const updateuser=async(req,res)=>{
    const{id}=req.params
    
    if(!mongoose.Types.ObjectId.isValid(id)){
        return res.status(404).json({error:'no such user'})
    }
    const updateuser=await User.findByIdAndUpdate({_id: id},{
        ...req.body
    })
    if(!User){
        return res.status(400).json({msg:'user does not exist'})
     }
 
     res.status(200).json(updateuser)
}*/
const updateuser = async (req, res) => {
    const { id } = req.params;
    
    if (!mongoose.Types.ObjectId.isValid(id)) {
        return res.status(404).json({ error: 'No such user' });
    }
    
    const updateuser = await User.findByIdAndUpdate(id, req.body, { new: true, runValidators: true });
    
    if (!updateuser) {
        return res.status(400).json({ msg: 'User does not exist' });
    }
    
    res.status(200).json(updateuser);
};


// delete user
const deleteuser=async(req,res)=>{
    const{id}=req.params
    if(!mongoose.Types.ObjectId.isValid(id)){
        return res.status(404).json({error:'no such user'})
    }
    const deleteuser=await User.findByIdAndDelete({_id: id})
    if(!User){
        return res.status(400).json({msg:'user does not exist'})
     }
 
     res.status(200).json(deleteuser)
}


module.exports = { loginuser,updateuser,deleteuser, getuser,createuser}