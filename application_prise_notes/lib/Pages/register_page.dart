import 'package:application_prise_notes/pages/login_page.dart';
import 'package:flutter/material.dart';
import '../database/databasehelper.dart';
import '../widgets/custom_app_bar.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  RegisterPageState createState() => RegisterPageState();
}

class RegisterPageState extends State<RegisterPage> {
  final firstnameController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  String errorMessage = '';
  bool showPassword = false;

  Future<void> register() async {
    final firstname = firstnameController.text.trim();
    final username = usernameController.text.trim();
    final password = passwordController.text.trim();

    if (firstname.isEmpty || username.isEmpty || password.isEmpty) {
      setState(() => errorMessage = 'Tous les champs sont obligatoires');
      return;
    }

    final exists = await DatabaseHelper.instance.usernameExists(username);

    if (exists) {
      setState(() => errorMessage = 'Identifiant déjà utilisé');
      return;
    }

    await DatabaseHelper.instance.insertUser({
      'firstname': firstname,
      'username': username,
      'password': password,
    });

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titre: "Créer un compte",
        isLoginPage: true,
      ),

      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),

              child: Column(
                children: [

                  // 🔹 IMAGE SOUS L’APPBAR
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Image.asset(
                      "assets/images/Mon_livre_de_notes.png",
                      height: 120,
                    ),
                  ),

                  // 🔹 CONTENU CENTRÉ
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        // 🔹 Champ prénom
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Prénom",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: firstnameController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "Jean, Marie...",
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 🔹 Champ identifiant
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Identifiant",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: usernameController,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "exemple123",
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 🔹 Champ mot de passe
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Mot de passe",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 6),

                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade200,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(
                                controller: passwordController,
                                obscureText: !showPassword,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "••••••••",
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      showPassword
                                          ? Icons.visibility_off
                                          : Icons.visibility,
                                      color: Colors.grey.shade700,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // 🔹 Message d'erreur
                        if (errorMessage.isNotEmpty)
                          Text(
                            errorMessage,
                            style: const TextStyle(color: Colors.red),
                          ),

                        const SizedBox(height: 30),

                        // 🔹 Bouton créer un compte
                        ElevatedButton(
                          onPressed: register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 40,
                              vertical: 12,
                            ),
                          ),
                          child: const Text('Créer mon compte'),
                        ),

                        // 🔹 Bouton retour vers connexion
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            "Déjà un compte ? Connexion",
                            style: TextStyle(color: Color.fromARGB(255, 2, 36, 230)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
