import 'package:flutter/material.dart';

class UserScreen extends StatefulWidget {
  final String userName;
  const UserScreen({super.key, required this.userName});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const FittedBox(
          fit: BoxFit.fitWidth,
          child: Text('User'),
        ),
        backgroundColor: const Color.fromRGBO(7, 0, 166, 1),
        elevation: 0,
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.settings),
            iconSize: 40,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Align(
          alignment: Alignment.topLeft,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text(
                "User Info:",
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Card(
                margin: const EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0),
                child: ListTile(
                  leading: const Icon(
                    Icons.supervised_user_circle_outlined,
                    color: Colors.black,
                    size: 40,
                  ),
                  title: Text(widget.userName),
                  subtitle: const Text("user_email@example.mail.com"),
                ),
              ),
              Card(
                color: Colors.blueGrey[80],
                margin: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.perm_contact_cal_sharp),
                        label: const Text(
                            "Manage Account",
                            style: TextStyle(
                              fontSize: 15,
                            )
                        ),
                      ),
                      Divider(
                        color: Colors.blueGrey[80],
                        thickness: 2,
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.grid_4x4_sharp),
                        label: const Text(
                            "Manage Events",
                            style: TextStyle(
                              fontSize: 14,
                            )
                        ),
                      ),
                      Divider(
                        color: Colors.blueGrey[80],
                        thickness: 2,
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.notifications),
                        label: const Text(
                            "Notifications",
                            style: TextStyle(
                              fontSize: 15,
                            )
                        ),
                      ),
                      Divider(
                        color: Colors.blueGrey[80],
                        thickness: 2,
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.density_medium_rounded),
                        label: const Text(
                            "About the App",
                            style: TextStyle(
                              fontSize: 15,
                            )
                        ),
                      ),
                      Divider(
                        color: Colors.blueGrey[80],
                        thickness: 2,
                      ),
                      TextButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.label),
                        label: const Text(
                            "Placeholder button",
                            style: TextStyle(
                              fontSize: 15,
                            )
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
