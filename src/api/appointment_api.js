const express = require('express');
const router = express.Router();
const AppointmentController = require('../controller/appointment_controller');

module.exports = function (){
    router.get('/userID', AppointmentController.getappointmentById);
    router.get('/', AppointmentController.getAllAppointments);
    router.post('/create', AppointmentController.createAppointment);
    router.put('/update/:id', AppointmentController.updateAppointment);
    router.delete('/delete/:id', AppointmentController.deleteAppointment);
    return router;
}
