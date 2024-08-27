import 'package:flutter/material.dart';
import 'package:lookout_dev/controller/event.dart';
import 'package:lookout_dev/data/event_class.dart';
import 'package:lookout_dev/screen/info_screen/calendar_screen.dart';
import 'package:lookout_dev/screen/info_screen/club_profile.dart';
import 'package:lookout_dev/screen/info_screen/user_screen.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/screen/welcome.dart';
import 'package:lookout_dev/screen/info_screen/event_create.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static String id = 'home_screen';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = AccountController();
  String _searchQuery = "";
  String _filterQuery = "Q1";
  final List<String> _filterOptions = <String>["Q1", "Q2", "Q3"];

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<EventClass>?>.value(
      initialData: null,
      value: EventController().events,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title:
              const FittedBox(fit: BoxFit.fitWidth, child: Text('HCMUS Lookout')),
          backgroundColor: Theme.of(context).primaryColor,
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
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: const Text(
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
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('club profile'),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()));
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
                    child: TextFormField(
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  DropdownButton(
                    value: null,
                    icon: const Icon(Icons.filter_list),
                    items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        _filterQuery = value!;
                      });
                    }
                  )
                ],
              ),
              EventList(searchQuery: _searchQuery),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CreateEventScreen()),
                  );
                },
                child: const Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
