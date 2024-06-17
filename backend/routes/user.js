const express = require('express')
const router = express.Router()

// controller functions
const User =require('../models/users_model')
const {loginuser, updateuser,deleteuser,getuser,createuser } = require('../controllers/user_controller')

router.post('/update-fcm-token', async (req, res) => {
    const { username, fcmToken } = req.body;
  
    try {
      const user = await User.findOneAndUpdate({ username }, { fcmToken }, { new: true });
  
      if (!user) {
        return res.status(404).json({ error: 'User not found' });
      }
  
      res.status(200).json({ message: 'FCM token updated successfully', user });
    } catch (error) {
      res.status(400).json({ error: error.message });
    }
  });
// login route
//router.post('/login', loginUser)
router.post('/', createuser)
router.post('/login',loginuser)
router.get('/',getuser);
router.put('/:id',updateuser);
router.delete('/:id',deleteuser);
module.exports = router