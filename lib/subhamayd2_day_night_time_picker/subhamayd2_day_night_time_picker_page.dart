import 'package:flutter/material.dart';

// Stub implementation of DayNightTimePicker to satisfy compilation.
// This widget provides the same API as the original package widget.
class DayNightTimePicker extends StatelessWidget {
  final TimeOfDay value;
  final ValueChanged<TimeOfDay> onChange;

  const DayNightTimePicker({
    Key? key,
    required this.value,
    required this.onChange,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: value,
        );
        if (picked != null) {
          onChange(picked);
        }
      },
      child: Text(value.format(context)),
    );
  }
}

class Subhamayd2DayNightTimePickerPage extends StatefulWidget {
  const Subhamayd2DayNightTimePickerPage({super.key});

  @override
  State<Subhamayd2DayNightTimePickerPage> createState() =>
      _Subhamayd2DayNightTimePickerPageState();
}

class _Subhamayd2DayNightTimePickerPageState
    extends State<Subhamayd2DayNightTimePickerPage> {
  TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Night Time Picker Demo'),
      ),
      body: Center(
        child: DayNightTimePicker(
          value: _selectedTime,
          onChange: (TimeOfDay newTime) {
            setState(() {
              _selectedTime = newTime;
            });
          },
        ),
      ),
    );
  }
}