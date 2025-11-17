import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_motor_controller.dart';
import 'package:parkit_smart_parking_assistant/config/helper/motor_type.dart';

class AddMotorScreen extends StatefulWidget {
  const AddMotorScreen({super.key});

  @override
  State<AddMotorScreen> createState() => _AddMotorScreenState();
}

class _AddMotorScreenState extends State<AddMotorScreen> {
  final UserMotorController motor = Get.find();

  final TextEditingController nameC = TextEditingController();
  final TextEditingController dimensionC = TextEditingController();
  final TextEditingController colorC = TextEditingController();

  String selectedType = "matic";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: AppBar(
        title: const Text(
          "Tambah Motor",
          style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            motorTypeDropdown(
              selectedType: selectedType,
              onChanged: (val) => setState(() => selectedType = val),
            ),

            const SizedBox(height: 18),

            _inputCard(
              title: "Nama Motor",
              hint: "Contoh: Honda Vario 160",
              controller: nameC,
            ),

            const SizedBox(height: 18),

            _inputCard(
              title: "Dimensi Motor",
              hint: "Contoh: 1870 x 669 x 1074 mm",
              controller: dimensionC,
            ),

            const SizedBox(height: 18),

            // WARNA MOTOR (OPSIONAL)
            _inputCard(
              title: "Warna Motor (Opsional)",
              hint: "Contoh: Hitam Doff / kosongkan",
              controller: colorC,
            ),

            const SizedBox(height: 26),

            InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: _saveMotor,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFF4E71FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Text(
                    "Simpan Motor",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveMotor() {
    if (nameC.text.isEmpty || dimensionC.text.isEmpty) {
      _warningSnackbar("Nama dan dimensi wajib diisi.");
      return;
    }

    motor.addMotor(
      nameC.text,
      dimensionC.text,
      colorC.text, // OPSIONAL
      selectedType,
    );

    Get.back();
  }

  // ===========================================================
  // SNACKBAR WARNING
  // ===========================================================
  void _warningSnackbar(String msg) {
    Get.snackbar(
      "Peringatan",
      msg,
      snackPosition: SnackPosition.TOP,
      margin: EdgeInsets.only(top: kToolbarHeight + 8, left: 12, right: 12),
      backgroundColor: Colors.orange.shade100,
      colorText: Colors.black87,
      borderRadius: 10,
    );
  }

  // INPUT CARD
  Widget _inputCard({
    required String title,
    required String hint,
    required TextEditingController controller,
  }) {
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: const TextStyle(color: Colors.black38, fontSize: 14),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.black12),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Color(0xFF4E71FF)),
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DROPDOWN TIPE MOTOR
  Widget motorTypeDropdown({
    required String selectedType,
    required Function(String) onChanged,
  }) {
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
      child: Row(
        children: [
          Image.asset(
            motorTypeAssets[selectedType]!,
            width: 42,
            height: 42,
            fit: BoxFit.contain,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              initialValue: selectedType,
              decoration: InputDecoration(
                labelText: "Tipe Motor",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              items: motorTypeAssets.keys.map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(type.replaceAll("_", " ").toUpperCase()),
                );
              }).toList(),
              onChanged: (value) => onChanged(value!),
            ),
          ),
        ],
      ),
    );
  }
}
