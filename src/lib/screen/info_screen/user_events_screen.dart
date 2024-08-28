import 'package:flutter/material.dart';

class UserEventsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Placeholder
    final events = [
      {'name': 'Event 1', 'time': '10:00 AM'},
      {'name': 'Event 2', 'time': '2:00 PM'},
      {'name': 'Event 3', 'time': '6:00 PM'},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Events'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          return ListTile(
            title: Text(event['name']!),
            subtitle: Text(event['time']!),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    // Placeholder
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Placeholder
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Deleted ${event['name']}')),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
