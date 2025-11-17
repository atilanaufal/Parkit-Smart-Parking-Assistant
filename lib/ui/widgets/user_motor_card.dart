import 'package:flutter/material.dart';
import 'package:parkit_smart_parking_assistant/config/helper/motor_type.dart';

class UserMotorCard extends StatelessWidget {
  final String motorName;
  final String dimension;
  final String colorName;
  final String type; // <---- TAMBAH INI
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const UserMotorCard({
    super.key,
    required this.motorName,
    required this.dimension,
    required this.colorName,
    required this.type, // <---- TAMBAH INI
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
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
              // ===========================================================
              //   ICON MOTOR DARI GAMBAR (TYPE)
              // ===========================================================
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF4E71FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Image.asset(
                  motorTypeAssets[type] ?? motorTypeAssets["matic_motor"]!,
                  width: 32,
                  height: 32,
                  color: Colors.white, // membuat icon putih
                ),
              ),

              const SizedBox(width: 14),

              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    motorName,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Dimensi: $dimension",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Warna: $colorName",
                    style: const TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
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
