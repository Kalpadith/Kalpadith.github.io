// imports
const mongoose = require("mongoose");

 //defining the treatment scehma
const Treatment_Schema = new mongoose.Schema({

    treatment_name: { type: String, required: true },
    img: { type: Object, required: false},
    treatment_description: { type: String, required: true}, 

});


const Treatment = mongoose.model('treatment', Treatment_Schema);
//exporting the treatment module 
module.exports = Treatment;