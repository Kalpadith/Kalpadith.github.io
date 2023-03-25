const User = require("../model/user_model");
const bcrypt = require("bcryptjs");
const saltRounds = 5;

//Register a User | guest
const createUser = async (req, res) => {
    if (req.body) {
        let email = req.body.email;
        await User.findOne({ email: email }, async (err, result) => {
            if (err) {
                console.log(err);
            } else {
                if (!result) {

                    bcrypt.genSalt(saltRounds, function (err, salt) {
                        bcrypt.hash(req.body.password, salt, async function (err, hash) {
                            req.body.password = hash;

                            const user = new User(req.body);
                            await user.save()
                                .then(data => {
                                    console.log(data);
                                    res.status(200).send(data);
                                })
                                .catch(err => {
                                    console.log(err);
                                    res.send(err);
                                });
                        });
                    });
                } else {
                    console.log("User Already Exist");
                    res.send({ message: "User Already Exist" });
                }
            }
        });
    }
}

//login Validate
const validateUser = async (req, res) => {
    console.log(req);
    await User.findOne({ email: req.body.email }, (err, users) => {
        if (err) {
            console.log(err);
            res.status(500).send(err);
        } else {
            if (users == null) return res.status(500).send("User Not Found");
            bcrypt.compare(req.body.password, users.password, function (err, result) {
                // result == true
                console.log(result);
                if (result) {
                    console.log(users);
                    res.send(users);
                } else {
                    console.log("Credentials Does Not Matched");
                    res.status(500).send("Credentials Does Not Matched");
                }
            });

        }
    });
}

//update User Details
const updateUser = async (req, res) => {
    if (req.body) {
        if (!req.body.id) return res.status(500).send("Id is missing");
        let id = req.body.id;
        if (req.body.password != null) {
            bcrypt.genSalt(saltRounds, function (err, salt) {
                bcrypt.hash(req.body.password, salt, async function (err, hash) {
                    req.body.password = hash;
                    updateDetails(id, req, (err, user) => {
                        if (err) return res.status(500).send(err);
                        console.log("user");
                        console.log(user);
                        res.status(200).send(user);
                    })

                });
            });
        } else {
            updateDetails(id, req, (err, user) => {
                if (err) return res.status(500).send(err);
                console.log("user");
                console.log(user);
                res.status(200).send(user);
            })
        }
        console.log(req.body);


    }
}

function updateDetails(id, req, callback) {
    User.findByIdAndUpdate(id, req.body)
        .then((result2) => {
            User.findOne({ _id: id }, (err, result) => {
                if (err) {
                    console.log(err);
                    return callback(err);
                } else {
                    if (result && result.password) result.password = '';
                    var user = result;
                    // delete user.password;
                    console.log(user);
                    return callback(null, user);
                }
            });

        })
        .catch(err => {
            console.log(err)
            return callback(err);

        })
}

//get All User
const getAllUser = async (req, res) => {
    await User.find()
        .then((data) => {
            console.log(data);
            res.status(200).send(data);
        })
        .catch(error => {
            console.log(error);
            res.status(500).send(error);
        });
}
//get User by ID
const getUserById = async (req, res) => {
    await User.find({_id: req.params.id},(err,result)=>{
        if(err){
            console.log(err);
        }else{
            res.send(result);
            console.log(result);
        }
    })
};





//delete User
const deleteUser = async (req, res) => {
    if (req.body.id) {
        await User.findByIdAndDelete(req.body.id, (err, result) => {
            if (err) return res.status(500).send(err);
            console.log(result);
            return res.status(200).send(result);
        });
    }
}

module.exports = {
    createUser,
    updateUser,
    deleteUser,
    getAllUser,
    getUserById,
    validateUser
}