// lib/models/recommended_slot.dart
class RecommendedSlot {
  final String slot;
  final String sessionId;
  final int capacity; // ⬅️ BARU

  RecommendedSlot({
    required this.slot,
    required this.sessionId,
    required this.capacity,
  });

  factory RecommendedSlot.fromMap(Map<String, dynamic> m) {
    return RecommendedSlot(
      slot: (m['slot'] ?? m['name'] ?? 'Slot').toString(),
      sessionId: (m['session_id'] ?? m['sessionId'] ?? '').toString(),
      capacity: (m['capacity'] ?? 0).toInt(),
    );
  }
}
