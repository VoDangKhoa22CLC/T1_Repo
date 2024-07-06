import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/info_screen/user_screen.dart';
import 'package:lookout_dev/screen/login.dart';
import 'package:lookout_dev/template/event_tile.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('HCMUS Lookout')
        ),
        backgroundColor: const Color.fromRGBO(7, 0, 166, 1),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            iconSize: 40,
            icon: Icon(Icons.person),
            onPressed: () {},
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromRGBO(7, 0, 166, 1),
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserScreen(userName: "Faker"))
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Sign Out'),
              onTap: () {
                // Navigator.push(
                //     context,
                //     // MaterialPageRoute(builder: (context) => LogIn(toggle: toggle))
                // );
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
            const EventTile(eventName: "Event 1"),
            const EventTile(eventName: "T1"),
            const EventTile(eventName: "A",),
            const EventTile(eventName: "c-",),
          ],
        ),
      ),
      // bottomNavigationBar: BottomAppBar(
      //   color: Color.fromRGBO(7, 0, 166, 100),
      //   child: Row(
      //     children: <Widget>[
      //       IconButton(
      //         onPressed: () {},
      //         icon: Icon(Icons.manage_search)
      //       ),
      //       IconButton(
      //           onPressed: () {},
      //           icon: Icon(Icons.house)
      //       )
      //     ],
      //   ),
      // ),
    );
  }
}
