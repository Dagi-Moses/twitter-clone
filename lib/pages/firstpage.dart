import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:page_transition/page_transition.dart';
import 'package:twitter_clone/pages/login%20page.dart';
import 'package:twitter_clone/pages/sign%20up%20page.dart';
// remove the size boxes in between and replace with columns and set the main and cross axis alignment instead

class FirstPage extends StatelessWidget {
  const FirstPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
          backgroundColor: Color(0xff303234),
          centerTitle: true,
          elevation: 0,
          title: Icon(
            FontAwesomeIcons.twitter,
            color: Colors.blue,
            size: 34,
          )),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 100, left: 18, right: 18, bottom: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "See what's happening in the world right now.",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              SizedBox(
                height: 100,
              ),
              CustomButton(
                  () {},
                  'https://th.bing.com/th/id/OIP.Kg2FF2wpIK_HLyo8Q56ycAHaFj?pid=ImgDet&rs=1',
                  'Continue with Google'),
              SizedBox(
                height: 15,
              ),
              CustomButton(
                  () {},
                  'https://th.bing.com/th/id/OIP.6x6s1sTIRrU8my_FCLwPqwHaFj?pid=ImgDet&rs=1',
                  'Continue with Apple'),
              SizedBox(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Divider(
                      thickness: 2.0, // set the thickness of the divider
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Text(
                      'or',
                      style: TextStyle(fontSize: 16),
                    ), // Text displayed in between the divider
                  ),
                  Expanded(
                    child: Divider(
                      thickness: 2.0, // set the thickness of the divider
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              CustomButton(() { Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: SignUpPage())); }, '', 'Create account'),
              SizedBox(
                height: 15,
              ),
              RichText(
                text: TextSpan(
                  style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontWeight: FontWeight.w400),
                  children: [
                    TextSpan(text: 'By signing up, you agree to our'),
                    TextSpan(text: ', '),
                    TextSpan(
                        style: TextStyle(color: Colors.blue), text: 'Terms'),
                    TextSpan(text: ', '),
                    TextSpan(
                        style: TextStyle(color: Colors.blue),
                        text: 'Privacy Policy'),
                    TextSpan(text: ', and '),
                    TextSpan(
                        style: TextStyle(color: Colors.blue),
                        text: 'Cookie Use'),
                    TextSpan(text: '.'),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
              ),
              RichText(
                  text: TextSpan(
                style: TextStyle(fontSize: 16, color: Colors.grey),
                children: [
                  TextSpan(text: ' Have an account already?'),
                  TextSpan(
                      style: TextStyle(
                        color: Colors.blue), 
                        text: ' Log in',
                        recognizer: TapGestureRecognizer()
          ..onTap = () {
          Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: LoginPage()));
          },),
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}

Widget CustomButton(VoidCallback onPressed, String url, String text) {
  return SizedBox(
    height: 55,
    child: ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          backgroundColor: Colors.white),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          url.isNotEmpty
              ? SizedBox(
                  height: 55,
                  width: 55,
                  child: Image.network(
                    url,
                  ))
              : SizedBox(),
          Text(
            text,
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          )
        ],
      ),
    ),
  );
}
