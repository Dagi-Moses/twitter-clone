import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:twitter_clone/methods/firebase%20firestore%20methods.dart';
import 'package:twitter_clone/pages/layout%20page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../pages/select photo.dart';

class EditProfileBottom extends ConsumerStatefulWidget {
  const EditProfileBottom({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileBottomState();
}

final dateProvider = StateProvider<DateTime?>((ref) => null);

class _EditProfileBottomState extends ConsumerState<EditProfileBottom> {
  DateTime? _selectedDate;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _bioController = TextEditingController();
  TextEditingController _locationController = TextEditingController();
  TextEditingController _birthDateController = TextEditingController();
  bool _isloading = false;
  @override
  Widget build(BuildContext context) {
    
    String? name = ref.watch(nameProvider);
    String? username = ref.watch(usernameProvider);
    String? location = ref.watch(locationProvider);
    String? birthdate = ref.watch(birthdateProvider);

    String? bio = ref.watch(bioProvider);
    String? profileImage = ref.watch(profileImageUrlProvider);
    String? coverImage = ref.watch(coverImageUrlProvider);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.grey[900],
          centerTitle: true,
          title: Text('Edit profile'),
        ),
        body: SingleChildScrollView(
          child: Container(
            height: screenSize!.height,
            width: screenSize!.width,
            color: Colors.black,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SelectPhoto(
                                      isProfilePhoto: false,
                                    )));
                      },
                      child: Hero(
                        tag: 'coverImage',
                        transitionOnUserGestures: true,
                        child: Container(
                          width: screenSize!.width,
                          height: screenSize!.height * 0.22,
                          // color: Colors.green,
                          decoration: BoxDecoration(
                            //color: Colors.red,
                            image: DecorationImage(
                                image: NetworkImage(coverImage?? 'https://picsum.photos/200/300'),
                                fit: BoxFit.fill),
                            //  borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 10,
                      bottom: 10,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SelectPhoto(
                                            isProfilePhoto: true,
                                          )));
                            },
                            child: Hero(
                              //  transitionOnUserGestures: true,
                              tag: 'profileImage',
                              child: CircleAvatar(
                                radius: 38.0,
                                backgroundImage: NetworkImage(profileImage ?? 'https://picsum.photos/200/300'),
                              ),
                            ),
                          ),
                          Positioned(
                            child: FractionalTranslation(
                                translation: Offset(0.75, 0.75),
                                child: Icon(
                                  Icons.linked_camera_outlined,
                                  size: 30,
                                )),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                Divider(
                  height: 1.5,
                ),
                ListTile(
                  leading: Text(
                    'Name',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  title: TextFormField(
                    controller: _usernameController,
                    style: TextStyle(
                      color: Colors.blue, // Change the color here
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.blue, // Change the color here
                      ),
                      hintText: username ?? 'add a username',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Divider(
                  height: 1.5,
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Text(
                    'bio',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  title: TextFormField(
                    maxLines: 4,
                    controller: _bioController,
                    style: TextStyle(
                      color: Colors.blue, // Change the color here
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.blue, // Change the color here
                      ),
                      hintText: bio ?? 'add your bio',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Divider(
                  height: 1.5,
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Text(
                    'location',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold, ),
                  ),
                  title: TextFormField(
                    controller: _locationController,
                    style: TextStyle(
                      color: Colors.blue, // Change the color here
                    ),
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.blue, // Change the color here
                      ),
                      hintText: location ?? 'add your location',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Divider(
                  height: 1.5,
                ),
                SizedBox(
                  height: 10,
                ),
                ListTile(
                  leading: Text(
                    'birthDate',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                  ),
                  title: TextFormField(
                    onTap: () {
                      _selectDate(context);
                    },
                    readOnly: true,
                    controller: _birthDateController,
                    style: TextStyle(
                      color: Colors.blue, // Change the color here
                    ),
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(
                        color: Colors.blue, // Change the color here
                      ),
                      hintText: birthdate ?? 'add your birth date',
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        floatingActionButton: ElevatedButton(
            
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: () async {
            setState(() {
               FocusScope.of(context).unfocus();
              _isloading = true;
            });
            
            await updateprofile(
                context: context,
                username: _usernameController.text,
                location: _locationController.text,
                bio: _bioController.text,
                birthDate: _selectedDate!);
            setState(() {
              _isloading = false;
            });
              
            
          },
          child:_isloading ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator( color: Colors.white,),
             ) : const Text('Save Changes'),
        )
        );
  }

  Future<void> _selectDate(BuildContext context) async {
    //get the position of the clicked text field
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1800),
      lastDate: DateTime.now(),
      // use the position of the clicked text field to set the position of the calendar dialog
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _birthDateController.text = DateFormat.yMd().format(_selectedDate!);
      });
    }
  }
}
