import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:page_transition/page_transition.dart';

import '../methods/firebase firestore methods.dart';
import 'layout page.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  
  TextEditingController _dateController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isNameFilled = false, _isPhoneFilled = false, _isDateFilled = false , _isEmailFilled = false, _isPasswordFilled = false;
  bool isloading = false;
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Color(0xff303234),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Padding(
              padding: const EdgeInsets.only(top: 19, left: 5),
              child: Expanded(
                  child: Text(
                'Cancel',
                maxLines: 1,
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              )),
            ),
          ),
          centerTitle: true,
          elevation: 0,
          title: Icon(
            FontAwesomeIcons.twitter,
            color: Colors.blue,
            size: 34,
          )),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 8),
               height: 600,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Create your account',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  
                    CustomTextField((value) {
                      setState(() {
                        _isNameFilled = value.isNotEmpty;
                        print(_isNameFilled);
                      });
                    }, _nameController, () {}, false, 'Name', TextInputType.name),
                    CustomTextField((value) {
                  setState(() {
                    _isPhoneFilled = value.isNotEmpty;
                  });
                },
                      _phoneController,
                      () {},
                      false,
                      'Phone number ',
                      TextInputType.number,
                    ),
                    CustomTextField((value) {
                      setState(() {
                        _isEmailFilled = value.isNotEmpty;
                        print(_isNameFilled);
                      });
                    }, _emailController, () {}, false, 'Email', TextInputType.name),
                    CustomTextField((value) {
                  setState(() {
                    _isPasswordFilled = value.isNotEmpty;
                  });
                },
                      _passwordController,
                      () {},
                      false,
                      'Password ',
                      TextInputType.text,
                    ),
                    CustomTextField((value) {
                  
                },
                      _dateController, () {
                      _selectDate(context);
                    }, true, 'Date of birth', TextInputType.datetime),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: CustomSmallButton(() async{
        setState(() {
          isloading = true;
          
        });
      try{
 await signUpAndStoreUserData(
          _nameController.text,
          _phoneController.text,
          _emailController.text,
          _passwordController.text,
          _selectedDate!,
          context,
          
        );
          setState(() {
          isloading = false;
          
        });
      }catch (e){
 
          setState(() {
          isloading = false;
          
        });
      }

        
        
      }),
    );
  }

  Widget CustomSmallButton(VoidCallback onPressed) {
    return ElevatedButton(
      
        style: ElevatedButton.styleFrom(
          backgroundColor:
              _isNameFilled && _isPhoneFilled && _isDateFilled && _isEmailFilled && _isPasswordFilled
                  ? Colors.blue
                  : Colors.grey[700],
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: onPressed,
        child: isloading? SizedBox(
          height: 20,
          width: 20,
          child: CircularProgressIndicator(
            
            color: Colors.white,),
        ): Text('Next'));
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
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
    _dateController.text =DateFormat.yMd().format(_selectedDate!);
        _isDateFilled = true;
      });
    }
  }
}

                  
            

Widget CustomTextField(
    Function(String) onChanged,
    TextEditingController controller,
    VoidCallback onTap,
    bool readonly,
    String hintText,
    TextInputType keyboardtype) {
  return TextFormField(
    readOnly: readonly,
    onTap: onTap,
    onChanged: onChanged,
    controller: controller,
    keyboardType: keyboardtype,
    decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w500,
        )),
  );
}
