import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aureola_platform/models/menu/menu_availability.dart';
import 'package:aureola_platform/service/localization/localization.dart';

class MenuAvailabilityFields extends StatefulWidget {
  final AvailabilityType initialType;
  final List<String> initialDaysOfWeek;
  final TimeOfDay? initialStartTime;
  final TimeOfDay? initialEndTime;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;
  final Function(AvailabilityType, List<String>, TimeOfDay?, TimeOfDay?,
      DateTime?, DateTime?) onChanged;

  const MenuAvailabilityFields({
    super.key,
    required this.initialType,
    required this.initialDaysOfWeek,
    required this.initialStartTime,
    required this.initialEndTime,
    required this.initialStartDate,
    required this.initialEndDate,
    required this.onChanged,
  });

  @override
  State<MenuAvailabilityFields> createState() => _MenuAvailabilityFieldsState();
}

class _MenuAvailabilityFieldsState extends State<MenuAvailabilityFields> {
  late AvailabilityType _type;
  late List<String> _daysOfWeek;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    _type = widget.initialType;
    _daysOfWeek = [...widget.initialDaysOfWeek];
    _startTime = widget.initialStartTime;
    _endTime = widget.initialEndTime;
    _startDate = widget.initialStartDate;
    _endDate = widget.initialEndDate;
  }

  void _notifyParent() {
    widget.onChanged(
        _type, _daysOfWeek, _startTime, _endTime, _startDate, _endDate);
  }

  // Example: pick a time
  Future<void> _pickTime(BuildContext context, bool isStart) async {
    final initial = isStart
        ? (_startTime ?? const TimeOfDay(hour: 9, minute: 0))
        : (_endTime ?? const TimeOfDay(hour: 17, minute: 0));
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
      _notifyParent();
    }
  }

  // Example: pick a date
  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final initialDate =
        isStart ? (_startDate ?? DateTime.now()) : (_endDate ?? DateTime.now());
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startDate = picked;
        } else {
          _endDate = picked;
        }
      });
      _notifyParent();
    }
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final dt = DateTime(2023, 1, 1, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Replacing DropdownButtonFormField with a Row of Radio Buttons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: AvailabilityType.values.map((type) {
            return Expanded(
              child: InkWell(
                onTap: () {
                  setState(() {
                    _type = type;
                  });
                  _notifyParent();
                },
                child: Column(
                  children: [
                    Text(
                      type.toString().split('.').last.capitalize(),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight:
                            _type == type ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    Radio<AvailabilityType>(
                      activeColor: AppThemeLocal.accent,
                      value: type,
                      groupValue: _type,
                      onChanged: (AvailabilityType? value) {
                        if (value != null) {
                          setState(() {
                            _type = value;
                          });
                          _notifyParent();
                        }
                      },
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        if (_type == AvailabilityType.periodic) ...[
          // Days of week
          const Text('Days of the Week:'),
          MultiSelectChip(
            [
              'Monday',
              'Tuesday',
              'Wednesday',
              'Thursday',
              'Friday',
              'Saturday',
              'Sunday'
            ],
            selectedChoices: _daysOfWeek,
            onSelectionChanged: (selected) {
              setState(() {
                _daysOfWeek = selected;
              });
              _notifyParent();
            },
          ),
          const SizedBox(height: 8),
          // Start/End times
          Row(
            children: [
              Text('Start Time: ${_formatTime(_startTime)}'),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _pickTime(context, true),
                child: const Text('Pick'),
              ),
            ],
          ),
          Row(
            children: [
              Text('End Time: ${_formatTime(_endTime)}'),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _pickTime(context, false),
                child: const Text('Pick'),
              ),
            ],
          ),
        ] else if (_type == AvailabilityType.specific) ...[
          Row(
            children: [
              Text(
                  'Start Date: ${_startDate != null ? DateFormat('MMM d, yyyy').format(_startDate!) : '--/--/----'}'),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _pickDate(context, true),
                child: const Text('Pick'),
              ),
            ],
          ),
          Row(
            children: [
              Text(
                  'End Date: ${_endDate != null ? DateFormat('MMM d, yyyy').format(_endDate!) : '--/--/----'}'),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _pickDate(context, false),
                child: const Text('Pick'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text('Start Time: ${_formatTime(_startTime)}'),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _pickTime(context, true),
                child: const Text('Pick'),
              ),
            ],
          ),
          Row(
            children: [
              Text('End Time: ${_formatTime(_endTime)}'),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _pickTime(context, false),
                child: const Text('Pick'),
              ),
            ],
          ),
        ]
      ],
    );
  }
}

/// A simple widget for multi-select chips
class MultiSelectChip extends StatefulWidget {
  final List<String> options;
  final List<String> selectedChoices;
  final Function(List<String>) onSelectionChanged;

  const MultiSelectChip(
    this.options, {
    super.key,
    required this.selectedChoices,
    required this.onSelectionChanged,
  });

  @override
  _MultiSelectChipState createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  List<String> selectedChoices = [];

  @override
  void initState() {
    super.initState();
    selectedChoices = widget.selectedChoices;
  }

  List<Widget> _buildChoiceList() {
    List<Widget> choices = [];
    widget.options.forEach((item) {
      choices.add(Container(
        padding: const EdgeInsets.all(2.0),
        child: ChoiceChip(
          label: Text(item),
          selected: selectedChoices.contains(item),
          onSelected: (selected) {
            setState(() {
              selected
                  ? selectedChoices.add(item)
                  : selectedChoices.remove(item);
              widget.onSelectionChanged(selectedChoices);
            });
          },
        ),
      ));
    });
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: _buildChoiceList(),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (this.isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
