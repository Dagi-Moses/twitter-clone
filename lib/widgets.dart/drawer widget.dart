import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

import '../pages/user_profile.dart';
Size ?screenSize;
 bool sch = true;
class DrawerWidget extends StatelessWidget {
  
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
   screenSize = MediaQuery.of(context).size;
  
    return SafeArea(
      child: ListView(
        
        padding: EdgeInsets.zero,
        children: [
          ListTile(
            leading: const CircleAvatar(
              backgroundColor: Colors.blue,
            ),
            trailing: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.person_add_alt_1_outlined),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Your uncle and 50 others',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 5,
                ),
                const Text(
                  '@Dagi_Moses',
                  style: TextStyle(
                      fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(
                  height: 5,
                ),
                RichText(
                    text: const TextSpan(children: [
                  TextSpan(
                    text: '4,037',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' Following',
                    style: TextStyle(
                        fontSize: 15, color: Colors.grey),
                  ),
                  TextSpan(
                    text: '   3,667',
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: ' Followers',
                    style: TextStyle(
                        fontSize: 15, color: Colors.grey),
                  ),
                ])),
              ],
            ),
          ),
          ListTile(
              leading: const Icon(
                Icons.person_outlined,
                size: 25,
              ),
              title: const Text(
                'Profile',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {
                Navigator.push(context,
        PageTransition(type: PageTransitionType.rightToLeft, child: UserProfile()));
              }),
          ListTile(
              leading: const Icon(
                Icons.message_outlined,
                size: 25,
              ),
              title: const Text(
                'Topics',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {}),
          ListTile(
              leading: const Icon(
                Icons.bookmark_border_outlined,
                size: 25,
              ),
              title: const Text(
                'BookMarks',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {}),
          ListTile(
              leading: const Icon(
                Icons.list_alt,
                size: 25,
              ),
              title: const Text(
                'Lists',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {}),
          ListTile(
              leading: const Icon(
                Icons.person_add_alt_1_outlined,
                size: 25,
              ),
              title: const Text(
                'Twitter Circle',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              onTap: () {}),
         const Padding(
           padding: EdgeInsets.only(top:25.0),
           child: Divider(
            thickness: 1.5,
           ),
         ),
           ListTile(
              
              leading: const Text(
                'Professional Tools',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              trailing:  const Icon(
                Icons.arrow_drop_down_outlined,
                size: 25,
              ),
              onTap: () {}),
           ListTile(
              
              leading: const Text(
                'Settings and Support',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              trailing:  const Icon(
                Icons.arrow_drop_down_outlined,
                size: 25,
              ),
              onTap: () {}),
           Padding(
             padding: const EdgeInsets.only(top:100, left: 20),
             child: Align(
              alignment: Alignment.bottomLeft,
              child: IconButton(
                onPressed: () {
                  openDialog(context);
                },
                icon: Icon(Icons.contrast_outlined))),
           ),
        ],
        
        
      ),
    );
  }
}
void openDialog(BuildContext context) {
  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Material(color: Colors.transparent,
          child: Container(
            width:screenSize!.width ,
            decoration: BoxDecoration(
              color: Colors.grey[900],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0),
              ),
            ),
            height: screenSize!.height*0.46,
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top:6, bottom: 11),
                  height: 5,
                  width: 40,
                    decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20)
                
            ),
                ),
                // Add your content here
            
               Text('Dark mode', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
               ListTile(
                leading: Text('Dark mode', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                trailing: Switch(
                 // activeColor: Colors.green,
                  inactiveTrackColor: Colors.grey,
                  activeTrackColor: Colors.green,
                // thumbColor: MaterialStateProperty<Color?>?Colors.green,
                 // set the state later
                  value: sch, onChanged: (val){
                     sch = val;
                  })
               ),
               ListTile(
                leading: Text('Use device settings', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),),
                trailing: Switch(value: true, onChanged: (val){ 
                  
                })
               ),
               Text('Set Dark mode to use the light or dark selection located in your device Display & Brightness settings'),
              ],
            ),
          ),
        ),
      );
    },
  );
}