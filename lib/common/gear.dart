// class GearType {
//   final int id;
//   final String name;

//   const GearType({required this.id, required this.name});
// }

enum GearType {
  container,
  rope,
  carabiner,
  acsender,
  decsender,
  progressCapture,
  harness,
  pulley,
  legLoop,
  misc,
  sling,
  na;

  static GearType fromString(String val) {
    return GearType.values.firstWhere(
      (status) => status.name == val.toLowerCase(),
      orElse: () => GearType.na,
    );
  }
}

class Gear {
  final int id;
  final String name;
  final GearType type;
  final String serialNumber;
  final bool trackUsage;
  final int parentId;
  final List<Gear> children;

  const Gear({
    required this.id,
    required this.name,
    required this.type,
    this.serialNumber = '',
    this.trackUsage = false,
    this.parentId = 0,
    this.children = const [],
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is Gear && id == other.id;

  @override
  int get hashCode => id.hashCode;

  factory Gear.fromData(Map<String, dynamic> data) {
    // List<Gear> children = [];
    // if (json['children'] != null) {
    //   var childrenJson = json['children'] as List<dynamic>;
    //   children = childrenJson
    //       .map((childJson) => Gear.fromJson(childJson as Map<String, dynamic>))
    //       .toList();
    // }

    return Gear(
      id: data['id'] as int,
      name: data['name'] as String,
      type: GearType.fromString(data['gear_type'] as String),
      // serialNumber: json['serial_number'] as String? ?? '',
      trackUsage: data['track_usage'] as bool? ?? false,
      parentId: data['parent_id'] as int,
      // children: children,
    );
  }
  // For dev only

  static List<Gear> getGearList() {
    return [
      Gear(id: 10000, name: 'Bag 1', type: GearType.container),
      Gear(id: 20000, name: 'Bag 2', type: GearType.container),
      Gear(id: 30000, name: 'Bag 3', type: GearType.container),
      Gear(id: 40000, name: 'Bag 4', type: GearType.container),
      Gear(id: 50000, name: 'Gear Sling 1', type: GearType.sling),
      Gear(id: 60000, name: 'Box 1', type: GearType.container),
      Gear(id: 60000, name: 'Locker 1', type: GearType.container),
      Gear(id: 10001, name: '50m Rope', type: GearType.rope, parentId: 10000),
      Gear(
        id: 10002,
        name: 'CMC Clutch',
        type: GearType.decsender,
        parentId: 10000,
      ),
      Gear(
        id: 10003,
        name: 'Petzl AMD Carabiner',
        type: GearType.carabiner,
        parentId: 10000,
      ),
      Gear(
        id: 10004,
        name: 'Petzl AMD Carabiner',
        type: GearType.carabiner,
        parentId: 10000,
      ),
      Gear(
        id: 10005,
        name: 'Petzl AMD Carabiner',
        type: GearType.carabiner,
        parentId: 10000,
      ),
      Gear(
        id: 10006,
        name: 'Petzl AMD Carabiner',
        type: GearType.carabiner,
        parentId: 10000,
      ),
      Gear(
        id: 10007,
        name: 'Petzl AMD Carabiner',
        type: GearType.carabiner,
        parentId: 10000,
      ),
      Gear(
        id: 10008,
        name: 'Petzl AMD Carabiner',
        type: GearType.carabiner,
        parentId: 10000,
      ),
      Gear(
        id: 10009,
        name: 'Petzl AMD Carabiner',
        type: GearType.carabiner,
        parentId: 10000,
      ),
      Gear(
        id: 10010,
        name: 'Petzl AMD Carabiner',
        type: GearType.carabiner,
        parentId: 10000,
      ),
      Gear(
        id: 10011,
        name: 'Petzl AMD Carabiner',
        type: GearType.carabiner,
        parentId: 10000,
      ),
      Gear(
        id: 10012,
        name: 'Petzl AMD Carabiner',
        type: GearType.carabiner,
        parentId: 10000,
      ),
      Gear(
        id: 10020,
        name: 'Petzl ID',
        type: GearType.decsender,
        parentId: 10000,
      ),
      Gear(
        id: 10025,
        name: 'Petzl Hand Grab',
        type: GearType.acsender,
        parentId: 10000,
      ),
      Gear(
        id: 10030,
        name: 'Leg Loop',
        type: GearType.legLoop,
        parentId: 10000,
      ),
      Gear(
        id: 10040,
        name: 'Full Body Harness',
        type: GearType.harness,
        parentId: 10000,
      ),
    ];
  }
}
