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
import 'info_screen/profile_edit.dart';

class Home extends StatefulWidget {
  const Home({super.key});
  static String id = 'home_screen';

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final controller = AccountController();
  String _searchQuery = "";
  String _filterQuery = "New";
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
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'Username',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'user@example.com', 
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person),
                title: const Text('Profile'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(currentClub: _currentUser as Club),
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
              Visibility(
                visible: _currentUser is Club,
                child: ListTile(
                  leading: const Icon(Icons.event),
                  title: const Text('Manage Events'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UserEventsScreen(myClub: _currentUser as Club)),
                    );
                  },
                ),
              ),
              Visibility(
                visible: _currentUser is Club,
                child: ListTile(
                  leading: const Icon(Icons.calendar_today),
                  title: const Text('Manage Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(myClub: _currentUser as Club),
                      ),
                    );
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () =>
                    Navigator.pushNamed(context, 'account_settings_screen'),
              ),
              ListTile(
                leading: const Icon(Icons.logout, color: Colors.red,),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(
                    color: Colors.red
                  ),
                ),
                onTap: () {
                  // Show confirmation dialog when sign out is tapped
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Sign Out', style: TextStyle(fontWeight: FontWeight.bold)),
                        content: const Text('Are you sure you want to sign out?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              // Close the dialog and do nothing
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text('Confirm', style: TextStyle(color: Colors.red),),
                            onPressed: () {
                              // Perform sign out action
                              controller.signOut();
                              // Close the dialog
                              Navigator.of(context).pop();
                              // Navigate to the WelcomeScreen
                              Navigator.popAndPushNamed(context, WelcomeScreen.id);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
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
                  color: Theme.of(context)
                      .primaryColor, // Same color as the app bar
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
                          filled:
                              true, // To make sure the input field has a white background
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(60.0),
                            borderSide: BorderSide
                                .none, // No border to blend with the container
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                        width:
                            8.0), // Space between the search bar and dropdown
                    // Filter button
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      decoration: BoxDecoration(
                        color:
                            Colors.white, // White background for the dropdown
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
                MaterialPageRoute(builder: (context) => CreateEventScreen(myClub: _currentUser as Club,)),
              );
            },
            child: const Text('CREATE EVENT'),
          ),
        ),
      ),
    );
  }
}
