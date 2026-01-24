import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String titre;
  final bool isHomePage;
  final bool isLoginPage;
  final String? userInitial;
  final VoidCallback? onLogout;
  final VoidCallback? onProfile;

  const CustomAppBar({
    super.key,
    required this.titre,
    this.isHomePage = false,
    this.isLoginPage = false,
    this.userInitial,
    this.onLogout,
    this.onProfile,
  });

  @override
  Widget build(BuildContext context) {
    // 🔹 AppBar spéciale pour la page Login
    if (isLoginPage) {
      return AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          titre,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(9),
          child: Column(
            children: [
              Container(
                height: 1,
                color: Colors.grey.shade300,
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      );
    }

    // 🔹 AppBar normale
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0.8,
      shadowColor: Colors.black12,
      centerTitle: true,

      title: Text(
        titre,
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),

      leading: isHomePage
          ? const SizedBox()
          : IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),

      flexibleSpace: isHomePage
          ? SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Icon(
                        Icons.menu_book_rounded,
                        color: Color.fromARGB(255, 0, 8, 15),
                        size: 26,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Notes",
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 7, 14),
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          : null,

      actions: [
        PopupMenuButton<String>(
          onSelected: (value) {
            if (value == "profil" && onProfile != null) onProfile!();
            if (value == "logout" && onLogout != null) onLogout!();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: "profil",
              child: Text("Profil"),
            ),
            PopupMenuItem(
              value: "logout",
              child: Text("Déconnexion"),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(
              radius: 18,
              backgroundColor: Colors.grey.shade300,
              child: Text(
                (userInitial ?? "?").toUpperCase(),
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
      ],

      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(9),
        child: Column(
          children: [
            Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56);
}

