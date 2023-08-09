import 'package:flutter/material.dart';
import 'package:segundointento/vista.dart';

import 'ingreso.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
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
              Title(color: Colors.cyan, child: Text("Pantalla principal"))
            ],
          )
          ),
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 15)),
            ElevatedButton(
                child: Text("Ingresar"),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Ingreso()))),
            ElevatedButton(
                child: Text("Vista"),
                onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const Vista()))),
          ],
        ),
      ),
    );
  }
}
