import 'dart:convert';
import 'package:flutter/material.dart';
import '../widgets/custom_app_bar.dart';
import '../pages/login_page.dart';
import '../database/databasehelper.dart';
import 'categorie_page.dart';
import '../pages/profil_page.dart';

class HomePage extends StatefulWidget {
  final String firstname;
  final String username;
  final int userId;

  const HomePage({
    super.key,
    required this.firstname,
    required this.username,
    required this.userId,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> categories = [];

  // 🔹 Icône sélectionnée
  String? selectedIcon;

  // 🔹 Icône par défaut
  final String defaultIcon = Icons.edit_note.codePoint.toString();

  @override
  void initState() {
    super.initState();
    chargerCategories();
  }

  // ------------------------------------------------------------
  // 🔹 Charger les catégories depuis SQLite
  // ------------------------------------------------------------
  Future<void> chargerCategories() async {
    final data = await DatabaseHelper.instance.getCategoriesByUser(widget.userId);

    if (!mounted) return;

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

  // ------------------------------------------------------------
  // 🔹 Sélecteur d’icônes
  // ------------------------------------------------------------
  void _showIconPicker() {
    final icons = [Icons.shopping_cart, Icons.home, Icons.star, Icons.favorite, Icons.work, Icons.school, Icons.pets, Icons.sports_soccer, Icons.computer, Icons.phone_android, Icons.book, Icons.music_note, Icons.flight, Icons.local_cafe, Icons.local_dining, Icons.lightbulb, Icons.map, Icons.build, Icons.camera_alt, Icons.edit_note, Icons.ac_unit, Icons.access_alarm, Icons.accessibility, Icons.account_balance, Icons.account_circle, Icons.add_business, Icons.airplanemode_active, Icons.alarm, Icons.album, Icons.apartment, Icons.archive, Icons.art_track, Icons.assessment, Icons.assignment, Icons.audiotrack, Icons.auto_awesome, Icons.backpack, Icons.bakery_dining, Icons.bathtub, Icons.beach_access, Icons.bed, Icons.bike_scooter, Icons.blender, Icons.bluetooth, Icons.bookmark, Icons.brush, Icons.bug_report, Icons.business_center, Icons.cake, Icons.call, Icons.car_rental, Icons.car_repair, Icons.casino, Icons.chair, Icons.child_care, Icons.cleaning_services, Icons.cloud, Icons.code, Icons.collections, Icons.color_lens, Icons.construction, Icons.cookie, Icons.coronavirus, Icons.credit_card, Icons.dashboard, Icons.deck, Icons.delivery_dining, Icons.design_services, Icons.directions_bike, Icons.directions_boat, Icons.directions_bus, Icons.directions_car, Icons.directions_railway, Icons.directions_run, Icons.directions_walk, Icons.dining, Icons.eco, Icons.electric_bike, Icons.electric_car, Icons.elevator, Icons.emoji_events, Icons.engineering, Icons.euro, Icons.explore, Icons.extension, Icons.face, Icons.factory, Icons.fastfood, Icons.favorite_border, Icons.fitness_center, Icons.flag, Icons.flash_on, Icons.forest, Icons.forum, Icons.free_breakfast, Icons.gamepad, Icons.gavel, Icons.gesture, Icons.golf_course, Icons.grass, Icons.group, Icons.handyman, Icons.headphones, Icons.health_and_safety, Icons.hiking, Icons.history, Icons.holiday_village, Icons.icecream, Icons.inventory, Icons.kayaking, Icons.kitchen, Icons.language, Icons.laptop, Icons.library_books, Icons.local_florist, Icons.local_gas_station, Icons.local_hospital, Icons.local_library, Icons.local_mall, Icons.local_parking, Icons.local_pharmacy, Icons.local_play, Icons.local_police, Icons.local_post_office, Icons.local_shipping, Icons.lock, Icons.masks, Icons.medical_services, Icons.military_tech, Icons.monetization_on, Icons.motorcycle, Icons.movie, Icons.nature, Icons.nature_people, Icons.nightlife, Icons.outdoor_grill, Icons.palette, Icons.park, Icons.people, Icons.person, Icons.phone, Icons.photo_camera, Icons.piano, Icons.pool, Icons.print, Icons.public, Icons.receipt, Icons.restaurant, Icons.rocket, Icons.sailing, Icons.sanitizer, Icons.science, Icons.security, Icons.settings, Icons.shopping_bag, Icons.snowboarding, Icons.spa, Icons.sports_basketball, Icons.sports_esports, Icons.sports_gymnastics, Icons.sports_handball, Icons.sports_kabaddi, Icons.sports_motorsports, Icons.sports_tennis, Icons.store, Icons.stroller, Icons.subway, Icons.support, Icons.surfing, Icons.theater_comedy, Icons.thermostat, Icons.thumb_up, Icons.timer, Icons.toys, Icons.train, Icons.tram, Icons.travel_explore, Icons.tv, Icons.volunteer_activism, Icons.wallet, Icons.wash, Icons.water, Icons.wifi, Icons.wine_bar, Icons.workspaces, Icons.yard];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Choisir une icône"),
        content: SizedBox(
          width: 300,
          height: 300,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: icons.length,
            itemBuilder: (_, index) {
              return IconButton(
                icon: Icon(icons[index], size: 30, color: const Color.fromARGB(255, 14, 14, 14)),
                onPressed: () {
                  setState(() {
                    selectedIcon = icons[index].codePoint.toString();
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // 🔹 Pop‑up : icône par défaut ou choisir ?
  // ------------------------------------------------------------
  void _showDefaultIconDialog(
    TextEditingController titreController,
    TextEditingController descriptionController,
    TextEditingController elementsController,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Icône non sélectionnée"),
        content: const Text(
          "Souhaites‑tu utiliser l’icône par défaut ou en choisir une ?",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _createCategory(
                titreController,
                descriptionController,
                elementsController,
                defaultIcon,
              );
            },
            child: const Text("Icône par défaut"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showIconPicker();
            },
            child: const Text("Choisir une icône"),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // 🔹 Création finale de la catégorie
  // ------------------------------------------------------------
  void _createCategory(
    TextEditingController titreController,
    TextEditingController descriptionController,
    TextEditingController elementsController,
    String iconCode,
  ) async {
    final navigator = Navigator.of(context);

    final elements = elementsController.text
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    await DatabaseHelper.instance.insertCategorie({
      "titre": titreController.text.trim(),
      "description": descriptionController.text.trim(),
      "elements": jsonEncode(elements),
      "dateCreation": DateTime.now().toString(),
      "userId": widget.userId,
      "icon": iconCode,
    });

    if (!mounted) return;

    navigator.pop();
    chargerCategories();
  }

  // ------------------------------------------------------------
  // 🔹 Ajouter une catégorie
  // ------------------------------------------------------------
  void ajouterCategorie() {
    selectedIcon = null;

    final titreController = TextEditingController();
    final descriptionController = TextEditingController();
    final elementsController = TextEditingController();

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Nouvelle catégorie"),
                IconButton(
                  icon: const Icon(Icons.help_outline, color: Color.fromARGB(255, 12, 12, 12)),
                  onPressed: () => _afficherAide(),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titreController,
                  decoration: const InputDecoration(labelText: "Titre"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: elementsController,
                  decoration: const InputDecoration(
                    labelText: "Éléments prédéfinis (séparés par des virgules)",
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _showIconPicker,
                  child: const Text("Choisir une icône"),
                ),
                if (selectedIcon == null)
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      "Aucune icône sélectionnée — une icône par défaut sera utilisée.",
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (titreController.text.trim().isEmpty) return;

                  if (selectedIcon == null) {
                    _showDefaultIconDialog(
                      titreController,
                      descriptionController,
                      elementsController,
                    );
                  } else {
                    _createCategory(
                      titreController,
                      descriptionController,
                      elementsController,
                      selectedIcon!,
                    );
                  }
                },
                child: const Text("Enregistrer"),
              ),
            ],
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // 🔹 Fenêtre d’aide
  // ------------------------------------------------------------
  void _afficherAide() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Aide"),
            IconButton(
              icon: const Icon(Icons.close, color: Colors.red),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
        content: const Text(
          "Les éléments prédéfinis permettent de créer des champs "
          "qui seront affichés lorsque vous ajouterez un élément dans la catégorie.\n\n"
          "Exemple :\n"
          "Catégorie : Courses\n"
          "Éléments : magasin, rayon, produit\n\n"
          "Résultat : lorsque vous cliquerez sur + dans la catégorie Courses, "
          "vous devrez remplir :\n"
          "- Magasin\n"
          "- Rayon\n"
          "- Produit",
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // 🔹 Modifier une catégorie
  // ------------------------------------------------------------
  void modifierCategorie(int index) {
    final cat = categories[index];

    final titreController = TextEditingController(text: cat["titre"]);
    final descriptionController = TextEditingController(text: cat["description"]);
    final elementsController =
        TextEditingController(text: (cat["elements"] as List).join(", "));

    selectedIcon = cat["icon"];

    showDialog(
      context: context,
      builder: (_) => StatefulBuilder(
        builder: (context, setStateDialog) {
          return AlertDialog(
            title: const Text("Modifier la catégorie"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titreController,
                  decoration: const InputDecoration(labelText: "Titre"),
                ),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: "Description"),
                ),
                TextField(
                  controller: elementsController,
                  decoration: const InputDecoration(
                    labelText: "Éléments : séparer par des virgules",
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _showIconPicker,
                  child: const Text("Changer l’icône"),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Annuler"),
              ),
              ElevatedButton(
                onPressed: () async {
                  final navigator = Navigator.of(context);

                  final elements = elementsController.text
                      .split(',')
                      .map((e) => e.trim())
                      .where((e) => e.isNotEmpty)
                      .toList();

                  await DatabaseHelper.instance.updateCategorie(
                    cat["id"],
                    {
                      "titre": titreController.text.trim(),
                      "description": descriptionController.text.trim(),
                      "elements": jsonEncode(elements),
                      "dateCreation": cat["date"],
                      "userId": widget.userId,
                      "icon": selectedIcon ?? defaultIcon,
                    },
                  );

                  if (!mounted) return;

                  navigator.pop();
                  chargerCategories();
                },
                child: const Text("Modifier"),
              ),
            ],
          );
        },
      ),
    );
  }

  // ------------------------------------------------------------
  // 🔹 Supprimer une catégorie
  // ------------------------------------------------------------
  void supprimerCategorie(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmer"),
        content: const Text("Supprimer cette catégorie ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final navigator = Navigator.of(context);

              await DatabaseHelper.instance.deleteCategorie(id);

              if (!mounted) return;

              navigator.pop();
              chargerCategories();
            },
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // 🔹 Ouvrir une catégorie
  // ------------------------------------------------------------
  void ouvrirCategorie(Map<String, dynamic> categorie) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => CategoriePage(
          categorie: categorie,
          firstname: widget.firstname,
          username: widget.username,
          userId: widget.userId,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // 🔹 UI
  // ------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titre: "Catégories",
        isHomePage: true,
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
        onPressed: ajouterCategorie,
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: categories.isEmpty
          ? const Center(
              child: Text(
                "Aucune catégorie pour le moment",
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              itemBuilder: (_, index) {
                final cat = categories[index];

                return Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Color.fromARGB(221, 1, 23, 223), 
                      width:0.3,
                      ),
                      borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Icon(
                      IconData(
                        int.parse(cat["icon"]),
                        fontFamily: 'MaterialIcons',
                      ),
                      color: const Color.fromARGB(255, 15, 16, 16),
                    ),
                    title: Text(
                      cat["titre"],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text("Créée le : ${cat["date"]}"),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () => ouvrirCategorie(cat),
                          child: const Text("Ouvrir"),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () => modifierCategorie(index),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => supprimerCategorie(cat["id"]),
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

