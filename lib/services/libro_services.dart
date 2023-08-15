import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

Future<List> getLibro() async {
  List libro = [];
  CollectionReference collectionReferenceLibro = db.collection('libro');

  QuerySnapshot queryLibro = await collectionReferenceLibro.get();

  queryLibro.docs.forEach((documento) {
    libro.add(documento.data());
  });
  return libro;
}

Future<void> addLibro(String? nombre, String? descripcion,
    DateTime selectedDate, String? imagen) async {
  Timestamp timestamp = Timestamp.fromDate(selectedDate);
  await db.collection("libro").add({
    "nombre": nombre,
    "descripcion": descripcion,
    "fecha": timestamp,
    "imagen": imagen
  });
}
