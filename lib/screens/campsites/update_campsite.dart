import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/logic/blocs/campsite/campsite_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:path/path.dart' as path;
import 'package:image_picker/image_picker.dart';
import 'package:my_camp/constant/states.dart' as StateList;
import 'package:my_camp/data/models/faq.dart';

class UpdateCampsitePage extends StatefulWidget {
  final String campsiteId;
  const UpdateCampsitePage({Key? key, required this.campsiteId})
      : super(key: key);

  @override
  _UpdateCampsitePageState createState() => _UpdateCampsitePageState();
}

class _UpdateCampsitePageState extends State<UpdateCampsitePage> {
  bool _isInitialized = false;
  late Campsite _campsite;
  String? _selectedState;
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  File? _image;
  final picker = ImagePicker();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _stateController = TextEditingController();
  List? _faqEntries = [];

  Future<void> _pickImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  void _addFAQEntry() {
    setState(() {
      _faqEntries!.add(Faq(question: null, answer: null).toMap());
    });
    print(_faqEntries);
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

      // Prepare the data to be saved
      String imagePath = '';

      if (_image != null) {
        // Upload the image to Firebase Storage
        final fileName = _campsite.id + path.basename(_image!.path);
        final destination = 'images/campsites/$fileName';

        firebase_storage.Reference ref =
            firebase_storage.FirebaseStorage.instance.ref(destination);
        firebase_storage.UploadTask uploadTask = ref.putFile(_image!);
        await uploadTask.whenComplete(() {});
        imagePath = await ref.getDownloadURL();
      } else {
        imagePath = _campsite.imagePath;
      }
      Map<String, dynamic> campsiteData = {
        'imagePath': imagePath,
        'name': _nameController.text,
        'description': _descriptionController.text,
        'address': _addressController.text,
        'state': _selectedState ?? _campsite.state,
        'faq': _faqEntries!
            .map(
                (faq) => {"question": faq["question"], "answer": faq["answer"]})
            .toList(),
        'id': _campsite.id,
        'verified': true,
        'createdAt': DateTime.now(),
        // 'updated_at': DateTime.now(),
        'favourites': _campsite.favourites,
      };

      // Find campsite document
      DocumentReference campsite = campsitesCollection.doc(_campsite.id);

      // Save the data to Firestore
      await campsite.set(campsiteData);

      // Show a success message to the user
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Campsite updated successfully!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.replaceNamed('home');
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
            content: Text(error.toString()),
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

  Future<void> _deleteCampsite() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Show a success message to the user
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to delete this campsite?'),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                  // context.goNamed('home');
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  _confirmDeleteCampsite();
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
            content: Text(error.toString()),
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

  Future<void> _confirmDeleteCampsite() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String userId = context.read<SessionCubit>().state.id!;

      CollectionReference campsitesCollection = FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('campsites');

      DocumentReference campsite = campsitesCollection.doc(_campsite.id);

      await campsite.delete();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Success'),
            content: Text('Campsite deleted successfully!'),
            actions: [
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.goNamed('home');
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
            content: Text(error.toString()),
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
  initState() {
    context.read<CampsiteBloc>().add(SingleCampsiteRequested(
        campsiteId: widget.campsiteId,
        userId: context.read<SessionCubit>().state.id));
    super.initState();
    // _campsite = state.campsite;
    // _faqEntries = _campsite.faq;
    // _nameController.text = _campsite.name;
    // _descriptionController.text = _campsite.description;
    // _addressController.text = _campsite.address;
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
        title: Text('Update Campsite'),
        backgroundColor: Colors.indigo,
      ),
      body: BlocBuilder<CampsiteBloc, CampsiteState>(builder: (context, state) {
        if (state is CampsiteLoading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CampsiteLoaded) {
          if (_isInitialized == false) {
            _campsite = state.campsite;
            _faqEntries = _campsite.faq;
            _nameController.text = _campsite.name;
            _descriptionController.text = _campsite.description;
            _addressController.text = _campsite.address;
            // _stateController.value = _campsite.state.;
            _isInitialized = true;
          }
          return Stack(children: [
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                              border:
                                  Border.all(color: Colors.indigo, width: 2),
                            ),
                            child: (_image != null && _campsite.imagePath != '')
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.file(
                                      _image!,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Image.network(
                                    _campsite.imagePath,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        // Future.microtask(() {
                                        //   setState(() {
                                        //     _isLoading = false;
                                        //   });
                                        // });
                                        // print('x');
                                        // _isLoading = false;
                                        return child;
                                      } else {
                                        // Future.microtask(() {
                                        //   setState(() {
                                        //     _isLoading = true;
                                        //   });
                                        // });
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Icon(
                                        Icons.error,
                                        size: 50,
                                        color: Colors.indigo,
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Campsite Name',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: _campsite.state,
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
                          _faqEntries!.length,
                          (index) => _buildFAQEntry(index),
                        ),
                      ),
                      SizedBox(height: 20),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: ElevatedButton(
                                onPressed: _deleteCampsite,
                                child: Text('Delete'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.red,
                                  textStyle: TextStyle(fontSize: 20),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 20),
                            Flexible(
                              child: ElevatedButton(
                                onPressed: _createCampsite,
                                child: Text('Update'),
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.indigo,
                                  textStyle: TextStyle(fontSize: 20),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40, vertical: 15),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
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
          ]);
        } else {
          return const Center(child: Text("Something went wrong"));
        }
      }),
    );
  }

  Widget _buildFAQEntry(int index) {
    // return Container();
    TextEditingController questionController = TextEditingController();
    TextEditingController answerController = TextEditingController();

    // Check if FAQEntry object already has values
    if (_faqEntries![index]['question'] != null) {
      questionController.text = _faqEntries![index]['question'];
    }
    if (_faqEntries![index]['answer'] != null) {
      answerController.text = _faqEntries![index]['answer']!;
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
          onChanged: (value) => _faqEntries![index]["question"] = value,
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
          onChanged: (value) => _faqEntries![index]["answer"] = value,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Enter the answer',
          ),
        ),
      ],
    );
  }
}
