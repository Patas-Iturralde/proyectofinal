import 'package:flutter/material.dart';
import 'package:segundointento/actualizar.dart';
import 'package:segundointento/services/libro_services.dart';
import 'package:intl/intl.dart';

class Vista extends StatefulWidget {
  const Vista({Key? key}) : super(key: key);

  @override
  State<Vista> createState() => _VistaState();
}

showConfirmDelete(BuildContext context) {
  Widget cancelButton = ElevatedButton(
    child: Text(
      "Cancelar",
      style: const TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    onPressed: () {
      print("Cancelando..");
      Navigator.of(context).pop();
    },
  );
  Widget continueButton = ElevatedButton(
    child: Text(
      "Eliminar",
      style: const TextStyle(color: Colors.white),
    ),
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
      shape: MaterialStateProperty.all(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    ),
    onPressed: () {
      print("Eliminando..");
      //Funcion de eliminar
    },
  );

  AlertDialog alert = AlertDialog(
    title: Text("Eliminar producto"),
    content: Text("¿Estás seguro de eliminar el producto?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
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
      body: FutureBuilder(
          future: getLibro(),
          builder: ((context, snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var doc = snapshot.data?[index];
                    var nombre = doc['nombre'];
                    var descripcion = doc['descripcion'];
                    var fecha = doc['fecha'];
                    var imagenurl = doc['imagen'];
                    var fechaLanzamiento = fecha.toDate();

                    // Formatear la fecha usando Intl
                    var formattedFechaLanzamiento =
                        DateFormat.yMMMd().format(fechaLanzamiento);

                    return Column(
                      children: <Widget>[
                        const Divider(),
                        Text("$nombre"),
                        ListTile(
                          leading: Image.network(imagenurl),
                          title: Text("$descripcion"),
                          subtitle: Text("$formattedFechaLanzamiento"),
                          trailing: SizedBox(
                              width: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    onPressed: () => Navigator.of(context)
                                        .push(MaterialPageRoute(
                                            builder: (context) => Actualizar(
                                                  nombre: nombre,
                                                  descripcion: descripcion,
                                                  fecha: fechaLanzamiento,
                                                  imagenurl: imagenurl,
                                                ))),
                                    icon: Icon(Icons.edit),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      (showConfirmDelete(context));
                                    },
                                    icon: Icon(Icons.delete),
                                  ),
                                ],
                              )),
                        ),
                        const Divider(),
                      ],
                    );
                  });
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          })),
    );
  }
}
