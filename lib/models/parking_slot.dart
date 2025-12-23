class ParkingSlot {
  final String spaceId;
  final int rowIndex;
  final double width;
  final int capacity;
  final bool canFit;

  ParkingSlot({
    required this.spaceId,
    required this.rowIndex,
    required this.width,
    required this.capacity,
    required this.canFit,
  });

  factory ParkingSlot.fromJson(Map<String, dynamic> json) {
    return ParkingSlot(
      spaceId: json['space_id'],
      rowIndex: json['row_index'],
      width: (json['width'] as num).toDouble(),
      capacity: json['motorcycle_capacity'],
      canFit: json['can_fit_motorcycle'],
    );
  }
}
