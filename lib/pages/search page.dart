import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: Colors.grey[900],
            leading: Padding(
              padding: EdgeInsets.only(left:8, bottom: 5, right: 8, top: 5),
                
                child: CircleAvatar(
                  
                  backgroundColor: Colors.green,
                ),
                ),
                title: SizedBox(
                  height: 40,
                  child: TextField(
                    
                    decoration: InputDecoration(

                      contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 70),
                    filled: true,
                    fillColor: Colors.grey[850], 
                        
                      prefixIcon: Icon(Icons.search),
                   
                      hintText: 'Search Twitter',
                      border:OutlineInputBorder(
                        borderSide: BorderSide.none,
                        
                        borderRadius: BorderRadius.circular(30)
                      )
                    ),
                  ),
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right:12.0),
                    child: IconButton(onPressed: (){}, icon: Icon(Icons.settings_outlined)),
                  ),
                ],
          ),
        ],
      ),
    );
  }
}
