import 'package:flutter/material.dart';
class SideMenu extends StatefulWidget {
  const SideMenu({super.key});

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 340,
        height: double.infinity,
        color: Colors.grey[900],
        child: SafeArea(
          child: Column(
            children: [ListTile(
              leading: CircleAvatar(
                child: Icon(Icons.person),

              ),trailing: Icon(Icons.person_add_alt_1_outlined),
              
            )],
            
          ),
        ),
      ),
    );
  }
}