import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

class SelectPhoto extends ConsumerStatefulWidget {
  final bool isProfilePhoto;
   SelectPhoto({super.key, required this.isProfilePhoto});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SelectPhotoState();
}
final profileImageUrlProvider = StateProvider<String?>((ref) => null);
final coverImageUrlProvider = StateProvider<String?>((ref) => null);
class _SelectPhotoState extends ConsumerState<SelectPhoto> {
  Size? screenSize;
  void Takephoto (){
    _pickImage(context, true);
  }
  void Choosephoto (){
    _pickImage(context, false);
  }
  FirebaseAuth _auth = FirebaseAuth.instance;
  final imageProvider = StateProvider<File?>((ref) => null);
  Future<void> _pickImage(BuildContext context, bool istakePhoto) async {
    final ImagePicker _imagePicker = ImagePicker();
    final pickedImage = await _imagePicker.pickImage(
      source: istakePhoto ? ImageSource.camera : ImageSource.gallery,
    );
    if (pickedImage != null) {
      final imageFile = File(pickedImage.path);
      ref.read(imageProvider.notifier).state = imageFile;
    }
_uploadImage(context);
  }

  Future<void> _uploadImage(BuildContext context) async {
    final imageFile = ref.watch(imageProvider);
    if (imageFile != null && widget.isProfilePhoto) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profileImage')
          .child(_auth.currentUser!.uid);
      final uploadTask = storageRef.putFile(imageFile);

      await uploadTask.whenComplete(() {
        storageRef.getDownloadURL().then((imageUrl) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .update({
            'profileImage': imageUrl,
          });
        });
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Image uploaded successfully')));
    } 
    if (imageFile != null && !widget.isProfilePhoto) {
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('coverImage')
          .child(_auth.currentUser!.uid);
      final uploadTask = storageRef.putFile(imageFile);

      await uploadTask.whenComplete(() {
        storageRef.getDownloadURL().then((imageUrl) {
          FirebaseFirestore.instance
              .collection('users')
              .doc(_auth.currentUser!.uid)
              .update({
            'coverImage': imageUrl,
          });
        });
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Image uploaded successfully')));
    } 
    
    
    else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No image selected')));
    }
  }

  @override
  Widget build(BuildContext context) {
     screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
      ),
      body:  StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
       
          
           
            Map<String, dynamic> ? data = snapshot.data?.data() as Map<String, dynamic> ?;
           
           Future.delayed(Duration(seconds: 1) ,() {
              ref.read(profileImageUrlProvider.notifier).state = data?['profileImage'];
              ref.read(coverImageUrlProvider.notifier).state = data?['coverImage'];
           }); 
          
           String? profileImage = ref.watch(profileImageUrlProvider);
           String? coverImage = ref.watch(coverImageUrlProvider);
           

          

              return Content(widget.isProfilePhoto? profileImage: coverImage );
            
    
      },
    ),
    );
    
  }
  Widget Content (String ?url, ){
  return  Container(
        height: screenSize!.height,
        width: screenSize!.width,
        child: Stack(
          //  mainAxisAlignment: MainAxisAlignment.end,
          children: [
           
            Center(
              child:widget.isProfilePhoto ? Hero(
                
                tag:  'profileImage',
                transitionOnUserGestures: true,
                child:  url != null ?ClipOval(
                  child: Image.network(
                    url,
                    height: screenSize!.width * 0.9,
                    width: screenSize!.width * 0.9,
                    fit: BoxFit.cover,
                  ),
                ): CircleAvatar(
                  backgroundColor: Colors.grey,
                         radius: screenSize!.width * 0.45,
                          child: Icon(Icons.person, size: screenSize!.width*0.7,),
                          ))
                          :Hero(
                            tag: 'coverImage',
                            transitionOnUserGestures: true,

                            child: url != null ?Image.network(
                                              url,
                                              height: screenSize!.width,
                                              width: screenSize!.width * 0.9,
                                              fit: BoxFit.cover,
                                           
                                          ): Icon(Icons.person, size: screenSize!.width*0.8,),
                          )
                           
              ),
            
            Positioned(
              bottom: 0,
              left: 0,
              child: TextButton(
                  onPressed: () {
                    _showBottomSheet(context,Takephoto,Choosephoto);
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  )),
            ),
          ],
        ),
      );
}
}

void _showBottomSheet(
    BuildContext context, VoidCallback TakePhoto, VoidCallback ChoosePhoto) {
  showModalBottomSheet(
    backgroundColor: Colors.transparent,
    context: context,
    builder: (BuildContext context) {
      return Container(
        padding: EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 100),
              leading: Icon(Icons.delete),
              title: Text('Delete Photo'),
              onTap: () {
                deleteImageFromFirestore();
              },
            ),
            Divider(
              height: 2,
            ),
            ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 100),
              leading: Icon(Icons.camera_alt),
              title: Text('Take Photo'),
              onTap: TakePhoto,
            ),
            Divider(
              height: 2,
            ),
            Center(
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 100),
                leading: Icon(Icons.image),
                title: Text('Choose Photo'),
                onTap: ChoosePhoto,
              ),
            ),
            Divider(
              height: 2,
            ),
            Center(
              child: ListTile(
                contentPadding: EdgeInsets.symmetric(horizontal: 100),
                leading: Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                title: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red, fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet
                },
              ),
            ),
          ],
        ),
      );
    },
  );
}

Future<void> deleteImageFromFirestore() async {
  FirebaseAuth _auth = FirebaseAuth.instance;
  try {
    final imageRef = FirebaseFirestore.instance
        .collection('users')
        .doc(_auth.currentUser!.uid);
    await imageRef.update({'profileImage': FieldValue.delete()});

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('profileImage')
        .child(_auth.currentUser!.uid);
    await storageRef.delete();
    print('Image deleted successfully!');
  } catch (e) {
    print('Error deleting image: $e');
  }
}
