import 'package:event_scheduler/components/inputfield.dart';
import 'package:event_scheduler/components/neonbutton.dart';
import 'package:event_scheduler/data/local/db_helper.dart';
import 'package:flutter/material.dart';

class EventCreate extends StatefulWidget {
  const EventCreate({Key? key}) : super(key: key);

  @override
  State<EventCreate> createState() => _EventCreateState();
}

class _EventCreateState extends State<EventCreate> {
  final _formKey = GlobalKey<FormState>();
  final event_title_controller = TextEditingController();
  final event_description_controller = TextEditingController();
  final event_date_controller = TextEditingController();
  final event_time_controller = TextEditingController();
  final event_organizer_controller = TextEditingController();
  final event_location_controller = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  bool _isGroupBased = false;
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate;
        event_date_controller.text =
            "${pickedDate.toLocal()}".split(' ')[0].toString();
      });
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
        final hour = pickedTime.hour.toString().padLeft(2, '0');
        final minute = pickedTime.minute.toString().padLeft(2, '0');
        event_time_controller.text = '$hour:$minute';
      });
    }
  }

  Future<void> _saveEvent() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final dbHelper = DBHelper.instance;
    final success = await dbHelper.insertEvent(
      title: event_title_controller.text.trim(),
      description: event_description_controller.text.trim(),
      date: event_date_controller.text.trim(),
      time: event_time_controller.text.trim(),
      organizer: event_organizer_controller.text.trim(),
      location: event_location_controller.text.trim(),
      isGroupBased: _isGroupBased,
    );

    setState(() {
      _isLoading = false;
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Event created successfully!'),
            backgroundColor: Colors.blueGrey.shade700,
          ),
        );
        // Clear form
        event_title_controller.clear();
        event_description_controller.clear();
        event_date_controller.clear();
        event_time_controller.clear();
        event_organizer_controller.clear();
        event_location_controller.clear();
        _isGroupBased = false;
        _selectedDate = null;
        _selectedTime = null;
      } else {
        _errorMessage = 'Failed to create event. Please try again.';
      }
    });
  }

  @override
  void dispose() {
    event_title_controller.dispose();
    event_description_controller.dispose();
    event_date_controller.dispose();
    event_time_controller.dispose();
    event_organizer_controller.dispose();
    event_location_controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Event",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade900,
        iconTheme: const IconThemeData(color: Colors.white, size: 35),
      ),
      body: Container(
        color: Colors.blueGrey.shade900,
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              height: 650, // Increased height to accommodate new field
              padding: const EdgeInsets.all(14),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade800,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildInputField(
                      Icons.event,
                      "Event Name",
                      event_title_controller,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an event name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 17),
                    buildInputField(
                      Icons.description,
                      "Event Description",
                      event_description_controller,
                    ),
                    const SizedBox(height: 17),
                    GestureDetector(
                      onTap: () => _pickDate(context),
                      child: AbsorbPointer(
                        child: buildInputField(
                          Icons.calendar_today_outlined,
                          "Event Date",
                          event_date_controller,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please select a date';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 17),
                    GestureDetector(
                      onTap: () => _pickTime(context),
                      child: AbsorbPointer(
                        child: buildInputField(
                          Icons.timer_outlined,
                          "Event Time",
                          event_time_controller,
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Please select a time';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 17),
                    buildInputField(
                      Icons.person,
                      "Event Organizer",
                      event_organizer_controller,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an organizer';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 17),
                    buildInputField(
                      Icons.location_city,
                      "Location",
                      event_location_controller,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a location';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 17),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Group-Based Event",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        const SizedBox(width: 10),
                        Switch(
                          value: _isGroupBased,
                          onChanged: (value) {
                            setState(() {
                              _isGroupBased = value;
                            });
                          },
                          activeColor: Colors.blueGrey.shade400,
                        ),
                      ],
                    ),
                    if (_errorMessage != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : neonButton("Add Event", _saveEvent),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
