import 'package:aureola_platform/service/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:aureola_platform/models/menu/menu_availability.dart';
import 'package:aureola_platform/service/localization/localization.dart';



/// - We store canonical day IDs (e.g. "monday") in _daysOfWeek
/// - We display them using AppLocalizations JSON keys (e.g. "day_monday")
class MenuAvailabilityFields extends StatefulWidget {
  final AvailabilityType initialType;
  final List<String> initialDaysOfWeek;
  final TimeOfDay? initialStartTime;
  final TimeOfDay? initialEndTime;
  final DateTime? initialStartDate;
  final DateTime? initialEndDate;

  /// Callback to notify parent when anything changes.
  final Function(
    AvailabilityType, 
    List<String>,    // daysOfWeek
    TimeOfDay?, 
    TimeOfDay?, 
    DateTime?, 
    DateTime?
  ) onChanged;

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

  // Hard-coded canonical day IDs (used in the DB / code).
  // We'll map them to the JSON keys day_monday, day_tuesday, etc.
  final List<String> _dayIds = [
    'monday',
    'tuesday',
    'wednesday',
    'thursday',
    'friday',
    'saturday',
    'sunday',
  ];

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
      _type,
      _daysOfWeek,
      _startTime,
      _endTime,
      _startDate,
      _endDate,
    );
  }

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

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now());

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    //   builder: (BuildContext context, Widget? child) {
    //     return Theme(
    //       data: ThemeData(
    //         colorScheme: AppThemeLocal.colorScheme.copyWith(
    //           primary: AppThemeLocal.primary,
    //           onPrimary: AppThemeLocal.colorScheme.onPrimary,
    //           primaryContainer: AppThemeLocal.colorScheme.primaryContainer,
    //           onPrimaryContainer: AppThemeLocal.colorScheme.onPrimaryContainer,
              
    //         ),
    //         dialogBackgroundColor: AppThemeLocal.background,
    //         textButtonTheme: TextButtonThemeData(
    //           style: AppThemeLocal.cancelButtonStyle,
    //         ),
    //         inputDecorationTheme: AppThemeLocal.inputDecorationTheme ,
    //         // Set the shape with rounded corners
    //         dialogTheme: DialogTheme(
    //           shape: RoundedRectangleBorder(
    //             borderRadius: BorderRadius.circular(12),
    //           ),
    //         ),
    //       ),
    //       child: child!,
    //     );
    //   },
    // );

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

    // Use the current locale from the widget context for date/time format.
    final locale = Localizations.localeOf(context).toString();
    final dt = DateTime(2023, 1, 1, time.hour, time.minute);
    // Example with 24-hour format
    return DateFormat('HH:mm', locale).format(dt);

    // If you want 12-hour format with AM/PM, use:
    // return DateFormat.jm(locale).format(dt);
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '--/--/----';
    final locale = Localizations.localeOf(context).toString();
    return DateFormat('MMM d, yyyy', locale).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Radio Buttons for Availability Type
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: AvailabilityType.values.map((type) {
            // We'll map the enum to localized strings,
            // stored in your JSON as label_always, label_periodic, etc.
            String typeLabel;
            switch (type) {
              case AvailabilityType.always:
                typeLabel = localization.translate('label_always');
                break;
              case AvailabilityType.periodic:
                typeLabel = localization.translate('label_periodic');
                break;
              case AvailabilityType.specific:
                typeLabel = localization.translate('label_specific');
                break;
            }

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
                      typeLabel,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: _type == type
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
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

        // PERIODIC
        if (_type == AvailabilityType.periodic) ...[
          Text(
            localization.translate('label_days_of_week'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          MultiSelectChip(
            options: _dayIds,          // canonical IDs
            selectedChoices: _daysOfWeek,
            onSelectionChanged: (selected) {
              setState(() {
                _daysOfWeek = selected;
              });
              _notifyParent();
            },
            // We'll display the localized label for each ID
            labelBuilder: (dayId) {
              final key = 'day_$dayId'; // e.g. day_monday
              return localization.translate(key);
            },
          ),
          const SizedBox(height: 12),

          // Start/End times
          Row(
            children: [
              // "Start Time: XX:XX"
              Expanded(
                child: Text(
                  '${localization.translate("label_start_time")}: ${_formatTime(_startTime)}',
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _pickTime(context, true),
                child: Text(localization.translate('label_pick')),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${localization.translate("label_end_time")}: ${_formatTime(_endTime)}',
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _pickTime(context, false),
                child: Text(localization.translate('label_pick')),
              ),
            ],
          ),
        ],

        // SPECIFIC
        if (_type == AvailabilityType.specific) ...[
          Row(
            children: [
              Expanded(
                child: Text(
                  '${localization.translate("label_start_date")}: ${_formatDate(_startDate)}',
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _pickDate(context, true),
                child: Text(localization.translate('label_pick')),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${localization.translate("label_end_date")}: ${_formatDate(_endDate)}',
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _pickDate(context, false),
                child: Text(localization.translate('label_pick')),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Optional times for specific date range
          Row(
            children: [
              Expanded(
                child: Text(
                  '${localization.translate("label_start_time")}: ${_formatTime(_startTime)}',
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _pickTime(context, true),
                child: Text(localization.translate('label_pick')),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  '${localization.translate("label_end_time")}: ${_formatTime(_endTime)}',
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton(
                onPressed: () => _pickTime(context, false),
                child: Text(localization.translate('label_pick')),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

/// A more flexible widget for multi-select chips.
/// - [options] are the canonical values (like "monday","tuesday",...).
/// - [selectedChoices] is the subset of [options] that are currently selected.
/// - [labelBuilder] maps each option to a localized, user-friendly label.
class MultiSelectChip extends StatefulWidget {
  final List<String> options;
  final List<String> selectedChoices;
  final Function(List<String>) onSelectionChanged;

  /// Optional builder to convert each option to a display label.
  final String Function(String)? labelBuilder;

  const MultiSelectChip({
    super.key,
    required this.options,
    required this.selectedChoices,
    required this.onSelectionChanged,
    this.labelBuilder,
  });

  @override

  State<MultiSelectChip>
   createState() => _MultiSelectChipState();
}

class _MultiSelectChipState extends State<MultiSelectChip> {
  late List<String> selectedChoices;

  @override
  void initState() {
    super.initState();
    selectedChoices = [...widget.selectedChoices];
  }

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: widget.options.map((optionValue) {
        final isSelected = selectedChoices.contains(optionValue);

        // Convert optionValue to a localized label
        final displayLabel = widget.labelBuilder != null
            ? widget.labelBuilder!(optionValue)
            : optionValue; // fallback

        return Container(
          margin: const EdgeInsets.only(right: 4, bottom: 4),
          child: ChoiceChip(
            label: Text(displayLabel),
            selected: isSelected,
            onSelected: (selected) {
              setState(() {
                if (selected) {
                  selectedChoices.add(optionValue);
                } else {
                  selectedChoices.remove(optionValue);
                }
              });
              widget.onSelectionChanged(selectedChoices);
            },
          ),
        );
      }).toList(),
    );
  }
}

// Just a helper extension to uppercase the first letter if you want it
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}


