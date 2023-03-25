const express = require('express');
const router = express.Router();
const TreatmentController = require('../controller/treatment_controller');

module.exports = function (){
    router.get('/', TreatmentController.getAllTreatments);
    router.post('/create', TreatmentController.createTreatment);
    router.put('/update/:id', TreatmentController.updateTreatment);
    router.delete('/delete/:id', TreatmentController.deleteTreatment);
    return router;
}
