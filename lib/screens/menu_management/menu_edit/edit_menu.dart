import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:aureola_platform/service/localization/localization.dart';
import 'package:aureola_platform/service/theme/theme.dart';
import 'package:aureola_platform/models/menu/menu_model.dart';
import 'package:aureola_platform/models/menu/menu_availability.dart';

class EditMenuDialog extends StatefulWidget {
  final MenuModel menu;
  final Function(MenuModel) onSave;

  const EditMenuDialog({
    super.key,
    required this.menu,
    required this.onSave,
  });

  @override
  _EditMenuDialogState createState() => _EditMenuDialogState();
}

class _EditMenuDialogState extends State<EditMenuDialog> {
  final _formKey = GlobalKey<FormState>();

  // Controllers for multilingual fields
  late TextEditingController _menuNameEnController;
  late TextEditingController _menuNameArController;
  late TextEditingController _descriptionEnController;
  late TextEditingController _descriptionArController;
  late TextEditingController _notesEnController;
  late TextEditingController _notesArController;

  // Image URLs
  late TextEditingController _imageUrlController;
  late TextEditingController _additionalImage1Controller;
  late TextEditingController _additionalImage2Controller;

  // Visibility toggles
  bool _isActive = false;
  bool _isOnline = false;
  bool _visibleOnTablet = false;
  bool _visibleOnQr = false;
  bool _visibleOnPickup = false;
  bool _visibleOnDelivery = false;

  // Availability fields
  AvailabilityType? _availabilityType;
  List<String> _selectedDays = [];
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  DateTime? _startDate;
  DateTime? _endDate;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing menu data
    _menuNameEnController =
        TextEditingController(text: widget.menu.menuName['en'] ?? '');
    _menuNameArController =
        TextEditingController(text: widget.menu.menuName['ar'] ?? '');
    _descriptionEnController =
        TextEditingController(text: widget.menu.description['en'] ?? '');
    _descriptionArController =
        TextEditingController(text: widget.menu.description['ar'] ?? '');
    _notesEnController =
        TextEditingController(text: widget.menu.notes['en'] ?? '');
    _notesArController =
        TextEditingController(text: widget.menu.notes['ar'] ?? '');

    _imageUrlController =
        TextEditingController(text: widget.menu.imageUrl ?? '');

    _isOnline = widget.menu.isOnline;
    _visibleOnTablet = widget.menu.visibleOnTablet;
    _visibleOnQr = widget.menu.visibleOnQr;
    _visibleOnPickup = widget.menu.visibleOnPickup;
    _visibleOnDelivery = widget.menu.visibleOnDelivery;

    // Initialize availability
    if (widget.menu.availability != null) {
      _availabilityType = widget.menu.availability!.type;
      _selectedDays = widget.menu.availability!.daysOfWeek;
      _startTime = widget.menu.availability!.startTime != null
          ? _parseTime(widget.menu.availability!.startTime!)
          : null;
      _endTime = widget.menu.availability!.endTime != null
          ? _parseTime(widget.menu.availability!.endTime!)
          : null;
      _startDate = widget.menu.availability!.startDate;
      _endDate = widget.menu.availability!.endDate;
    } else {
      _availabilityType = AvailabilityType.always;
    }
  }

  @override
  void dispose() {
    _menuNameEnController.dispose();
    _menuNameArController.dispose();
    _descriptionEnController.dispose();
    _descriptionArController.dispose();
    _notesEnController.dispose();
    _notesArController.dispose();
    _imageUrlController.dispose();
    _additionalImage1Controller.dispose();
    _additionalImage2Controller.dispose();
    super.dispose();
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay? time) {
    if (time == null) return '--:--';
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return DateFormat('HH:mm').format(dt);
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final initialTime = isStart
        ? (_startTime ?? TimeOfDay(hour: 9, minute: 0))
        : (_endTime ?? TimeOfDay(hour: 17, minute: 0));
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _selectDate(BuildContext context, bool isStart) async {
    final initialDate = isStart
        ? (_startDate ?? DateTime.now())
        : (_endDate ?? DateTime.now().add(Duration(days: 7)));
    final DateTime? picked = await showDatePicker(
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
    }
  }

  void _saveMenu() {
    if (_formKey.currentState!.validate()) {
      // Construct the MenuName, Description, and Notes maps
      final menuName = {
        'en': _menuNameEnController.text,
        'ar': _menuNameArController.text,
      };
      final description = {
        'en': _descriptionEnController.text,
        'ar': _descriptionArController.text,
      };
      final notes = {
        'en': _notesEnController.text,
        'ar': _notesArController.text,
      };

      // Construct additionalImages list
      List<String> additionalImages = [];
      if (_additionalImage1Controller.text.isNotEmpty) {
        additionalImages.add(_additionalImage1Controller.text);
      }
      if (_additionalImage2Controller.text.isNotEmpty) {
        additionalImages.add(_additionalImage2Controller.text);
      }

      // Construct the Availability object
      MenuAvailability? availability;
      if (_availabilityType != null) {
        availability = MenuAvailability(
          type: _availabilityType!,
          daysOfWeek: _availabilityType == AvailabilityType.periodic
              ? _selectedDays
              : [],
          startTime: _startTime != null ? _formatTime(_startTime!) : null,
          endTime: _endTime != null ? _formatTime(_endTime!) : null,
          startDate: _availabilityType == AvailabilityType.specific
              ? _startDate
              : null,
          endDate:
              _availabilityType == AvailabilityType.specific ? _endDate : null,
        );
      }

      // Create a new MenuModel with updated values
      MenuModel updatedMenu = widget.menu.copyWith(
        menuName: menuName,
        description: description,
        notes: notes,
        imageUrl: _imageUrlController.text.isNotEmpty
            ? _imageUrlController.text
            : null,
        additionalImages: additionalImages,
        isActive: _isActive,
        isOnline: _isOnline,
        visibleOnTablet: _visibleOnTablet,
        visibleOnQr: _visibleOnQr,
        visibleOnPickup: _visibleOnPickup,
        visibleOnDelivery: _visibleOnDelivery,
        availability: availability,
        updatedAt: DateTime.now(),
        // Note: Sections and settings can be handled similarly or left as TODO
      );

      widget.onSave(updatedMenu);
      Navigator.of(context).pop(); // Close the dialog
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Center(
          child: Text(AppLocalizations.of(context)!.translate('Edit_Menu'))),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Menu Name - English
              TextFormField(
                controller: _menuNameEnController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .translate('Menu Name (English)'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate('Please enter menu name in English');
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              // Menu Name - Arabic
              TextFormField(
                controller: _menuNameArController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .translate('Menu Name (Arabic)'),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate('Please enter menu name in Arabic');
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Description - English
              TextFormField(
                controller: _descriptionEnController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .translate('Description (English)'),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate('Please enter description in English');
                  }
                  return null;
                },
              ),
              SizedBox(height: 8),
              // Description - Arabic
              TextFormField(
                controller: _descriptionArController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .translate('Description (Arabic)'),
                ),
                maxLines: 2,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return AppLocalizations.of(context)!
                        .translate('Please enter description in Arabic');
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Notes - English
              TextFormField(
                controller: _notesEnController,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .translate('Notes (English)'),
                ),
                maxLines: 2,
              ),
              SizedBox(height: 8),
              // Notes - Arabic
              TextFormField(
                controller: _notesArController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.translate('Notes (Arabic)'),
                ),
                maxLines: 2,
              ),

              SizedBox(height: 16),

              // Image URL
              TextFormField(
                controller: _imageUrlController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.translate('Image URL'),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.isAbsolute) {
                      return AppLocalizations.of(context)!
                          .translate('Please enter a valid URL');
                    }
                  }
                  return null;
                },
              ),

              SizedBox(height: 8),

              // Additional Image 1
              TextFormField(
                controller: _additionalImage1Controller,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .translate('Additional Image URL 1'),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.isAbsolute) {
                      return AppLocalizations.of(context)!
                          .translate('Please enter a valid URL');
                    }
                  }
                  return null;
                },
              ),

              SizedBox(height: 8),

              // Additional Image 2
              TextFormField(
                controller: _additionalImage2Controller,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!
                      .translate('Additional Image URL 2'),
                ),
                keyboardType: TextInputType.url,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    final uri = Uri.tryParse(value);
                    if (uri == null || !uri.isAbsolute) {
                      return AppLocalizations.of(context)!
                          .translate('Please enter a valid URL');
                    }
                  }
                  return null;
                },
              ),

              SizedBox(height: 16),

              // Availability Type
              DropdownButtonFormField<AvailabilityType>(
                value: _availabilityType,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)!.translate('Availability'),
                ),
                items: AvailabilityType.values.map((AvailabilityType type) {
                  return DropdownMenuItem<AvailabilityType>(
                    value: type,
                    child: Text(type.toString().split('.').last.capitalize()),
                  );
                }).toList(),
                onChanged: (AvailabilityType? newValue) {
                  setState(() {
                    _availabilityType = newValue;
                  });
                },
              ),

              SizedBox(height: 16),

              // Conditional Fields Based on AvailabilityType
              if (_availabilityType == AvailabilityType.periodic) ...[
                // Days of the week
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    AppLocalizations.of(context)!.translate('Days of the Week'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
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
                  selectedChoices: _selectedDays,
                  onSelectionChanged: (selected) {
                    setState(() {
                      _selectedDays = selected;
                    });
                  },
                ),
                SizedBox(height: 16),
                // Start Time
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${AppLocalizations.of(context)!.translate('Start Time')}: ${_formatTime(_startTime)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectTime(context, true),
                      child: Text(
                          AppLocalizations.of(context)!.translate('Select')),
                    ),
                  ],
                ),
                // End Time
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${AppLocalizations.of(context)!.translate('End Time')}: ${_formatTime(_endTime)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectTime(context, false),
                      child: Text(
                          AppLocalizations.of(context)!.translate('Select')),
                    ),
                  ],
                ),
              ] else if (_availabilityType == AvailabilityType.specific) ...[
                // Start Date
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${AppLocalizations.of(context)!.translate('Start Date')}: ${_startDate != null ? DateFormat('MMM d, yyyy').format(_startDate!) : '--/--/----'}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context, true),
                      child: Text(
                          AppLocalizations.of(context)!.translate('Select')),
                    ),
                  ],
                ),
                // End Date
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${AppLocalizations.of(context)!.translate('End Date')}: ${_endDate != null ? DateFormat('MMM d, yyyy').format(_endDate!) : '--/--/----'}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectDate(context, false),
                      child: Text(
                          AppLocalizations.of(context)!.translate('Select')),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                // Start Time
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${AppLocalizations.of(context)!.translate('Start Time')}: ${_formatTime(_startTime)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectTime(context, true),
                      child: Text(
                          AppLocalizations.of(context)!.translate('Select')),
                    ),
                  ],
                ),
                // End Time
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${AppLocalizations.of(context)!.translate('End Time')}: ${_formatTime(_endTime)}',
                      ),
                    ),
                    TextButton(
                      onPressed: () => _selectTime(context, false),
                      child: Text(
                          AppLocalizations.of(context)!.translate('Select')),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 16),

              // Visibility Toggles
              SwitchListTile(
                title:
                    Text(AppLocalizations.of(context)!.translate('Is Active')),
                value: _isActive,
                onChanged: (bool value) {
                  setState(() {
                    _isActive = value;
                  });
                },
              ),
              SwitchListTile(
                title:
                    Text(AppLocalizations.of(context)!.translate('Is Online')),
                value: _isOnline,
                onChanged: (bool value) {
                  setState(() {
                    _isOnline = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!
                    .translate('Visible on Tablet')),
                value: _visibleOnTablet,
                onChanged: (bool value) {
                  setState(() {
                    _visibleOnTablet = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text(
                    AppLocalizations.of(context)!.translate('Visible on QR')),
                value: _visibleOnQr,
                onChanged: (bool value) {
                  setState(() {
                    _visibleOnQr = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!
                    .translate('Visible on Pickup')),
                value: _visibleOnPickup,
                onChanged: (bool value) {
                  setState(() {
                    _visibleOnPickup = value;
                  });
                },
              ),
              SwitchListTile(
                title: Text(AppLocalizations.of(context)!
                    .translate('Visible on Delivery')),
                value: _visibleOnDelivery,
                onChanged: (bool value) {
                  setState(() {
                    _visibleOnDelivery = value;
                  });
                },
              ),

              SizedBox(height: 16),

              // TODO: Handle Sections and Settings
              // You can add widgets here to edit sections and settings as needed.
              // For example, a button to navigate to a separate sections editor.
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.translate('Cancel')),
        ),
        ElevatedButton(
          onPressed: _saveMenu,
          child: Text(AppLocalizations.of(context)!.translate('Save')),
        ),
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
    Key? key,
    required this.selectedChoices,
    required this.onSelectionChanged,
  }) : super(key: key);

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
