const express = require('express');
const router = express.Router();
const HairStyleController = require('../controller/hairStyle_controller');

module.exports = function (){
    router.get('/', HairStyleController.getAllHairStyles);
    router.post('/create', HairStyleController.createHairStyle);
    router.put('/update/:id', HairStyleController.updateHairStyle);
    router.delete('/delete/:id', HairStyleController.deleteHairStyle);
    return router;
}
