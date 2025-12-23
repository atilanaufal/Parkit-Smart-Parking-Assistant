import 'package:get/get.dart';
import 'package:flutter/foundation.dart';
import '../../../services/parking_service.dart';
import 'parking_location_controller.dart';
import 'package:parkit_smart_parking_assistant/models/recommended_slot.dart';

class ParkingSlotController extends GetxController {
  /// =============================
  /// STATE
  /// =============================
  final isLoading = false.obs;
  final sessionId = ''.obs;

  /// jumlah SLOT (bukan motor)
  final totalMotor = 0.obs; // slot terisi penuh
  final totalEmpty = 0.obs; // slot kosong

  final occupancyRate = 0.0.obs;

  final motorPerRow = <String, int>{}.obs;
  final kapasitasKosongPerRow = <String, int>{}.obs;

  /// row -> list slot kosong
  final RxMap<String, List<Map<String, dynamic>>> posisiKosongPerRow =
      <String, List<Map<String, dynamic>>>{}.obs;

  /// row -> set slot_label yang TERPAKAI
  /// row -> set slot TERISI (dari motor_id)
  final RxMap<String, Set<int>> occupiedSlotNumbersPerRow =
      <String, Set<int>>{}.obs;

  final totalSlotPerRow = <String, Map<String, int>>{}.obs;

  /// data siap pakai UI
  final RxList<Map<String, dynamic>> slotData = <Map<String, dynamic>>[].obs;

  /// =============================
  /// LIFECYCLE
  /// =============================
  @override
  void onInit() {
    super.onInit();
    debugPrint("🔥 ParkingSlotController INIT");
    loadLatestSession();
  }

  /// =============================
  /// LOAD DATA
  /// =============================
  Future<void> loadLatestSession() async {
    try {
      isLoading.value = true;

      sessionId.value = await ParkingService.getLatestSessionId();
      final data = await ParkingService.getResult(sessionId.value);
      final bestFrame = data['best_frame'] ?? {};

      totalMotor.value =
          (data['total_motorcycles'] ?? bestFrame['total_motorcycles'] ?? 0)
              .toInt();

      totalEmpty.value =
          (data['total_empty_spaces'] ?? bestFrame['total_empty_spaces'] ?? 0)
              .toInt();

      occupancyRate.value =
          (data['parking_occupancy_rate'] ??
                  bestFrame['parking_occupancy_rate'] ??
                  0)
              .toDouble();

      _processEmptySpaces(data, bestFrame);
      _processOccupiedSlotsFromMotorId(data);
      rebuildSlotData();
      _processMotorPerRow(data);
      _buildTotalPerRow();
      debugPrint("=== SESSION DATA KEYS ===");
      debugPrint(data.keys.toString());

      if (data['motors'] != null) {
        debugPrint("motors@root = ${data['motors'].length}");
      }
      if (data['best_frame']?['motors'] != null) {
        debugPrint(
          "motors@best_frame = ${data['best_frame']['motors'].length}",
        );
      }
      if (data['parking_analysis']?['detections'] != null) {
        debugPrint(
          "detections = ${data['parking_analysis']['detections'].length}",
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// =============================
  /// SLOT LABEL
  /// =============================
  String extractSlotLabel(dynamic spaceId) {
    if (spaceId == null) return '-';
    final str = spaceId.toString();
    return RegExp(r'space_?(\d+)$').firstMatch(str)?.group(1) ??
        RegExp(r'(\d+)$').firstMatch(str)?.group(1) ??
        str;
  }

  /// =============================
  /// EMPTY SPACES
  /// =============================
  void _processEmptySpaces(Map<String, dynamic> data, Map bestFrame) {
    posisiKosongPerRow.clear();
    kapasitasKosongPerRow.clear();

    final List emptySpaces =
        data['empty_spaces'] ?? bestFrame['empty_spaces'] ?? [];

    for (final space in emptySpaces) {
      final row = (space['row_index'] ?? 0).toString();
      final int capacity = (space['motorcycle_capacity'] as num?)?.toInt() ?? 0;

      posisiKosongPerRow.putIfAbsent(row, () => []);
      kapasitasKosongPerRow[row] = (kapasitasKosongPerRow[row] ?? 0) + capacity;

      posisiKosongPerRow[row]!.add({
        'space_id': space['space_id'],
        'motorcycle_capacity': capacity,
        'x1': (space['x1'] ?? 0).toDouble(),
        'x2': (space['x2'] ?? 0).toDouble(),
        'y1': (space['y1'] ?? 0).toDouble(),
        'y2': (space['y2'] ?? 0).toDouble(),
      });
    }
  }

  /// =============================
  /// DERIVED UI DATA
  /// =============================
  void rebuildSlotData() {
    final List<Map<String, dynamic>> data = [];

    posisiKosongPerRow.forEach((row, slots) {
      for (final s in slots) {
        data.add({
          'row': row,
          'space_id': s['space_id'],
          'slot_label': extractSlotLabel(s['space_id']),
          'capacity': s['motorcycle_capacity'],
          'x1': s['x1'],
          'x2': s['x2'],
          'y1': s['y1'],
          'y2': s['y2'],
        });
      }
    });

    slotData.value = data;
  }

  List<String> get availableRows =>
      posisiKosongPerRow.keys.toList()
        ..sort((a, b) => int.parse(a).compareTo(int.parse(b)));

  /// =============================
  /// USE SLOT
  /// return TRUE jika slot HABIS (capacity jadi 0)
  /// =============================
  bool useSlot({required String row, required String spaceId}) {
    final updated = Map<String, List<Map<String, dynamic>>>.from(
      posisiKosongPerRow,
    );

    final slots = List<Map<String, dynamic>>.from(updated[row] ?? []);
    final index = slots.indexWhere((s) => s['space_id'] == spaceId);
    if (index == -1) return false;

    final slot = Map<String, dynamic>.from(slots[index]);
    final int capacity = slot['motorcycle_capacity'] ?? 1;

    if (capacity > 1) {
      // ❗ tidak mengubah counter
      slot['motorcycle_capacity'] = capacity - 1;
      slots[index] = slot;
      updated[row] = slots;
      posisiKosongPerRow.value = updated;
      rebuildSlotData();
      return false;
    }

    // 🔴 capacity == 1 → slot HABIS
    slots.removeAt(index);
    updated[row] = slots;
    posisiKosongPerRow.value = updated;

    totalMotor.value += 1;
    totalEmpty.value -= 1;

    rebuildSlotData();
    return true;
  }

  /// =============================
  /// RELEASE SLOT
  /// =============================
  void releaseSlot({
    required String row,
    required String spaceId,
    required bool wasExhausted,
  }) {
    final updated = Map<String, List<Map<String, dynamic>>>.from(
      posisiKosongPerRow,
    );

    final slots = List<Map<String, dynamic>>.from(updated[row] ?? []);
    final index = slots.indexWhere((s) => s['space_id'] == spaceId);

    if (index != -1) {
      // slot masih ada → tambah kapasitas
      final slot = Map<String, dynamic>.from(slots[index]);
      slot['motorcycle_capacity'] = (slot['motorcycle_capacity'] ?? 1) + 1;
      slots[index] = slot;
    } else {
      // slot sebelumnya HABIS → buat ulang
      slots.add({'space_id': spaceId, 'motorcycle_capacity': 1});

      if (wasExhausted) {
        totalMotor.value -= 1;
        totalEmpty.value += 1;
      }
    }

    updated[row] = slots;
    posisiKosongPerRow.value = updated;
    rebuildSlotData();
  }

  /// =============================
  /// SWITCH SLOT
  /// =============================
  void switchSlot({
    required String newRow,
    required String newSpaceId,
    required ParkingLocationController location,
  }) {
    if (location.isParked.value &&
        location.usedRow != null &&
        location.usedSpaceId != null) {
      releaseSlot(
        row: location.usedRow!,
        spaceId: location.usedSpaceId!,
        wasExhausted: location.lastSlotWasExhausted,
      );
    }

    final exhausted = useSlot(row: newRow, spaceId: newSpaceId);

    location.lastSlotWasExhausted = exhausted;
  }

  /// =============================
  /// MOTOR PER ROW
  /// =============================
  void _processMotorPerRow(Map<String, dynamic> data) {
    motorPerRow.clear();
    final detections = data['parking_analysis']?['detections'];
    if (detections == null) return;

    for (final d in detections) {
      final row = d['assigned_row'];
      if (row != null) {
        motorPerRow[row.toString()] = (motorPerRow[row.toString()] ?? 0) + 1;
      }
    }
  }

  void _buildTotalPerRow() {
    totalSlotPerRow.clear();
    final rows = {...motorPerRow.keys, ...kapasitasKosongPerRow.keys};

    for (final r in rows) {
      final motor = motorPerRow[r] ?? 0;
      final kosong = kapasitasKosongPerRow[r] ?? 0;
      totalSlotPerRow[r] = {
        'motor': motor,
        'kosong': kosong,
        'total': motor + kosong,
      };
    }
  }

  /// =============================
  /// RECOMMENDED SLOTS
  /// berdasarkan kapasitas terbesar
  /// =============================
  List<RecommendedSlot> getRecommendedSlots({int limit = 5}) {
    final slots = List<Map<String, dynamic>>.from(slotData);

    if (slots.isEmpty) return [];

    // urutkan kapasitas DESC
    slots.sort(
      (a, b) => (b['capacity'] as int).compareTo(a['capacity'] as int),
    );

    return slots.take(limit).map((s) {
      return RecommendedSlot(
        slot: "Baris ${s['row']} - Slot ${s['slot_label']}",
        capacity: s['capacity'] as int,
        sessionId: sessionId.value,
      );
    }).toList();
  }

  void _processOccupiedSlotsFromMotorId(Map<String, dynamic> data) {
    occupiedSlotNumbersPerRow.clear();

    final List motors = data['detected_motorcycles'] ?? [];

    debugPrint("🔥 FOUND detected_motorcycles: ${motors.length}");

    for (final m in motors) {
      final row = m['row_index'];
      final motorId = m['motor_id'];

      if (row == null || motorId == null) continue;

      // motor_id: row1_motor5 → slot = 5
      final match = RegExp(r'motor(\d+)$').firstMatch(motorId.toString());
      if (match == null) continue;

      final slotNum = int.parse(match.group(1)!);
      final rowKey = row.toString();

      occupiedSlotNumbersPerRow.putIfAbsent(rowKey, () => <int>{});
      occupiedSlotNumbersPerRow[rowKey]!.add(slotNum);
    }

    debugPrint("🔥 OCCUPIED SLOTS: $occupiedSlotNumbersPerRow");
  }

  /// =============================
  /// FINAL OCCUPIED SLOT PER ROW
  /// motorSlots - emptySlots
  /// =============================
  Set<int> getFinalOccupiedSlots(String row) {
    final motorSlots = occupiedSlotNumbersPerRow[row] ?? {};

    final emptySlots =
        posisiKosongPerRow[row]
            ?.map((s) => int.tryParse(extractSlotLabel(s['space_id'])) ?? -1)
            .where((n) => n > 0)
            .toSet() ??
        {};

    // RULE: slot kosong MENANG
    return motorSlots.difference(emptySlots);
  }
}
