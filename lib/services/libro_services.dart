import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:segundointento/models/libro_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer' as developer;

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getLibro() async {
  List libro = [];
  CollectionReference collectionReferenceLibro = db.collection('libro');

  QuerySnapshot queryLibro = await collectionReferenceLibro.get();

  for (var doc in queryLibro.docs) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    final book = {
      "lid": doc.id,
      "nombre": data['nombre'],
      "descripcion": data['descripcion'],
      "fecha": data['fecha'],
      "imagen": data['imagen']
    };

    libro.add(book);
  }

  /*queryLibro.docs.forEach((documento) {
    libro.add(documento.data());
  });*/
  return libro;
}

Future<void> addLibro(String nombre, String descripcion, DateTime fecha, String imagenUrl, double precio, String numeroTelefono) async {
  await FirebaseFirestore.instance.collection('libros').add({
    'nombre': nombre,
    'descripcion': descripcion,
    'fecha': fecha,
    'imagen': imagenUrl,
    'precio': precio,
    'numeroTelefono': numeroTelefono,
  });
}

Future<List<Map<String, dynamic>>> getDataById(String documentId) async {
  CollectionReference collection =
      FirebaseFirestore.instance.collection('libro');
  DocumentSnapshot snapshot = await collection.doc(documentId).get();

  if (snapshot.exists) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return [data]; // Retorna la lista con un solo elemento
  } else {
    return []; // Retorna una lista vacía si no se encuentra el documento
  }
}

Future<void> updateLibro(String lid, String? nombre, String? descripcion,
    DateTime selectedDate, String? imagen, String? precio, String? numeroTelefono) async {
  Timestamp timestamp = Timestamp.fromDate(selectedDate);
  await db.collection("libro").doc(lid).set({
    "nombre": nombre,
    "descripcion": descripcion,
    "fecha": timestamp,
    "imagen": imagen,
    'precio': precio,
    'numeroTelefono': numeroTelefono,
  });
}

Future<void> deleteLibro(String lid) async {
  await db.collection("libro").doc(lid).delete();
}

class LibroService {
  LibroService();

  Future<List<Object>?> getLibros() async {
    List<Result> result = [];
    try {
      var url = Uri.https('gutendex.com', '/books');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        dynamic jsonResponse = json.decode(response.body);

        if (jsonResponse is List) {
          // Verifica si la respuesta es una lista
          for (var item in jsonResponse) {
            var newLibro = Result.fromJson(item);
            result.add(newLibro);
          }
        } else if (jsonResponse is Map) {
          developer.log('Request failed with status: ${response.statusCode}.');
          if (jsonResponse.containsKey("results")) {
            List<dynamic> resultList = jsonResponse["results"];

            for (var item in resultList) {
              var newLibro = Result.fromJson(item);
              result.add(newLibro);
            }
          }
        }
      } else {
        developer.log('Request failed with status: ${response.statusCode}.');
      }
      return result;
    } catch (ex) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('libros').get();
  return querySnapshot.docs;
      developer.log(ex.toString());
      return null;
    }
  }
}
