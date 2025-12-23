import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_controller.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_motor_controller.dart';
import 'package:parkit_smart_parking_assistant/config/helper/motor_type.dart';

class AddMotorScreen extends StatefulWidget {
  const AddMotorScreen({super.key});

  @override
  State<AddMotorScreen> createState() => _AddMotorScreenState();
}

class _AddMotorScreenState extends State<AddMotorScreen> {
  final UserMotorController motor = Get.find();
  final UserController user = Get.find();

  final TextEditingController brandC = TextEditingController();
  final TextEditingController widthC = TextEditingController();
  final TextEditingController colorC = TextEditingController();

  String selectedType = "matic";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FE),
      appBar: AppBar(
        title: const Text(
          "Tambah Motor",
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _motorTypeDropdown(),

            const SizedBox(height: 18),

            _inputCard(
              title: "Brand Motor",
              hint: "Contoh: Yamaha",
              controller: brandC,
            ),

            const SizedBox(height: 18),

            _inputCard(
              title: "Lebar Motor (cm)",
              hint: "Contoh: 70",
              controller: widthC,
              isNumber: true,
            ),

            const SizedBox(height: 18),

            _inputCard(
              title: "Warna Motor (Opsional)",
              hint: "Contoh: Hitam",
              controller: colorC,
            ),

            const SizedBox(height: 26),

            _submitButton(),
          ],
        ),
      ),
    );
  }

  // ================= SUBMIT =================
  void _saveMotor() {
    if (brandC.text.isEmpty || widthC.text.isEmpty) {
      _warning("Brand dan lebar motor wajib diisi");
      return;
    }

    motor.addMotor(
      userId: user.userId.value, // ⬅️ TIDAK BOLEH KOSONG
      ownerName: user.username.value, // ⬅️ WAJIB ADA
      email: user.email.value, // ⬅️ EMAIL VALID
      brand: brandC.text,
      model: selectedType, // UI key
      color: colorC.text,
      widthCm: int.parse(widthC.text),
    );

    Get.back();
  }

  // ================= UI =================
  Widget _submitButton() {
    return InkWell(
      onTap: _saveMotor,
      borderRadius: BorderRadius.circular(12),
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
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }

  Widget _inputCard({
    required String title,
    required String hint,
    required TextEditingController controller,
    bool isNumber = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _box(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: _label()),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: isNumber ? TextInputType.number : TextInputType.text,
            inputFormatters: isNumber
                ? [FilteringTextInputFormatter.digitsOnly]
                : null,
            decoration: _inputDecoration(hint),
          ),
        ],
      ),
    );
  }

  Widget _motorTypeDropdown() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _box(),
      child: Row(
        children: [
          Image.asset(motorTypeAssets[selectedType]!, width: 42),
          const SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<String>(
              value: selectedType,
              decoration: _inputDecoration("Tipe Motor"),
              items: motorTypeAssets.keys.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(motorTypeLabel(e)),
                );
              }).toList(),
              onChanged: (v) => setState(() => selectedType = v!),
            ),
          ),
        ],
      ),
    );
  }

  void _warning(String msg) {
    Get.snackbar("Peringatan", msg);
  }

  BoxDecoration _box() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(14),
    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 8)],
  );

  TextStyle _label() =>
      const TextStyle(fontWeight: FontWeight.w700, fontSize: 15);

  InputDecoration _inputDecoration(String hint) => InputDecoration(
    hintText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
  );
}
