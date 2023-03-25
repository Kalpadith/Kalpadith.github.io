// imports
const mongoose = require("mongoose");
 //defining the user scehma
const User_Schema = new mongoose.Schema({

    //data fields in the collection and defining validations on backend
    Name: { type: String, required: true },
    email: { type: String, required: true, unique: true },
    password: { type: String, required: true },
    phone: { type: String, required: true },
    User_role: { type: String, required: true },

});


const User = mongoose.model('user', User_Schema);
//exporting the user module 
module.exports = User;