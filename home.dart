import 'package:flutter/material.dart';
import 'package:lookout_dev/screen/info_screen/calendar_screen.dart';
import 'package:lookout_dev/screen/info_screen/user_screen.dart';
import 'package:lookout_dev/template/event_tile.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/screen/welcome.dart';
import 'package:lookout_dev/screen/create_event.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static String id = 'home_screen';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = AccountController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            const FittedBox(fit: BoxFit.fitWidth, child: Text('HCMUS Lookout')),
        backgroundColor: const Color.fromRGBO(7, 0, 166, 1),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            iconSize: 40,
            icon: const Icon(Icons.person),
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
              leading: const Icon(Icons.person),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            const UserScreen(userName: "Faker")));
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => Calendar()));
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Settings'),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Sign Out'),
              onTap: () {
                controller.signOut();
                Navigator.popAndPushNamed(context, WelcomeScreen.id);
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.filter_list),
                  onPressed: () {},
                ),
              ],
            ),
            const EventTile(eventName: "Event 1"),
            const EventTile(eventName: "T1"),
            const EventTile(
              eventName: "A",
            ),
            const EventTile(
              eventName: "c-",
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateEventScreen()),
                );
              },
              child: Text('Create Event'),
            ),
          ],
        ),
      ),
    );
  }
}