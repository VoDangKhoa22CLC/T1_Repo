import 'package:flutter/material.dart';
import 'package:lookout_dev/controller/account.dart';

import '../../data/account_class.dart';


class ManageClubsScreen extends StatefulWidget {
  const ManageClubsScreen({super.key});

  @override
  State<ManageClubsScreen> createState() => _ManageClubsScreenState();
}

class _ManageClubsScreenState extends State<ManageClubsScreen> {
  AccountController accountController = AccountController();
  List<Club> _clubs = [];
  List<String> _authored = [];

  void _authorizeClub(BuildContext context, String clubName) {
    // Placeholder function: Replace with actual authorization logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Authorized $clubName successfully!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  String getVerified(Club cl){
    return cl.verified;
  }

  void _getClubs() async {
    List<Club> myClubs = await accountController.getListClubs();
    setState(() {
      _clubs = myClubs;
      _authored = _clubs.map(getVerified).toList();
    });
  }
  @override
  void initState(){
    super.initState();
    _getClubs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Clubs'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Clubs management',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Placeholder list of clubs with an "Authorize" button
            Expanded(
              child: ListView.builder(
                itemCount: _clubs.length, // Placeholder count for clubs
                itemBuilder: (context, index) {
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      leading: const Icon(Icons.group),
                      title: Text(_clubs[index].name),
                      subtitle: const Text('Pending Authorization'),
                      trailing: _authored[index] == "false" ? ElevatedButton(
                        onPressed: () => {
                          _authorizeClub(context, _clubs[index].name),
                          setState(() {
                            _authored[index] = "true";
                          }),
                          accountController.verifyClub(_clubs[index].uid)
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Verify'),
                      ) : ElevatedButton(
                        onPressed: () => {
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey,
                        ),
                        child: const Text('Verified'),
                      )
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
