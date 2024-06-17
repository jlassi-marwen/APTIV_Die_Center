const mongoose = require('mongoose')
const Schema = mongoose.Schema
const timeUsageSchema = new Schema({
    machine: {
        type: Schema.Types.ObjectId,
        ref: 'Machine'
    },
    tool: {
        type: Schema.Types.ObjectId,
        ref: 'Tool'
    },
    startTime: {
        type: Date,
        required: true
    },
    endTime: {
        type: Date,
        required: true
    }
}, { timestamps: true });

module.exports = mongoose.model('timeusage',timeUsageSchema)


