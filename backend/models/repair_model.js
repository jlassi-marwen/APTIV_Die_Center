const mongoose = require('mongoose')
const Schema = mongoose.Schema

const repairSchema = new Schema({
    Machine_name:{
        type:String,
        required:true
    },
    description:{
        type:String,
        required:true
    },
   

}, {timestamps:{currentTime: () => new Date(Date.now() + (2 * 60 * 60 * 1000))}})//attribut automatiques pour toutes les elements

module.exports = mongoose.model('repair',repairSchema)

