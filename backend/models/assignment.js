const mongoose = require('mongoose')
const Schema = mongoose.Schema
/*
const assignmentSchema = new mongoose.Schema({
  machine: { type: mongoose.Schema.Types.ObjectId, ref: 'Machine', required: true },
  tool: { type: mongoose.Schema.Types.ObjectId, ref: 'Tool', required: true },
  assignedAt: { type: Date, default: Date.now }
});

const Assignment = mongoose.model('Assignment', assignmentSchema);

module.exports = Assignment;*/

const Assignmentschema = new Schema({
    machine: {
        type: Schema.Types.ObjectId,
        ref: 'machine'
    },
    tool: {
        type: Schema.Types.ObjectId,
        ref: 'tool'
    },
  
}, { timestamps: {currentTime: () => new Date(Date.now() + (2 * 60 * 60 * 1000))} });//adjust to tunisia time utc+1

module.exports = mongoose.model('Assignment',Assignmentschema)


