import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/logic/blocs/auth/auth_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';
import '../auth/verify_email_screen.dart';
// import 'package:my_camp/logic/blocs/campsite/campsite_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:my_camp/constant/states.dart' as StateList;

class CreateCampsitePage extends StatefulWidget {
  // final String userId;
  const CreateCampsitePage({Key? key}) : super(key: key);

  @override
  _CreateCampsitePageState createState() => _CreateCampsitePageState();
}

class _CreateCampsitePageState extends State<CreateCampsitePage> {
  String? _selectedState;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _imagePath = '';
  File? _image;
  final picker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  List<FAQEntry> _faqEntries = [];

  Future<void> _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  // Future<void> _pickImage() async {
  //   final picker = ImagePicker();
  //   final pickedFile = await picker.getImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     final file = File(pickedFile.path);
  //     final fileName = path.basename(file.path);
  //     final destination = 'images/$fileName';

  //     try {
  //       await firebase_storage.FirebaseStorage.instance
  //           .ref(destination)
  //           .putFile(file);
  //       final downloadURL = await firebase_storage.FirebaseStorage.instance
  //           .ref(destination)
  //           .getDownloadURL();

  //       setState(() {
  //         _image = file;
  //         _imagePath = downloadURL;
  //       });
  //     } catch (e) {
  //       print('Error uploading image: $e');
  //     }
  //   }
  // }

  void _addFAQEntry() {
    setState(() {
      _faqEntries.add(FAQEntry());
    });
  }

  Future<void> _createCampsite() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // After the operation is completed:

    // Store the campsite information in Firestore
    try {
      // Access the current user's document in the "users" collection
      String userId = context
          .read<SessionCubit>()
          .state
          .id!; // Replace with the actual user ID
      CollectionReference campsitesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('campsites');

      // Create a new document with an auto-generated ID
      DocumentReference newCampsiteDoc = campsitesCollection.doc();

      // Prepare the data to be saved
      String imagePath = '';

      if (_image != null) {
        // Upload the image to Firebase Storage
        final fileName = newCampsiteDoc.id + path.basename(_image!.path);
        final destination = 'images/campsites/$fileName';

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref(destination);
        firebase_storage.UploadTask uploadTask = ref.putFile(_image!);
        await uploadTask.whenComplete(() {});
        imagePath = await ref.getDownloadURL();
      }

      Map<String, dynamic> campsiteData = {
        'imagePath': imagePath,
        'name': _nameController.text,
        'description': _descriptionController.text,
        'address': _addressController.text,
        // 'state': _stateController.text,
        'state': _selectedState,
        'faq': _faqEntries
            .map((faq) => {'question': faq.question, 'answer': faq.answer})
            .toList(),
        'id': newCampsiteDoc.id,
        'verified': true,
        'createdAt': DateTime.now(),
        // 'updated_at': DateTime.now(),
      };

      // Save the data to Firestore
      await newCampsiteDoc.set(campsiteData);

      // Show a success message to the user
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Campsite created successfully!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  context.goNamed('manage-campsite');
                },
              ),
            ],
          );
        },
      );
      setState(() {
        _isLoading = false;
      });
    } catch (error) {
      // Show an error message to the user
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('An error occurred while creating the campsite.'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _stateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Campsite'),
        backgroundColor: Colors.indigo,
      ),
      body: Stack(children: [
        SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Campsite Image',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.indigo, width: 2),
                        ),
                        child: _image != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  _image!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : Icon(
                                Icons.camera_alt,
                                size: 50,
                                color: Colors.indigo,
                              ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Campsite Name',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _nameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the campsite name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter the campsite name',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the campsite description';
                      }
                      return null;
                    },
                    maxLines: 5,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter the campsite description',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Address',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _addressController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the campsite address';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter the campsite address',
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    'State',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedState,
                    onChanged: (value) {
                      setState(() {
                        _selectedState = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select the campsite state';
                      }
                      return null;
                    },
                    items: StateList.states.map((state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(state),
                      );
                    }).toList(),
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Select the campsite state',
                    ),
                  ),
                  // TextFormField(
                  //   controller: _stateController,
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter the campsite state';
                  //     }
                  //     return null;
                  //   },
                  //   decoration: InputDecoration(
                  //     border: OutlineInputBorder(),
                  //     hintText: 'Enter the campsite state',
                  //   ),
                  // ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'FAQ',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Colors.indigo,
                          size: 30,
                        ),
                        onPressed: _addFAQEntry,
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: List.generate(
                      _faqEntries.length,
                      (index) => _buildFAQEntry(index),
                    ),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: _createCampsite,
                      child: Text('Create'),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.indigo,
                        textStyle: TextStyle(fontSize: 20),
                        padding:
                            EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        if (_isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ]),
    );
  }

  Widget _buildFAQEntry(int index) {
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();

    // Check if FAQEntry object already has values
    if (_faqEntries[index].question.isNotEmpty) {
      questionController.text = _faqEntries[index].question;
    }
    if (_faqEntries[index].answer.isNotEmpty) {
      answerController.text = _faqEntries[index].answer;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Text(
          'Question ${index + 1}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: questionController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the question';
            }
            return null;
          },
          onChanged: (value) => _faqEntries[index].question = value,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter the question',
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Answer ${index + 1}',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5),
        TextFormField(
          controller: answerController,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter the answer';
            }
            return null;
          },
          onChanged: (value) => _faqEntries[index].answer = value,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter the answer',
          ),
        ),
      ],
    );
  }
}

class FAQEntry {
  String question = '';
  String answer = '';
}
