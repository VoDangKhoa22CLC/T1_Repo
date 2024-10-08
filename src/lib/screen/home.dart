import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lookout_dev/controller/event.dart';
import 'package:lookout_dev/data/event_class.dart';
import 'package:lookout_dev/screen/info_screen/calendar_screen.dart';
import 'package:lookout_dev/screen/info_screen/club_profile.dart';
import 'package:lookout_dev/screen/info_screen/setting.dart';
import 'package:lookout_dev/screen/info_screen/user_screen.dart';
import 'package:lookout_dev/controller/account.dart';
import 'package:lookout_dev/screen/welcome.dart';
import 'package:lookout_dev/screen/info_screen/event_create.dart';
import 'package:provider/provider.dart';
import 'package:lookout_dev/screen/info_screen/user_events_screen.dart';
import 'package:lookout_dev/screen/info_screen/manage_clubs_screen.dart';

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
  String _filterQuery = "Soon";
  final List<String> _filterOptions = <String>["Soon", "Late", "A-Z", "Z-A", "Trend", "Flop"];
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  AppUser? _currentUser;
  String _displayName = "";
  String _displayEmail = "";
  String _isAdminControl = "";

  Future _getUser() async {
    AppUser? appUser = await AccountController().getCurrentUser();
    bool testAdmin = await AccountController().isAdmin();

    if (appUser != null) {
      setState(() {
        _currentUser = appUser;
        _displayEmail = _currentUser!.email;
        _displayName = _currentUser!.name;
        _isAdminControl = testAdmin.toString();
      });
    }
  }

  bool _getCreate() {
    if (_isAdminControl == "true") {
      return true;
    }

    if (_currentUser == null) {
      return false;
    }

    if (_currentUser is! Club){
      return false;
    }

    if (_currentUser is Club){
      Club thisUser = _currentUser as Club;
      if (thisUser.verified == "true"){
        return true;
      }
    }
    return false;
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
            child: Text('HCMUS - Lookout',
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold)),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          elevation: 0,
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    // const SizedBox(height: 14),
                    Container(
                      width: MediaQuery.of(context).size.width *
                          0.5, // 60% of the screen width
                      child: const Divider(
                        height: 1,
                        thickness: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _displayName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),

                    Text(
                      _displayEmail,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              Visibility(
                visible: _currentUser is Club,
                child: ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Profile'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ProfileScreen(myClub: _currentUser as Club),
                      ),
                    );
                  },
                ),
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
                      MaterialPageRoute(
                          builder: (context) => UserEventsScreen(isAdmin: _isAdminControl,)),
                    );
                  },
                ),
              ),
              // New "Manage Clubs" button
              Visibility(
                visible: _isAdminControl == "true",
                child: ListTile(
                  leading: const Icon(Icons.group),
                  title: const Text('Manage Clubs'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ManageClubsScreen()),
                    );
                  },
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AccountSettingsScreen(),
                    ),
                  ).then((res) => _getUser);
                },
              ),
              ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.red,
                ),
                title: const Text(
                  'Sign Out',
                  style: TextStyle(color: Colors.red),
                ),
                onTap: () {
                  // Show confirmation dialog when sign out is tapped
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Sign Out',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        content:
                            const Text('Are you sure you want to sign out?'),
                        actions: <Widget>[
                          TextButton(
                            child: const Text('Cancel'),
                            onPressed: () {
                              // Close the dialog and do nothing
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: const Text(
                              'Confirm',
                              style: TextStyle(color: Colors.red),
                            ),
                            onPressed: () {
                              // Perform sign out action
                              controller.signOut();
                              // Close the dialog
                              Navigator.of(context).pop();
                              // Navigate to the WelcomeScreen
                              Navigator.popAndPushNamed(
                                  context, WelcomeScreen.id);
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
                child: RefreshIndicator(
                  key: _refreshIndicatorKey,
                  color: Theme.of(context).primaryColor,
                  backgroundColor: Colors.white,
                  strokeWidth: 2.0,
                  onRefresh: () async {
                    _getUser();
                  },
                  child: EventList(
                    searchQuery: _searchQuery,
                    sortQuery: _filterQuery,
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: Visibility(
          visible: _getCreate(),
          child: SizedBox(
            height: 80,
            width: 140,
            child: FloatingActionButton(
              backgroundColor: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CreateEventScreen(
                            myClub: _currentUser as Club,
                          )),
                );
              },
              child: const Text('CREATE EVENT'),
            ),
          ),
        ),
      ),
    );
  }
}
