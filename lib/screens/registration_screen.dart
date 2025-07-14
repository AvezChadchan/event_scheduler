import 'package:event_scheduler/data/local/db_helper.dart';
import 'package:event_scheduler/models/event_model.dart';
import 'package:flutter/material.dart';

class EventRegistration extends StatefulWidget {
  @override
  State<EventRegistration> createState() => _EventRegistrationState();
}

class _EventRegistrationState extends State<EventRegistration> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _groupNameController = TextEditingController();
  final _groupMembersController = TextEditingController();

  EventModel? _selectedEvent;
  List<EventModel> _events = [];
  bool isLoading = true;
  bool isGroupEvent = false;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
  }

  Future<void> _fetchEvents() async {
    final events = await DBHelper.instance.getAllEvents();
    setState(() {
      _events = events;
      isLoading = false;
    });
  }

  Future<void> _registerParticipant() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedEvent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select an event"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final success = await DBHelper.instance.insertParticipant(
      name: _nameController.text.trim(),
      eventId: _selectedEvent!.id!,
      email: _emailController.text.trim(),
      groupName: isGroupEvent ? _groupNameController.text.trim() : null,
      groupMembers: isGroupEvent ? _groupMembersController.text.trim() : null,
    );

    if (success) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Registration Successful")));
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _groupNameController.clear();
      _groupMembersController.clear();
      setState(() => _selectedEvent = null);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration Failed! Please try again")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Register",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade900,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 30),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      DropdownButtonFormField<EventModel>(
                        value: _selectedEvent,
                        hint: Text("Select Event"),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        items:
                            _events.map((e) {
                              return DropdownMenuItem<EventModel>(
                                value: e,
                                child: Text(e.title),
                              );
                            }).toList(),
                        onChanged: (value) {
                          setState(() => _selectedEvent = value);
                        },
                        validator:
                            (value) =>
                                value == null ? 'Please select an event' : null,
                      ),
                      const SizedBox(height: 16),
                      customTextFormField(
                        controller: _nameController,
                        hintText: "Enter Name",
                        labelText: "Name",
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 16),
                      customTextFormField(
                        controller: _emailController,
                        hintText: "Enter Email",
                        labelText: "Email",
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 16),
                      SwitchListTile(
                        value: isGroupEvent,
                        title: Text(
                          isGroupEvent
                              ? "This is a Group-Based Event"
                              : "This is an Individual Event",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        onChanged: null,
                      ),

                      if (isGroupEvent) ...[
                        SizedBox(height: 16),
                        customTextFormField(
                          controller: _groupNameController,
                          hintText: "Enter Group Name",
                          labelText: "Group Name",
                          keyboardType: TextInputType.name,
                        ),
                        SizedBox(height: 16),
                        customTextFormField(
                          controller: _groupMembersController,
                          hintText: "Enter Group Members",
                          labelText: "Group Members",
                        ),
                      ],
                      SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: _registerParticipant,
                        icon: Icon(Icons.check),
                        label: Text("Register"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueGrey.shade800,
                          padding: EdgeInsets.symmetric(vertical: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }

  Widget customTextFormField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    String? Function(String?)? validator,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: const OutlineInputBorder(),
      ),
      validator:
          validator ??
          (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter $labelText';
            }
            return null;
          },
    );
  }
}
