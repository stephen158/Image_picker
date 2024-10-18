import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

void main() {
  runApp(MaterialApp(
    home: MyApp(),
    debugShowCheckedModeBanner: false,
  ));
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
   File? _image;
  final imagePicker=ImagePicker();

  Future getImage() async{
    final image = await imagePicker.pickImage(source : ImageSource.camera);
    setState(() {
      _image=File(image!.path);
    });
  }
  Future _getImageFromGallery() async{
    final image = await imagePicker.pickImage(source : ImageSource.gallery);
    setState(() {
      _image=File(image!.path);
    });
  }
  @override
  Widget build(BuildContext context) {
    double Screenheight = MediaQuery.of(context).size.height;
    double Screenwidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
       backgroundColor: Colors.black,
        title: Text('Gallery',style: TextStyle(color: Colors.blue),),
        leading: Icon(Icons.menu,color: Colors.white,),
      ),
      body:Column(
        children: [
          Expanded(
            child: Container(
              child: Center(
                  child: _image == null ? Text('No Image Selected') :
                  Image.file(_image!,
                    height: Screenheight * 0.5,
                    width: Screenwidth * 0.9,)),
            ),
          ),
          Container(
            margin:EdgeInsets.all(30),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
              ),
                onPressed: (){
                    _getImageFromGallery();
                }, child: Text('Gallery',
              style: TextStyle(color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize:20),),),
          ),
          ],
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: ()async{
            PermissionStatus camerastatus=  await Permission.camera.request();
            if(camerastatus ==PermissionStatus.granted){
              getImage();
            }
            if(camerastatus == PermissionStatus.denied){
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("you need to provide camera Permission")));
            }
            if(camerastatus == PermissionStatus.permanentlyDenied){
              openAppSettings();
            }
          },backgroundColor: Colors.blue,
        child: Icon(Icons.camera_alt,color: Colors.black,
        )
      ),
    );
  }
}


