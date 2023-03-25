//Importing required models
const Appointment = require("../model/appointment_model");

//Add an Appointment
const createAppointment = async (req, res) => {
    if (req.body) {

        const data = {
            name: req.body.name,
            datetime: req.body.datetime,
            userID:req.body.userID,
            appointment_description: req.body.description,
            type: req.body.type,
        }
        const appointment = new Appointment(data);

        await appointment.save()
            .then(data => res.status(200).send({ data: data }))
            .catch(err => res.send(err));

    }
}

//view All Appointment
const getAllAppointments = async (req, res) => {
    await Appointment.find()
        .then((data) => {
            res.status(200).send(data);
        })
        .catch(error => {
            res.send(error);
        });
}

//update Appointment Details
const updateAppointment = async (req, res) => {
    if (req.body) {
        if (!req.params.id) return res.status(500).send("Id is missing");
        let id = req.params.id;

        updateDetails(id, req, (err, appointment) => {
            if (err) return res.status(500).send(err);
            res.status(200).send(appointment);
        })
    }
}

function updateDetails(id, req, callback) {
    Appointment.findByIdAndUpdate(id, req.body)
        .then((res) => {
            Appointment.findOne({ _id: id }, (err, result) => {
                if (err) {
                    console.log(err);
                    return callback(err);
                } else {
                    var appointment = result;
                    console.log(appointment);
                    return callback(null, appointment);
                }
            });
        })
        .catch(err => {
            console.log(err) 
            return callback(err);
        })
}

//delete an Appointment
const deleteAppointment = async (req, res) => {
    if (req.params.id) {
        await Appointment.findByIdAndDelete(req.params.id, (err, result) => {
            if (err) return res.status(500).send(err);
            console.log(result);
            return res.status(200).send(result);
        });
    }
}

const getappointmentById = async (req, res) => {
    try {
        const appointment = await collection.findOne({ _id: req.params.userID });
        if (appointment) {
            res.send(appointment);
        } else {
            res.status(404).send("Appointment not found");
        }
    } catch (err) {
        console.error(err);
        res.status(500).send("Internal Server error");
    } 
};

module.exports = {
    getappointmentById:getappointmentById,
    createAppointment: createAppointment,
    updateAppointment: updateAppointment,
    deleteAppointment: deleteAppointment,
    getAllAppointments: getAllAppointments,
}