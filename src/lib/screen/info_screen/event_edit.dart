import 'package:flutter/material.dart';
import 'package:lookout_dev/template/text_input_decorations.dart';

class EventEditPage extends StatefulWidget {
  final String eventName;
  // This eventName (replace by a eventKey in the future) shall be updated on the server

  const EventEditPage({super.key, required this.eventName});

  @override
  State<EventEditPage> createState() => _EventEditPageState();
}

class _EventEditPageState extends State<EventEditPage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(7, 0, 166, 1),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 20.0),
              TextFormField(
                onChanged: (val) {},
                decoration: textInputDecoration.copyWith(hintText: "Event Name"),
                initialValue: widget.eventName,
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(onPressed: () {}, child: const Text("Save changes"))
            ],
          ),
        ),
      ),
    );
  }
}
