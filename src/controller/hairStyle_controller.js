
const HairStyle = require("../model/hairStyle_model");

//Add Hair Style
const createHairStyle = async (req, res) => {
    if (req.body) {

        const data = {
            name: req.body.name,
            description: req.body.description,
            image: req.body.image,
        }
        const hairStyle = new HairStyle(data);

        await hairStyle.save()
            .then(data => res.status(200).send({ data: data }))
            .catch(err => res.send(err));

    }
}

//view All Hair style
const getAllHairStyles = async (req, res) => {
    await HairStyle.find()
        .then((data) => {
            res.status(200).send(data);
        })
        .catch(error => {
            res.send(error);
        });
}

//update Hair Style Detail
const updateHairStyle = async (req, res) => {
    if (req.body) {
        if (!req.params.id) return res.status(500).send("Id is missing");
        let id = req.params.id;

        updateDetails(id, req, (err, hairStyle) => {
            if (err) return res.status(500).send(err);
            res.status(200).send(hairStyle);
        })
    }
}

function updateDetails(id, req, callback) {
    HairStyle.findByIdAndUpdate(id, req.body)
        .then((res) => {
            HairStyle.findOne({ _id: id }, (err, result) => {
                if (err) {
                    console.log(err);
                    return callback(err);
                } else {
                    var hairStyle = result;
                    console.log(hairStyle);
                    return callback(null, hairStyle);
                }
            });
        })
        .catch(err => {
            console.log(err) 
            return callback(err);
        })
}



//delete hair styles
const deleteHairStyle = async (req, res) => {
    if (req.params.id) {
        await HairStyle.findByIdAndDelete(req.params.id, (err, result) => {
            if (err) return res.status(500).send(err);
            console.log(result);
            return res.status(200).send(result);
        });
    }
}


module.exports = {
    createHairStyle: createHairStyle,
    updateHairStyle: updateHairStyle,
    deleteHairStyle: deleteHairStyle,
    getAllHairStyles: getAllHairStyles,
}