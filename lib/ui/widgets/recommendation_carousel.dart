// lib/ui/screens/parking/widgets/recommendation_carousel.dart
import 'package:flutter/material.dart';
import 'package:parkit_smart_parking_assistant/models/recommended_slot.dart';

class RecommendationCarousel extends StatelessWidget {
  final List<RecommendedSlot> items;
  final Function(RecommendedSlot) onTap;

  const RecommendationCarousel({
    super.key,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return SizedBox(
        height: 120,
        child: Center(child: Text("Tidak ada rekomendasi")),
      );
    }

    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.only(right: 12),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final s = items[i];
          return Container(
            width: 200,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12.withOpacity(0.05),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  s.slot,
                  style: const TextStyle(
                    color: Color(0xFF4E71FF),
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.timer, size: 14, color: Colors.black54),
                    const SizedBox(width: 6),
                    Text("Kapasitas"),
                  ],
                ),
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 14,
                      color: Colors.black54,
                    ),
                    const SizedBox(width: 6),
                    Text(s.capacity.toString()),
                  ],
                ),
                const SizedBox(height: 6),

                const Spacer(),
                InkWell(
                  onTap: () {
                    onTap(s);
                  },
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFF4E71FF)),
                    ),
                    child: const Center(
                      child: Text(
                        "Navigasi",
                        style: TextStyle(color: Color(0xFF4E71FF)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
