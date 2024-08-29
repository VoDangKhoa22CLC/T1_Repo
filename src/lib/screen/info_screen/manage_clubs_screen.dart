import 'package:flutter/material.dart';

class ManageClubsScreen extends StatelessWidget {
  const ManageClubsScreen({super.key});

  // Function to handle club authorization (Placeholder)
  void _authorizeClub(BuildContext context, String clubName) {
    // Placeholder function: Replace with actual authorization logic
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Authorized $clubName successfully!'),
        backgroundColor: Colors.green,
      ),
    );
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
                itemCount: 5, // Placeholder count for clubs
                itemBuilder: (context, index) {
                  String clubName = 'Club ${index + 1}'; // Placeholder club name
                  return Card(
                    margin: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: ListTile(
                      leading: const Icon(Icons.group),
                      title: Text(clubName),
                      subtitle: const Text('Pending Authorization'),
                      trailing: ElevatedButton(
                        onPressed: () => _authorizeClub(context, clubName),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text('Authorize'),
                      ),
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
