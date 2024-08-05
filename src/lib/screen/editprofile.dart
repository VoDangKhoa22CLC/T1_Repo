import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/info_screen/user_screen.dart';
import 'package:lookout_dev/screen/login.dart';
import 'package:lookout_dev/template/event_tile.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: TextStyle(
            color: Colors.blue
          ),
          ),
        backgroundColor: Colors.black87,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.arrow_back,
            color: Colors.blue,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {}, 
            icon: Icon(Icons.settings)
            )
        ],
      ),
      body: Container(
        // padding: EdgeInsets.all(5),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Center(
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.all(10),
                      width: 75,
                      height: 75,
                      decoration: BoxDecoration(
                        border: Border.all(width: 5, color: Colors.blue),
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage('https://pbs.twimg.com/media/GUL20KWXkAAqo4c?format=jpg&name=medium'),
                        ),
                        boxShadow: [
                          BoxShadow(
                            spreadRadius: 2,
                            blurRadius: 10,
                            color: Colors.black.withOpacity(0.4)
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 15,
                      right: 15,
                      child: Container(
                        height: 15,
                        width: 15,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(width: 2.5, color: Colors.blue),
                          color: Colors.white
                        ),
                        child: Icon(
                          Icons.edit,
                          color: Colors.indigo,
                          size: 10,
                        ),
                      ),
                    ),

                  ],
                ),
              ),
              SizedBox(height: 30),
              textField("Club Name", "Test")
            ],
          ),
        ),
      ),
    );
  }

  Widget textField(String sectionName, String content) {
    return Padding(
      padding: EdgeInsets.only(bottom: 30),
      child: TextField(
        obscureText: false,
        decoration: InputDecoration(
          suffixIcon: null,
          contentPadding: EdgeInsets.only(bottom: 5),
          labelText: sectionName,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: null,
          hintStyle: TextStyle(
            fontSize: 10,
            color: Colors.grey
          )
        ),
      ),
    );
  }
}