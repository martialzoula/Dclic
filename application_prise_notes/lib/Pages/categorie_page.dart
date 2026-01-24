import 'dart:convert';
import 'package:flutter/material.dart';
import '../database/databasehelper.dart';
import '../widgets/custom_app_bar.dart';
import '../pages/login_page.dart';
import '../pages/profil_page.dart';

class CategoriePage extends StatefulWidget {
  final Map<String, dynamic> categorie;
  final String firstname;
  final String username;
  final int userId;

  const CategoriePage({
    super.key,
    required this.categorie,
    required this.firstname,
    required this.username,
    required this.userId,
  });

  @override
  State<CategoriePage> createState() => _CategoriePageState();
}

class _CategoriePageState extends State<CategoriePage> {
  List<Map<String, dynamic>> elements = [];

  @override
  void initState() {
    super.initState();
    chargerElements();
  }

  // 🔹 Charger les éléments de la catégorie
  Future<void> chargerElements() async {
    final data = await DatabaseHelper.instance
        .getItemsByCategorie(widget.categorie["id"]);

    setState(() {
      elements = data.map((item) {
        return {
          "id": item["id"],
          "valeurs": jsonDecode(item["valeurs"]),
          "date": item["dateCreation"],
        };
      }).toList();
    });
  }

  // 🔹 Ajouter un élément
  void ajouterElement() {
    final champs = widget.categorie["elements"] as List<dynamic>;

    final Map<String, TextEditingController> controllers = {
      for (var c in champs) c: TextEditingController()
    };

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Ajouter un élément"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: champs
              .map(
                (c) => TextField(
                  controller: controllers[c],
                  decoration: InputDecoration(labelText: c),
                ),
              )
              .toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final valeurs = {
                for (var c in champs) c: controllers[c]!.text.trim(),
              };

              await DatabaseHelper.instance.insertItem({
                "categorieId": widget.categorie["id"],
                "valeurs": jsonEncode(valeurs),
                "dateCreation": DateTime.now().toString(),
              });

              if (!mounted) return;
              Navigator.pop(context);
              chargerElements();
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  // 🔹 Supprimer un élément
  void supprimerElement(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmer"),
        content: const Text("Supprimer cet élément ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              await DatabaseHelper.instance.deleteItem(id);
              if (!mounted) return;
              Navigator.pop(context);
              chargerElements();
            },
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  // 🔹 Modifier une valeur
  void _modifierValeur(Map<String, dynamic> item, String champ, String valeur) {
    final controller = TextEditingController(text: valeur);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Modifier $champ"),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: champ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final newValue = controller.text.trim();

              final newMap = Map<String, dynamic>.from(item["valeurs"]);
              newMap[champ] = newValue;

              await DatabaseHelper.instance.updateItem(
                item["id"],
                {
                  "categorieId": widget.categorie["id"],
                  "valeurs": jsonEncode(newMap),
                  "dateCreation": item["date"],
                },
              );

              if (!mounted) return;
              Navigator.pop(context);
              chargerElements();
            },
            child: const Text("Modifier"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final champs = widget.categorie["elements"] as List<dynamic>;

    return Scaffold(
      appBar: CustomAppBar(
        titre: widget.categorie["titre"],
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

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: ajouterElement,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: elements.isEmpty
            ? const Center(
                child: Text(
                  "Aucun élément pour le moment",
                  style: TextStyle(fontSize: 18),
                ),
              )
            : ListView.builder(
                itemCount: elements.length,
                itemBuilder: (_, index) {
                  final item = elements[index];
                  final valeurs = item["valeurs"] as Map<String, dynamic>;

                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ExpansionTile(
                      tilePadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),

                      // 🔵 HEADER : premier champ
                      title: Row(
                        children: [
                          Expanded(
                            child: Text(
                              "${valeurs[champs[0]]}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          PopupMenuButton(
                            itemBuilder: (_) => const [
                              PopupMenuItem(
                                value: "edit_title",
                                child: Text("Modifier le titre"),
                              ),
                              PopupMenuItem(
                                value: "copy_title",
                                child: Text("Copier le titre"),
                              ),
                              PopupMenuItem(
                                value: "delete",
                                child: Text("Supprimer le bloc"),
                              ),
                            ],
                            onSelected: (value) {
                              if (value == "delete") {
                                supprimerElement(item["id"]);
                              }

                              if (value == "edit_title") {
                                _modifierValeur(
                                  item,
                                  champs[0],
                                  valeurs[champs[0]],
                                );
                              }

                              if (value == "copy_title") {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      "Copié : ${valeurs[champs[0]]}",
                                    ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),

                      // 🔵 CHAMPS SECONDAIRES
                      children: [
                        for (var c in champs.skip(1))
                          ListTile(
                            title: Text("$c : ${valeurs[c] ?? ''}"),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, size: 20),
                                  onPressed: () {
                                    _modifierValeur(item, c, valeurs[c]);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.copy, size: 20),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Copié : ${valeurs[c]}"),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text(
                            "Créé le : ${item["date"]}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}

