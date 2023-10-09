import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_student/screens/liststudent.dart';

import '../functions/functions.dart';
import 'model.dart';

class AddStudent extends StatefulWidget {
  @override
  State<AddStudent> createState() => _AddStudentState();
}

class _AddStudentState extends State<AddStudent> {
  final _formKey = GlobalKey<FormState>();
  final rollnoController = TextEditingController();
  final nameController = TextEditingController();
  final departmentController = TextEditingController();
  final phonenoController = TextEditingController();
  File? _selectedImage;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme:IconThemeData(color: Colors.black) ,
          title: Text(
            "Student Information",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.greenAccent,
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StudentInfo()),
                );
              },
              icon: Icon(
                Icons.person_search,
                color: Colors.black,
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsetsDirectional.all(25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.greenAccent,
                  maxRadius: 60,
                  child: GestureDetector(
                    onTap: () async {
                      File? pickimage = await _pickImageFromCamera();
                      setState(() {
                        _selectedImage = pickimage;
                      });
                    },
                    child: _selectedImage != null
                        ? ClipOval(
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: 140,
                              height: 140,
                            ),
                          )
                        : const Icon(
                            Icons.add_a_photo_rounded,
                            color: Colors.black,
                          ),
                  ),
                ),
                SizedBox(height: 30),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Student Name",labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent))
                    
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Name is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: rollnoController,
                  decoration: const InputDecoration(
                    labelText: "Roll number",labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent))
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Roll no is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.name,
                  controller: departmentController,
                  decoration: const InputDecoration(
                    labelText: "Department",labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                    prefixIcon: Icon(Icons.school),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Department is required';
                    }

                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: phonenoController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent)),
                    prefixIcon: Icon(Icons.phone),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Phone number is required';
                    }
                    final phoneRegExp = RegExp(r'^[0-9]{10}$');
                    if (!phoneRegExp.hasMatch(value)) {
                      return 'Invalid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 45),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedImage == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                              "You must select an image",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        );
                        return;
                      }
                      final student = StudentModel(
                        rollno: rollnoController.text,
                        name: nameController.text,
                        department: departmentController.text,
                        phoneno: phonenoController.text,
                        imageurl: _selectedImage != null
                            ? _selectedImage!.path
                            : null,
                      );
                      await addStudent(student);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.green,
                          content: Text(
                            "Data Added Successfully",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      );
                      rollnoController.clear();
                      nameController.clear();
                      departmentController.clear();
                      phonenoController.clear();
                      setState(() {
                        _selectedImage = null;
                      });
                    }
                  },
                  child: Text(
                    "Save",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                      backgroundColor: Colors.greenAccent),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<File?> _pickImageFromCamera() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }
}
