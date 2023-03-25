const mongoose = require("mongoose");

const URI = "mongodb+srv://ikalpadith:Z4UxEy8WFsBtdSae@ctse1.imd3rhs.mongodb.net/CTSEproject1?retryWrites=true&w=majority";

const connectDB = async () => {
    await mongoose.connect(URI, { useNewUrlParser: true, useUnifiedTopology: true, useCreateIndex: true, useFindAndModify: false });
    console.log("Database Connected and deployed successfully");
}

module.exports = connectDB;