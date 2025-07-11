import 'package:flutter/material.dart';
import 'package:vra_asset_track/common/gear.dart';

class GearSelector extends StatefulWidget {
  final ScrollPhysics? physics;
  final bool? shrinkWrap;
  final List<Gear> gearList;
  late List<int> selectedGearIds;
  List<int>? preSelectedIds;
  final ValueChanged<List<Gear>?>? onChanged;

  GearSelector({
    super.key,
    this.physics,
    this.shrinkWrap,
    required this.gearList,
    this.preSelectedIds,
    this.onChanged,
  });

  @override
  State<GearSelector> createState() => _GearSelectorState();
}

class _GearSelectorState extends State<GearSelector> {
  @override
  Widget build(BuildContext context) {
    return widget.gearList.isEmpty
        ? RichText(
            text: TextSpan(
              style: TextStyle(color: Colors.black, fontSize: 18),
              children: [
                TextSpan(
                  text: '     Nothing to track here\n\n',
                  style: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
                ),
              ],
            ),
          )
        : ListView.builder(
            physics: widget.physics,
            shrinkWrap: widget.shrinkWrap ?? false,
            itemCount: widget.gearList.length,
            itemBuilder: (context, index) {
              final Gear aGear = widget.gearList[index];
              return CheckboxListTile(
                title: Text('${aGear.name} (${aGear.id})'),
                value: widget.preSelectedIds!.contains(aGear.id),
                onChanged: (bool? value) =>
                    _handleCheckboxChange(aGear.id, value),
                visualDensity: VisualDensity(horizontal: -4, vertical: -4),
              );
            },
          );
  }

  void _handleCheckboxChange(int gearId, bool? isChecked) {
    setState(() {
      if (isChecked == true) {
        widget.preSelectedIds!.add(gearId);
      } else {
        widget.preSelectedIds!.remove(gearId);
      }
    });
  }
}
