import 'package:flutter/material.dart';
import 'package:vra_asset_track/common/activity.dart';

class ActivityDropdown extends StatefulWidget {
  final String label;
  final String hint;
  final List<Activity> avavilableActivity;
  final ValueChanged<Activity?>? onChanged;

  const ActivityDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.avavilableActivity,
    this.onChanged,
  });

  @override
  State<ActivityDropdown> createState() => _ActivityDropdownState();
}

class _ActivityDropdownState extends State<ActivityDropdown> {
  Activity? selectedActivity;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          // width: 100, // Fixed width for label column
          child: Text(widget.label),
        ),
        SizedBox(width: 10),
        Expanded(
          child: DropdownButton<Activity>(
            value: selectedActivity,
            hint: Text(widget.hint),
            isExpanded: true,
            items: widget.avavilableActivity.map((item) {
              return DropdownMenuItem<Activity>(
                value: item,
                child: Text(item.name),
              );
            }).toList(),
            onChanged: (newValue) {
              if (newValue != null) {
                setState(() => selectedActivity = newValue);
                widget.onChanged?.call(newValue);
              }
            },
          ),
        ),
      ],
    );
  }
}

class ActivityListSelector extends StatefulWidget {
  final String? label;
  final List<Activity> avavilableActivity;
  final ValueChanged<List<Activity>?>? onChanged;

  const ActivityListSelector({
    super.key,
    this.label,
    required this.avavilableActivity,
    this.onChanged,
  });

  @override
  State<ActivityListSelector> createState() => _ActivityListSelectorState();
}

class _ActivityListSelectorState extends State<ActivityListSelector> {
  final List<Activity> selection = [];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: widget.avavilableActivity.isEmpty
          ? Text('No tasks')
          : ListView.builder(
              itemCount: widget.avavilableActivity.length,
              itemBuilder: (context, index) {
                final item = widget.avavilableActivity[index];

                return CheckboxListTile(
                  title: Text(item.name),
                  // value: selectedIds.contains(item.id),
                  value: selection.contains(item),
                  onChanged: (bool? value) {
                    setState(() {
                      if (value == true) {
                        selection.add(item);
                      } else {
                        selection.remove(item);
                      }
                      widget.onChanged?.call(selection);
                    });
                  },
                  visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                );
              },
            ),
    );
  }
}
