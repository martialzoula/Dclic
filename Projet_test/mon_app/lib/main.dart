import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;   // <-- CORRECTION ICI

// ---------------------------------------------------------
// 1. MODEL UTILISATEUR
// ---------------------------------------------------------
class Utilisateur {
  final int? id;
  final String nom;
  final String prenom;
  final String email;

  Utilisateur({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };
  }

  factory Utilisateur.fromMap(Map<String, dynamic> map) {
    return Utilisateur(
      id: map['id'],
      nom: map['nom'],
      prenom: map['prenom'],
      email: map['email'],
    );
  }
}

// ---------------------------------------------------------
// 2. DATABASE HELPER
// ---------------------------------------------------------
class DatabaseHelper {
  static Database? _database;

  static Future<Database> get database async {
    if (_database != null) return _database!;
    return await _initDB();
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'utilisateurs.db');   // <-- CORRECTION ICI

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE utilisateurs(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nom TEXT,
            prenom TEXT,
            email TEXT
          )
        ''');
      },
    );
  }

  // INSERT
  static Future<void> insertUtilisateur(Utilisateur utilisateur) async {
    final db = await database;
    await db.insert('utilisateurs', utilisateur.toMap());
  }

  // UPDATE
  static Future<void> updateUtilisateur(Utilisateur utilisateur) async {
    final db = await database;
    await db.update(
      'utilisateurs',
      utilisateur.toMap(),
      where: 'id = ?',
      whereArgs: [utilisateur.id],
    );
  }

  // DELETE
  static Future<void> deleteUtilisateur(int id) async {
    final db = await database;
    await db.delete(
      'utilisateurs',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // GET ALL
  static Future<List<Utilisateur>> getAllUtilisateurs() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('utilisateurs');

    return List.generate(maps.length, (i) {
      return Utilisateur.fromMap(maps[i]);
    });
  }
}

// ---------------------------------------------------------
// 3. APPLICATION PRINCIPALE
// ---------------------------------------------------------
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PageAccueil(),
    );
  }
}

// ---------------------------------------------------------
// 4. PAGE ACCUEIL
// ---------------------------------------------------------
class PageAccueil extends StatefulWidget {
  const PageAccueil({super.key});

  @override
  State<PageAccueil> createState() => _PageAccueilState();
}

class _PageAccueilState extends State<PageAccueil> {
  final TextEditingController nomCtrl = TextEditingController();
  final TextEditingController prenomCtrl = TextEditingController();
  final TextEditingController emailCtrl = TextEditingController();

  List<Utilisateur> utilisateurs = [];

  @override
  void initState() {
    super.initState();
    chargerUtilisateurs();
  }

  Future<void> chargerUtilisateurs() async {
    utilisateurs = await DatabaseHelper.getAllUtilisateurs();
    setState(() {});
  }

  Future<void> ajouterUtilisateur() async {
    if (nomCtrl.text.isEmpty || prenomCtrl.text.isEmpty || emailCtrl.text.isEmpty) return;

    final user = Utilisateur(
      nom: nomCtrl.text,
      prenom: prenomCtrl.text,
      email: emailCtrl.text,
    );

    await DatabaseHelper.insertUtilisateur(user);

    nomCtrl.clear();
    prenomCtrl.clear();
    emailCtrl.clear();

    chargerUtilisateurs();
  }

  void modifierUtilisateur(Utilisateur user) {
    nomCtrl.text = user.nom;
    prenomCtrl.text = user.prenom;
    emailCtrl.text = user.email;

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Modifier le rédacteur"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nomCtrl, decoration: const InputDecoration(labelText: "Nom")),
            TextField(controller: prenomCtrl, decoration: const InputDecoration(labelText: "Prénom")),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              final updated = Utilisateur(
                id: user.id,
                nom: nomCtrl.text,
                prenom: prenomCtrl.text,
                email: emailCtrl.text,
              );

              await DatabaseHelper.updateUtilisateur(updated);
              Navigator.pop(context);
              chargerUtilisateurs();
            },
            child: const Text("Enregistrer"),
          ),
        ],
      ),
    );
  }

  void supprimerUtilisateur(int id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Confirmer"),
        content: const Text("Confirmer la suppression de ce rédacteur ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          ElevatedButton(
            onPressed: () async {
              await DatabaseHelper.deleteUtilisateur(id);
              Navigator.pop(context);
              chargerUtilisateurs();
            },
            child: const Text("Supprimer"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestion des utilisateurs"),
        backgroundColor: Colors.blue,
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: nomCtrl, decoration: const InputDecoration(labelText: "Nom")),
            const SizedBox(height: 10),
            TextField(controller: prenomCtrl, decoration: const InputDecoration(labelText: "Prénom")),
            const SizedBox(height: 10),
            TextField(controller: emailCtrl, decoration: const InputDecoration(labelText: "Email")),
            const SizedBox(height: 20),

            ElevatedButton.icon(
              onPressed: ajouterUtilisateur,
              icon: const Icon(Icons.add),
              label: const Text("Ajouter un rédacteur"),
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: utilisateurs.length,
                itemBuilder: (_, index) {
                  final user = utilisateurs[index];
                  return Card(
                    child: ListTile(
                      title: Text("${user.nom} ${user.prenom}"),
                      subtitle: Text(user.email),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.orange),
                            onPressed: () => modifierUtilisateur(user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => supprimerUtilisateur(user.id!),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
