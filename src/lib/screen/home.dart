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
import 'package:lookout_dev/screen/info_screen/user_events_screen.dart';

import '../data/account_class.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static String id = 'home_screen';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = AccountController();
  String _searchQuery = "";
  String _filterQuery = "Time↓";
  final List<String> _filterOptions = <String>["New", "Time↓", "Time↑"];
  AppUser? _currentUser;

  Future _getUser() async {
    AppUser? appUser = await AccountController().getCurrentUser();

    if (appUser != null) {
      setState(() {
        _currentUser = appUser;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<EventClass>?>.value(
      initialData: null,
      value: EventController().events,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          centerTitle: true,
          title: const FittedBox(
            fit: BoxFit.fitWidth,
            child: Text('HCMUS Lookout'),
          ),
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
                      builder: (context) => const UserScreen(userName: "Faker"),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: const Text('Calendar'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Calendar()),
                  );
                },
              ),
              // Nút "MANAGE EVENTS" nằm giữa "Calendar" và "Settings"
              ListTile(
                leading: const Icon(Icons.event),
                title: const Text('MANAGE EVENTS'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserEventsScreen()),
                  );
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
              Visibility(
                visible: _currentUser is Club,
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Club Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(currentClub: _currentUser as Club),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Column(
            children: <Widget>[
              // Container for search bar and filter button with rounded bottom edges
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, // Same color as the app bar
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    // Search bar
                    Expanded(
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'Search',
                          fillColor: Colors.white,
                          filled: true, // To make sure the input field has a white background
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60.0),
                            borderSide: BorderSide.none, // No border to blend with the container
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0), // Space between the search bar and dropdown
                    // Filter button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color: Colors.white, // White background for the dropdown
                        borderRadius: BorderRadius.circular(60.0),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _filterQuery,
                          icon: const Icon(Icons.filter_list),
                          items: _filterOptions
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _filterQuery = value!;
                            });
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: EventList(
                  searchQuery: _searchQuery,
                  sortQuery: _filterQuery,
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: SizedBox(
          height: 80,
          width: 140,
          child: FloatingActionButton(
            backgroundColor: Colors.lightBlueAccent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateEventScreen()),
              );
            },
            child: const Text('CREATE EVENT'),
          ),
        ),
      ),
    );
  }
}
