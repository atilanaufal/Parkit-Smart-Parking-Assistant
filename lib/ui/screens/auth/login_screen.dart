import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_controller.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final UserController user = Get.find();
  final TextEditingController userIdC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: userIdC,
              decoration: const InputDecoration(
                labelText: "User ID",
                hintText: "contoh: usr-xxxx",
              ),
            ),
            const SizedBox(height: 24),
            Obx(
              () => ElevatedButton(
                onPressed: user.isLoading.value
                    ? null
                    : () async {
                        await user.login(userIdC.text.trim());
                        Get.back();
                      },
                child: const Text("Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
