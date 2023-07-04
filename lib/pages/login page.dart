import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:twitter_clone/methods/firebase%20firestore%20methods.dart';
import 'package:twitter_clone/pages/sign%20up%20page.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Spacer(),
              Icon(
                FontAwesomeIcons.twitter,
                size: 70,
                color: Colors.blue,
              ),
              Spacer(),
              TextField(
               
                          style: TextStyle(
    color: Colors.black, // Set the desired color here
  ),
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Phone, email or username',
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  fillColor: Color(0xFFEFEFEF),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
              ),
              SizedBox(height: 20),
              TextField(
                style: TextStyle(
    color: Colors.black, // Set the desired color here
  ),
                controller: _passwordController,
                decoration: InputDecoration(
                  
                  hintStyle: TextStyle(color: Colors.black),
                  hintText: 'Password',
                  filled: true,
                  fillColor: Color(0xFFEFEFEF),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  try {
                  await  signInUser(
                        email: _emailController.text,
                        password: _passwordController.text,
                        context: context);
                    setState(() {
                      isLoading = false;
                    });
                  } catch (e) {
                    print(e);
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: isLoading
                    ? SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ))
                    : Text('Log in'),
                style: ElevatedButton.styleFrom(
                    fixedSize: Size.fromHeight(40),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    )),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Forgot password?',
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: SignUpPage()));
                    },
                    child: Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
