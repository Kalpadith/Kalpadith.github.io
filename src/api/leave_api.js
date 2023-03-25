const express = require('express');
const router = express.Router();
const LeaveController = require('../controller/leave_controller');

module.exports = function (){
    router.get('/', LeaveController.getAllLeaves);
    router.post('/create', LeaveController.createLeave);
    router.put('/update/:id', LeaveController.updateLeave);
    router.delete('/delete/:id', LeaveController.deleteLeave);
    return router;
}
