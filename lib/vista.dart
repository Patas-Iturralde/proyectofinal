import 'package:flutter/material.dart';

class Vista extends StatefulWidget {
  const Vista({Key? key}) : super(key: key);

  @override
  State<Vista> createState() => _VistaState();
}

class _VistaState extends State<Vista> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            children: [Title(color: Colors.cyan, child: const Text("Vista"))],
          ),
        ),
      body: Column(
        children: <Widget>[
          const Divider(),
          ListTile(
            leading: Text("Aqui va la imagen"),
            title: const Text("Marca, "+"Modelo"),
            subtitle: const Text("Fecha de lanzamiento"),
            trailing: PopupMenuButton(
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry>[
                const PopupMenuItem(
                  value: ListTileTitleAlignment.threeLine,
                  child: Text('Editar'),
                ),
                const PopupMenuItem(
                  value: ListTileTitleAlignment.titleHeight,
                  child: Text('Borrar'),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}
