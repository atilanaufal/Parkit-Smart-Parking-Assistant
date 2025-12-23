import 'package:flutter/material.dart';
import 'package:parkit_smart_parking_assistant/config/helper/motor_type.dart';

class UserMotorCard extends StatelessWidget {
  final String brand;
  final String model; // matic, cub, sport, electric
  final int lengthCm;
  final int widthCm;
  final String colorName;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const UserMotorCard({
    super.key,
    required this.brand,
    required this.model,
    required this.lengthCm,
    required this.widthCm,
    required this.colorName,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    final String safeModel = motorTypeAssets.containsKey(model)
        ? model
        : 'matic';

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // ================= ICON MOTOR =================
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4E71FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  motorTypeAssets[safeModel]!,
                  width: 32,
                  height: 32,
                  color: Colors.white,
                ),
              ),

              const SizedBox(width: 14),

              // ================= INFO =================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      brand,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Dimensi: ${lengthCm} x ${widthCm} cm",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Warna: ${colorName.isEmpty ? "-" : colorName}",
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),
          const Divider(height: 1, color: Colors.black12),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SmallActionButton(
                icon: Icons.edit_rounded,
                label: "Edit",
                onTap: onEdit,
              ),
              _SmallActionButton(
                icon: Icons.delete_rounded,
                label: "Hapus",
                onTap: onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ===========================================================
// SMALL BUTTON
// ===========================================================
class _SmallActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _SmallActionButton({
    required this.icon,
    required this.label,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE8EDFF),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: const Color(0xFF4E71FF)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF4E71FF),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
