const express = require('express');
const router = express.Router();
const UserController = require('../controller/user_controller');

module.exports = function (){
    router.get('/', UserController.getAllUser);
    router.get('/:id', UserController.getUserById);
    router.post('/create', UserController.createUser);
    router.put('/update', UserController.updateUser);
    router.post('/validate', UserController.validateUser);
    router.post('/delete',UserController.deleteUser);
    return router;
}
