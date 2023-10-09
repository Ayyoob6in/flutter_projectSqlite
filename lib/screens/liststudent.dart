import 'dart:io';

import 'package:flutter/material.dart';
import 'package:project_student/screens/addstudent.dart';
import '../functions/functions.dart';
import 'model.dart';

class StudentInfo extends StatefulWidget {
  const StudentInfo({Key? key}) : super(key: key);

  @override
  State<StudentInfo> createState() => _StudentInfoState();
}

class _StudentInfoState extends State<StudentInfo> {
  late List<Map<String, dynamic>> _studentsData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchStudentsData();
  }

  Future<void> _fetchStudentsData() async {
    List<Map<String, dynamic>> students = await getAllStudents();
    if (searchController.text.isNotEmpty) {
      students = students
          .where((student) => student['name']
              .toString()
              .toLowerCase()
              .contains(searchController.text.toLowerCase()))
          .toList();
    }

    setState(() {
      _studentsData = students;
    });
  }

  Future<void> _showEditDialog(int index) async {
    final student = _studentsData[index];
    final TextEditingController nameController =
        TextEditingController(text: student['name']);
    final TextEditingController rollnoController =
        TextEditingController(text: student['rollno'].toString());
    final TextEditingController departmentController =
        TextEditingController(text: student['department']);
    final TextEditingController phonenoController =
        TextEditingController(text: student['phoneno'].toString());
    

    showDialog(
      context: context,
      builder: (BuildContext) => AlertDialog(
        title: Text("Edit Student"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Name"),
              ),
              TextFormField(
                controller: rollnoController,
                decoration: InputDecoration(labelText: "Roll No"),
              ),
              TextFormField(
                controller: departmentController,
                decoration: InputDecoration(labelText: "Department"),
              ),
              TextFormField(
                controller: phonenoController,
                decoration: InputDecoration(labelText: "Phone No"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () async {
              await updateStudent(
                StudentModel(
                  id: student['id'],
                  rollno: rollnoController.text,
                  name: nameController.text,
                  department: departmentController.text,
                  phoneno: phonenoController.text,
                  imageurl: student['imageurl'],
                ),
              );
              Navigator.of(context).pop();
              _fetchStudentsData(); // Refresh the list
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  backgroundColor: Colors.green,
                  content: Text("Changes Updated")));
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
    
  }
  Future<void> _showStudentDetailsDialog(Map<String, dynamic> student) async {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Student Details",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text("Name: ${student['name']}",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),),
            ),
            ListTile(
              title: Text("Roll No: ${student['rollno']}",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),),
            ),
            ListTile(
              title: Text("Department: ${student['department']}",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),),
            ),
            ListTile(
              title: Text("Phone No: ${student['phoneno']}",style: TextStyle(color: Colors.blueAccent,fontWeight: FontWeight.bold),),
            ),
            // Add more student details as needed
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text("Close",style: TextStyle(color: Colors.redAccent,fontWeight: FontWeight.bold),),
            
          ),
        ],
      );
    },
  );
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
        iconTheme:IconThemeData(color: Colors.black) ,
          backgroundColor: Colors.greenAccent,
          title: Text(
            "STUDENTS LIST",
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(80),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: EdgeInsets.all(10.0),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {
                      _fetchStudentsData();
                    });
                  },
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.greenAccent
                    ),
                    labelText: "Search",labelStyle: TextStyle(color: Colors.black),
                    border: OutlineInputBorder(),
                                        enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.greenAccent))


                  ),
                ),
              ),
            ),
          ),
        ),
        body:
         _studentsData.isEmpty
            ? Center(child: Text("No students available."))
            : ListView.separated(
                itemBuilder: (context, index) {
                  final student = _studentsData[index];
                  final id = student['id'];
                  final imageUrl = student['imageurl'];

                  return ListTile(
                    onTap: () {
                      _showStudentDetailsDialog(student);
                    },
                    leading: GestureDetector(
                      onTap: () {
                        if (imageUrl != null) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.file(File(imageUrl)),
                                  ],
                                ),
                              );
                            },
                          );
                        }
                      },
                      child: CircleAvatar(
                        backgroundImage:
                            imageUrl != null ? FileImage(File(imageUrl)) : null,
                        child: imageUrl == null ? Icon(Icons.person) : null,
                      ),
                    ),
                    title: Text('${student['name']}',style: TextStyle(fontWeight: FontWeight.bold),),
                    subtitle: Text(student['department']),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            _showEditDialog(index);
                          },
                          icon: Icon(
                            Icons.edit,
                            color: Colors.greenAccent,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext) => AlertDialog(
                                title: Text("Delete Student"),
                                content:
                                    Text("Are you sure you want to delete?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                    },
                                    child: Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await deleteStudent(
                                          id); // Delete the student
                                      _fetchStudentsData(); // Refresh the list
                                      Navigator.of(context)
                                          .pop(); // Close the dialog
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                  "Deleted Successfully")));
                                    },
                                    child: Text("Ok"),
                                  )
                                ],
                              ),
                            );
                          },
                          icon: Icon(Icons.delete, color: Colors.orange),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Divider();
                },
                itemCount: _studentsData.length,
              ),
              floatingActionButton:FloatingActionButton(onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(builder: (context)=>AddStudent()));
              },
              backgroundColor: Colors.greenAccent,
              child: Icon(Icons.person_add_alt_1,shadows: [Shadow(color: Colors.black ,offset: Offset(2, 2 ))],),
              ),
      ),
    );
  }
  
  void showDialog_1({required BuildContext context, required AlertDialog Function(dynamic BuildContext) builder}) {}
}
