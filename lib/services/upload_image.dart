import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

final FirebaseStorage storage = FirebaseStorage.instance;

Future<String> uploadImage(File image) async {
  print(image.path);
  //obtenemos el nombre de la imagen para mandar a la storage de firebase
  final String namefile = image.path.split("/").last;

  final Reference ref = storage.ref().child("images").child(namefile);
  final UploadTask uploadTask = ref.putFile(image);
  final TaskSnapshot snapshot = await uploadTask.whenComplete(() => true);

  return ref.getDownloadURL();
}
