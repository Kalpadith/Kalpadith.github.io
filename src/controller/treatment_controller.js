const Treatment = require("../model/treatment_model");

//Add Treatment
const createTreatment = async (req, res) => {
    if (req.body) {

        const data = {
            treatment_name: req.body.name,
            img: req.body.image,
            treatment_description: req.body.description,
        }
        const treatment = new Treatment(data);

        await treatment.save()
            .then(data => res.status(200).send({ data: data }))
            .catch(err => res.send(err));

    }
}

//update Treatment
const updateTreatment = async (req, res) => {
    if (req.body) {
        if (!req.params.id) return res.status(500).send("Id is missing");
        let id = req.params.id;

        updateDetails(id, req, (err, treatment) => {
            if (err) return res.status(500).send(err);
            res.status(200).send(treatment);
        })
    }
}

function updateDetails(id, req, callback) {
    Treatment.findByIdAndUpdate(id, req.body)
        .then((res) => {
            Treatment.findOne({ _id: id }, (err, result) => {
                if (err) {
                    console.log(err);
                    return callback(err);
                } else {
                    var treatment = result;
                    console.log(treatment);
                    return callback(null, treatment);
                }
            });
        })
        .catch(err => {
            console.log(err) 
            return callback(err);
        })
}

//get All Treatments
const getAllTreatments = async (req, res) => {
    await Treatment.find()
        .then((data) => {
            res.status(200).send(data);
        })
        .catch(error => {
            res.send(error);
        });
}

//delete Treatment
const deleteTreatment = async (req, res) => {
    if (req.params.id) {
        await Treatment.findByIdAndDelete(req.params.id, (err, result) => {
            if (err) return res.status(500).send(err);
            console.log(result);
            return res.status(200).send(result);
        });
    }
}


module.exports = {
    createTreatment: createTreatment,
    updateTreatment: updateTreatment,
    deleteTreatment: deleteTreatment,
    getAllTreatments: getAllTreatments,
}