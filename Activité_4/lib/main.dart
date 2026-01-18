<<<<<<< HEAD
=======
//Contact the tradespeople who will be working on your construction site
>>>>>>> 98e42b9 (Sauvegarde avant pull)
import 'package:flutter/material.dart';

//Apply, obtain and display your building permit for your house
void main() {
  runApp(const MonAppli());
}

<<<<<<< HEAD
=======
//Open the binder that contains your architectural plans
>>>>>>> 98e42b9 (Sauvegarde avant pull)
class MonAppli extends StatelessWidget {
  const MonAppli({super.key});

//Construct the main structure
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Magazine',
      debugShowCheckedModeBanner: false,
      home: PageAccueil(),
    );
  }
}

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text('Magazine Infos'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {},
          ),
        ],
      ),
      body: const Column(
        children: [
          Image(
            image: AssetImage('assets/images/magazineinfos.jpg'),
          ),
          PartieTitre(),
          PartieTexte(),
          PartieIcone(),
          PartieRubrique(),
        ],
<<<<<<< HEAD
      ),
    );
  }
}

class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenue au Magazine Infos',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          Text(
            "Votre magazine numérique, votre source d'inspiration",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Text(
        "Magazine infos est bien plus qu'un simple magazine d'information. "
        "C'est votre passerelle vers le monde, une source inestimable de connaissances "
        "et d'actualités soigneusement sélectionnées pour vous éclairer sur les enjeux "
        "mondiaux, la culture, la science et même le divertissement.",
      ),
    );
  }
}

class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              const Icon(Icons.phone, color: Colors.pink),
              const SizedBox(height: 5),
              Text(
                'TEL',
                style: const TextStyle(color: Colors.pink),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.mail, color: Colors.pink),
              const SizedBox(height: 5),
              Text(
                'MAIL',
                style: const TextStyle(color: Colors.pink),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.share, color: Colors.pink),
              const SizedBox(height: 5),
              Text(
                'PARTAGE',
                style: const TextStyle(color: Colors.pink),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const Image(
              image: AssetImage('assets/images/design.jpeg'),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const Image(
              image: AssetImage('assets/images/presse.jpeg'),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ],
=======
>>>>>>> 98e42b9 (Sauvegarde avant pull)
      ),
    );
  }
}

class PartieTitre extends StatelessWidget {
  const PartieTitre({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bienvenue au Magazine Infos',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),
          ),
          Text(
            "Votre magazine numérique, votre source d'inspiration",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class PartieTexte extends StatelessWidget {
  const PartieTexte({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: const Text(
        "Magazine infos est bien plus qu'un simple magazine d'information. "
        "C'est votre passerelle vers le monde, une source inestimable de connaissances "
        "et d'actualités soigneusement sélectionnées pour vous éclairer sur les enjeux "
        "mondiaux, la culture, la science et même le divertissement.",
      ),
    );
  }
}

class PartieIcone extends StatelessWidget {
  const PartieIcone({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              const Icon(Icons.phone, color: Colors.pink),
              const SizedBox(height: 5),
              Text(
                'TEL',
                style: const TextStyle(color: Colors.pink),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.mail, color: Colors.pink),
              const SizedBox(height: 5),
              Text(
                'MAIL',
                style: const TextStyle(color: Colors.pink),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(Icons.share, color: Colors.pink),
              const SizedBox(height: 5),
              Text(
                'PARTAGE',
                style: const TextStyle(color: Colors.pink),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class PartieRubrique extends StatelessWidget {
  const PartieRubrique({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const Image(
              image: AssetImage('assets/images/design.jpeg'),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
          
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: const Image(
              image: AssetImage('assets/images/presse.jpeg'),
              width: 80,
              height: 80,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }
}