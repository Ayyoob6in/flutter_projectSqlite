import 'package:flutter/material.dart';
import 'package:project_student/screens/liststudent.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child:Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.greenAccent,
          title: Center(child: Text('WELCOME TO BROCAMP',style: TextStyle(color: Colors.black,fontSize: 20 , fontWeight: FontWeight.w800),)),
        ),
        backgroundColor: Colors.white,
        body: 
       Center(
         child: Container(child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>StudentInfo()));
            }, 
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(Colors.greenAccent)),
            child: Text('Show Student Details',style: TextStyle(color: Colors.black,fontWeight: FontWeight.w800,fontSize: 15),),
            
            )
          ],
         ),),
       )
      ),
       );
  }
}