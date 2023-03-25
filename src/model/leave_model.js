//importing mongoose
const mongoose = require("mongoose");

//defining the leave scehma
const Leaves_Schema = new mongoose.Schema({

    name: { type: String, required: true },
    leave_type: { type: String, required: true },   
    leave_description: { type: String, required: true },
    date_time: { type: String, required: true },

});


const Leave = mongoose.model('leave', Leaves_Schema);
//exporting the treatment module 
module.exports = Leave;