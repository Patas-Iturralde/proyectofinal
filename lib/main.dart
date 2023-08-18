import 'package:flutter/material.dart';
import 'package:segundointento/vista.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'ingreso.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
    
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //int _counter = 0;

  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            children: [
              Title(color: Colors.cyan, child: const Text("Pantalla principal"))
            ],
          )
          ),
      drawer: Drawer(
        backgroundColor: Colors.brown.shade300,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15)),
            ElevatedButton(
                child: const Text("Ingresar"),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Ingreso())),),
                    const SizedBox(height: 20),
            ElevatedButton(
                child: const Text("Vista"),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Vista()))),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/biblioteca.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 80,),
              Text(
                'Sistema bibliotecario',
                style: TextStyle(color: Colors.white, fontSize: 30, backgroundColor: Color.fromARGB(101, 71, 71, 71)),
              ),
              // Aquí puedes agregar más widgets si es necesario
              Center(
                child: Column(
                  
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
