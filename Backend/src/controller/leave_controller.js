const Leave = require("../model/leave_model");

//Add New Leave
const createLeave = async (req, res) => {
    if (req.body) {

        const data = {
            name: req.body.name,
            leave_type: req.body.type,
            leave_description: req.body.description,
            date_time: req.body.date_time,
        }
        const leave = new Leave(data);

        await leave.save()
            .then(data => res.status(200).send({ data: data }))
            .catch(err => res.send(err));

    }
}

//view All Leave
const getAllLeaves = async (req, res) => {
    await Leave.find()
        .then((data) => {
            res.status(200).send(data);
        })
        .catch(error => {
            res.send(error);
        });
}

function updateDetails(id, req, callback) {
    Leave.findByIdAndUpdate(id, req.body)
        .then((res) => {
            Leave.findOne({ _id: id }, (err, result) => {
                if (err) {
                    console.log(err);
                    return callback(err);
                } else {
                    var leave = result;
                    console.log(leave);
                    return callback(null, leave);
                }
            });
        })
        .catch(err => {
            console.log(err) 
            return callback(err);
        })
}



//delete Leave
const deleteLeave = async (req, res) => {
    if (req.params.id) {
        await Leave.findByIdAndDelete(req.params.id, (err, result) => {
            if (err) return res.status(500).send(err);
            console.log(result);
            return res.status(200).send(result);
        });
    }
}

//update Leave Details
const updateLeave = async (req, res) => {
    if (req.body) {
        if (!req.params.id) return res.status(500).send("Id is missing");
        let id = req.params.id;

        updateDetails(id, req, (err, leave) => {
            if (err) return res.status(500).send(err);
            res.status(200).send(leave);
        })
    }
}

module.exports = {
    createLeave: createLeave,
    updateLeave: updateLeave,
    deleteLeave: deleteLeave,
    getAllLeaves: getAllLeaves,
}