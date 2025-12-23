import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:parkit_smart_parking_assistant/logic/getx/controller/user_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final UserController user = Get.find();

  final TextEditingController usernameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: usernameC,
              decoration: const InputDecoration(labelText: "Username"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: emailC,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordC,
              obscureText: true,
              decoration: const InputDecoration(labelText: "Password"),
            ),
            const SizedBox(height: 24),
            Obx(
              () => ElevatedButton(
                onPressed: user.isLoading.value
                    ? null
                    : () async {
                        await user.register(
                          usernameInput: usernameC.text,
                          emailInput: emailC.text,
                          passwordInput: passwordC.text,
                        );
                        Get.back();
                      },
                child: const Text("Daftar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
