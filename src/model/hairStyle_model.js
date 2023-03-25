// imports
const mongoose = require("mongoose");

//defining the hair styles schema
const HairStyle_Schema = new mongoose.Schema({
    name: { type: String, required: true },
    description: { type: String, required: true},
    image: { type: Object, required: false},
});

const HairStyle = mongoose.model('hairstyle', HairStyle_Schema);
//exporting the hairstyle module
module.exports = HairStyle;