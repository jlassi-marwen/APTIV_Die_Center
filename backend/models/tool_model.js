const mongoose = require('mongoose')
const Schema = mongoose.Schema

const toolSchema = new Schema({
    NS:{
        type:String,
        required:true
    },
    ref:{
        type:String,
        required:true
    },
   
    /*assignedat: {
        type: Date,
        default:()=>Date.now
    }*/
}, {timestamps:{currentTime: () => new Date(Date.now() + (2 * 60 * 60 * 1000))}})//attribut automatiques pour toutes les elements

module.exports = mongoose.model('tool',toolSchema)

