import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:google_fonts/google_fonts.dart';
import '../screens/treatmentList.dart';
import 'package:flutter/material.dart';
import '../screens/home.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class AddTreatment extends StatefulWidget {
  static const String routeName = '/addTreatment';

  const AddTreatment({Key? key}) : super(key: key);
  @override
  State<AddTreatment> createState() => _AddTreatmentState();
}

class _AddTreatmentState extends State<AddTreatment> {
  final _formKey = GlobalKey<FormState>();
  static const primaryColor = Color.fromARGB(255, 21, 16, 38);

  String? _name;
  String? _description;
  String? _imageURL;
  var image;
  double? _uploadingPercentage;
  String? _Percentage;
  bool isUploaded = false;

  File? _pickedImage;
  ImagePicker _picker = ImagePicker();
  final cloudinary = CloudinaryPublic('dn7xbicc8', 'ewvf8uyn', cache: false);

  postData() async {
    if (image != null) {
      _uploadImage().then((value) {
        _imageURL = value;
        _CreatTreatment();
      });
    } else {
      Fluttertoast.showToast(
      msg: "Please select Image!",
      toastLength: Toast.LENGTH_LONG,
      fontSize: 16,
      backgroundColor: Color.fromARGB(255, 193, 52, 52)
    );
      
    }
  }

  _CreatTreatment() async {
    try {
      var response = await http.post(
          Uri.parse(
              'http://localhost:5000/treatment/create'),
          body: {
            'treatment_name': _name,
            'treatment_description': _description,
            'img': _imageURL
          });
      print(response.body);
      if (response.body != null) {
        _name = "";
        _description = "";
        isUploaded = false;
        Navigator.of(context).push(MaterialPageRoute(
            builder: (BuildContext context) => const TreatmentList()));
        AwesomeDialog(
          context: context,
          dialogType: DialogType.SUCCES,
          animType: AnimType.SCALE,
          title: 'Scucces',
          desc: 'Scuccessfully Added',
          autoHide: const Duration(seconds: 2),
        ).show();
      }
    } catch (e) {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.ERROR,
        animType: AnimType.RIGHSLIDE,
        headerAnimationLoop: true,
        title: 'Error',
        desc: 'Cannot Add $e',
        btnOkOnPress: () {},
        btnOkIcon: Icons.cancel,
        btnOkColor: Colors.red,
      ).show();
      print(e);
    }
  }

  void _pickImageCamera() async {
    image = await _picker.pickImage(source: ImageSource.camera);
    final pickedImageFile = File(image!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _pickImageGallery() async {
    image = await _picker.pickImage(source: ImageSource.gallery);
    final pickedImageFile = File(image!.path);
    setState(() {
      _pickedImage = pickedImageFile;
    });
    Navigator.pop(context);
  }

  void _remove() {
    setState(() {
      _pickedImage = null;
      Navigator.pop(context);
    });
  }

  _uploadImage() async {
    isUploaded = true;
    try {
      final response = await cloudinary.uploadFile(
        CloudinaryFile.fromFile(
          image.path,
          folder: 'hello-folder',
          context: {
            'alt': 'Hello',
            'caption': 'An example image',
          },
        ),
        onProgress: (count, total) {
          setState(() {
            _uploadingPercentage = (count / total);
            _Percentage = ((count / total) * 100).toString();
          });
        },
      );
      print(response.secureUrl);
      return response.secureUrl;
    } on CloudinaryException catch (e) {
      print(e.message);
      print(e.request);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          centerTitle: true,
          title: Text(
            "Add New Treatment",
            style: GoogleFonts.dancingScript(
              textStyle: const TextStyle(
                  color: Color.fromARGB(255, 21, 17, 17), fontSize: 30)),
          ),
          backgroundColor: const Color.fromARGB(255, 211, 74, 74),
        ),
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: Image.asset(
                "../assets/images/addTreatment.jpg",
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomLeft,
              ),
            ),
            Center(
              child: Column(
                children: [
                  isUploaded
                      ? Expanded(
                          child: Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: const BoxDecoration(
                                  color: Color.fromRGBO(34, 33, 33, 0.856)),
                              child: const SpinKitFoldingCube(
                                color: Color.fromARGB(255, 211, 74, 74),
                              ),
                            ),
                          ),
                        )
                      : Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    margin: const EdgeInsets.symmetric(
                                        vertical: 30, horizontal: 30),
                                    child: CircleAvatar(
                                      radius: 76,
                                      backgroundColor:
                                          const Color.fromARGB(255, 97, 97, 97),
                                      child: CircleAvatar(
                                        radius: 72,
                                        backgroundColor: const Color.fromARGB(
                                            255, 219, 219, 219),
                                        backgroundImage: _pickedImage == null
                                            ? null
                                            : FileImage(_pickedImage!),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      top: 120,
                                      left: 125,
                                      child: RawMaterialButton(
                                        elevation: 10,
                                        fillColor: const Color.fromARGB(
                                            255, 61, 61, 61),
                                        child: const Icon(
                                          Icons.add_a_photo,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        ),
                                        padding: EdgeInsets.all(15.0),
                                        shape: CircleBorder(),
                                        onPressed: () {
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Choose option',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                          255, 0, 0, 0),
                                                    ),
                                                  ),
                                                  content:
                                                      SingleChildScrollView(
                                                    child: ListBody(
                                                      children: [
                                                        InkWell(
                                                          onTap:
                                                              _pickImageCamera,
                                                          splashColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  92,
                                                                  92,
                                                                  92),
                                                          child: Row(
                                                            children: const [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: Icon(
                                                                  Icons.camera,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          58,
                                                                          58,
                                                                          58),
                                                                ),
                                                              ),
                                                              Text(
                                                                'Camera',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          58,
                                                                          58,
                                                                          58),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap:
                                                              _pickImageGallery,
                                                          splashColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  58,
                                                                  58,
                                                                  58),
                                                          child: Row(
                                                            children: const [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: Icon(
                                                                  Icons.image,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          58,
                                                                          58,
                                                                          58),
                                                                ),
                                                              ),
                                                              Text(
                                                                'Gallery',
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 18,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          58,
                                                                          58,
                                                                          58),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: _remove,
                                                          splashColor: Colors
                                                              .purpleAccent,
                                                          child: Row(
                                                            children: const [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(
                                                                            8.0),
                                                                child: Icon(
                                                                    Icons
                                                                        .remove_circle,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            139,
                                                                            18,
                                                                            10)),
                                                              ),
                                                              Text(
                                                                'Remove',
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        18,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            139,
                                                                            18,
                                                                            10)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                      ))
                                ],
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: "Treatment",
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter the name";
                                      }
                                      return null;
                                    },
                                    onChanged: (text) {
                                      setState(() {
                                        _name = text;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 10.0),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    maxLines: null,
                                    keyboardType: TextInputType.multiline,
                                    style: const TextStyle(color: Colors.white),
                                    decoration: InputDecoration(
                                      labelText: "Description",
                                      labelStyle:
                                          const TextStyle(color: Colors.white),
                                      fillColor: Colors.white,
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: const BorderSide(
                                            color: Colors.white, width: 2.0),
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        borderSide: const BorderSide(
                                          color: Colors.white,
                                          width: 2.0,
                                        ),
                                      ),
                                    ),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return "Please enter the description";
                                      }
                                      return null;
                                    },
                                    onChanged: (text) {
                                      setState(() {
                                        _description = text;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 20.0),
                                child: ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      postData();
                                    }
                                  },
                                  child: const Text("Add"),
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Color.fromARGB(255, 249, 237, 237), primary: const Color.fromARGB(
                                          255, 211, 74, 74),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30, vertical: 10),
                                      textStyle: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold)),
                                ),
                              ),
                            ],
                          )),
                ],
              ),
            )
          ],
        ));
  }
}
