import 'package:event_scheduler/components/inputfield.dart';
import 'package:event_scheduler/components/neonbutton.dart';
import 'package:flutter/material.dart';

class EventCreate extends StatefulWidget {
  @override
  State<EventCreate> createState() => _EventCreateState();
}

class _EventCreateState extends State<EventCreate> {
  final event_name_controller = TextEditingController();

  final event_description_controller = TextEditingController();

  final event_date_controller = TextEditingController();

  final event_time_controller = TextEditingController();

  final event_organizer_controller = TextEditingController();

  final event_location_controller = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

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
        event_date_controller.text = "${pickedDate.toLocal()}".split(' ')[0].toString();
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
        final hour = pickedTime.hour.toString().padLeft(2, '0');
        final minute = pickedTime.minute.toString().padLeft(2, '0');
        _selectedTime = pickedTime;
        event_time_controller.text = '$hour:$minute';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Event",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueGrey.shade900,
        iconTheme: IconThemeData(color: Colors.white, size: 35),
      ),
      body: Container(
        color: Colors.blueGrey.shade900,
        child: Center(
          child: Container(
            height: 700,
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.blueGrey.shade800,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildInputField(
                  Icons.event,
                  "Event Name",
                  event_name_controller,
                ),
                SizedBox(height: 17),
                buildInputField(
                  Icons.description,
                  "Event Description",
                  event_description_controller,
                ),
                SizedBox(height: 17),
                GestureDetector(
                  onTap: () => _pickDate(context),
                  child: AbsorbPointer(
                    child: buildInputField(
                      Icons.calendar_today_outlined,
                      "Event Date",
                      event_date_controller,
                    ),
                  ),
                ),
                SizedBox(height: 17),
                GestureDetector(
                  onTap: () => _pickTime(context),
                  child: AbsorbPointer(
                    child: buildInputField(
                      Icons.timer_outlined,
                      "Event Time",
                      event_time_controller,
                    ),
                  ),
                ),
                SizedBox(height: 17),

                buildInputField(
                  Icons.person,
                  "Event Organizer",
                  event_organizer_controller,
                ),
                SizedBox(height: 17),

                buildInputField(
                  Icons.location_city,
                  "Location",
                  event_location_controller,
                ),
                SizedBox(height: 35),
                neonButton("Add Event", (){

                }),
              ],
            ),
          ),
        ),
      ),
    );
  }

}
