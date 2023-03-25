//imports
const mongoose = require("mongoose");

//defining the appointment schema
const Appointment_Schema = new mongoose.Schema({
    name: { type: String, required: true },
    //userID:{ type: String, required: false },
    datetime: { type: String, required: true },
    appointment_description: { type: String, required: true },
    type: { type: String, required: true },
    
});

const Appointment = mongoose.model('appointment', Appointment_Schema);
//exporting the appointment module
module.exports = Appointment;