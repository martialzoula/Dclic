import 'dart:convert';
import 'package:flutter/material.dart';
import '../database/databasehelper.dart';
import '../widgets/custom_app_bar.dart';
import '../pages/login_page.dart';
import 'categorie_page.dart';
import '../pages/profil_page.dart';

class ProfilCategoriesPage extends StatefulWidget {
  final int userId;
  final String firstname;
  final String username;

  const ProfilCategoriesPage({
    super.key,
    required this.userId,
    required this.firstname,
    required this.username,
  });

  @override
  State<ProfilCategoriesPage> createState() => _ProfilCategoriesPageState();
}

class _ProfilCategoriesPageState extends State<ProfilCategoriesPage> {
  List<Map<String, dynamic>> categories = [];

  @override
  void initState() {
    super.initState();
    chargerCategories();
  }

  Future<void> chargerCategories() async {
    final data =
        await DatabaseHelper.instance.getCategoriesByUser(widget.userId);

    setState(() {
      categories = data.map((cat) {
        return {
          "id": cat["id"],
          "titre": cat["titre"],
          "description": cat["description"],
          "elements": jsonDecode(cat["elements"]),
          "date": cat["dateCreation"],
          "icon": cat["icon"],
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titre: "Mes catégories",
        isHomePage: false,
        userInitial: widget.firstname[0],
        onProfile: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ProfilPage(
                userId: widget.userId,
                firstname: widget.firstname,
                username: widget.username,
              ),
            ),
          );
        },
        onLogout: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginPage()),
            (route) => false,
          );
        },
      ),

      body: categories.isEmpty
          ? const Center(
              child: Text(
                "Aucune catégorie",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (_, index) {
                final cat = categories[index];

                return Card(
                  elevation: 2,
                  child: ListTile(
                    leading: Icon(
                      IconData(
                        int.parse(cat["icon"]),
                        fontFamily: 'MaterialIcons',
                      ),
                      color: Colors.black87,
                    ),
                    title: Text(
                      cat["titre"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text("Créée le : ${cat["date"]}"),
                    trailing: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CategoriePage(
                              categorie: cat,
                              firstname: widget.firstname,
                              username: widget.username,
                              userId: widget.userId,
                            ),
                          ),
                        );
                      },
                      child: const Text("Ouvrir"),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
