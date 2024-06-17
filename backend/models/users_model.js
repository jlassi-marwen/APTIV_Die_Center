
const mongoose = require('mongoose')
const Schema = mongoose.Schema

const userSchema = new Schema({
    username:{
        type:String,
        required:true
    },
    password:{
        type:String,
        required:true
    },
    /*fcmToken: {
        type: String
      },*/
    
}, {timestamps:{currentTime: () => new Date(Date.now() + (2 * 60 * 60 * 1000))}})//attribut automatiques pour toutes les elements

module.exports = mongoose.model('user',userSchema)

