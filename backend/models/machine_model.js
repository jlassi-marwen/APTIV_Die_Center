const mongoose = require ('mongoose')
const Schema = mongoose.Schema
//const tool = require('./tool_model');
const machineSchema = new Schema({
    name: {
        type: String,
        required: true
      },
      
      //tools: [String ],
      tools:{
        type:[String],
        unique: true,
      }
      /*tools: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'tool',
        unique: true // Reference the Tool model
      }],*/
        
},)// { timestamps: {currentTime: () => new Date(Date.now() + (2 * 60 * 60 * 1000))} });
module.exports = mongoose.model ('machine',machineSchema)

