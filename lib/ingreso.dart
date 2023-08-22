import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:segundointento/services/select_image.dart';
import 'package:segundointento/services/upload_image.dart';
import 'dart:io';

class Ingreso extends StatefulWidget {
  const Ingreso({Key? key}) : super(key: key);

  @override
  State<Ingreso> createState() => _IngresoState();
}

const List<String> lista = <String>[
  'Azucar',
  'Leche',
  'Pan',
  'Galletas',
  'Harina',
  'Agua',
  'Cola',
  'Chocolate',
  'Papas',
  'Detergente'
]; //Datos que se mostrarán en el combobox

String? selectedValue;
String? imageurl;

class _IngresoState extends State<Ingreso> {
  File? imagen_to_upload;
  String descripcion = "";
  String precio = "";
  String numeroTelefono = "";

  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Future<void> _uploadAndSave() async {
    if (imagen_to_upload == null) {
      return;
    }

    imageurl = await uploadImage(imagen_to_upload!);

    try {
      await FirebaseFirestore.instance.collection('libro').add({
        'nombre': selectedValue,
        'descripcion': descripcion,
        'fecha': selectedDate,
        'imagen': imageurl!,
        'precio': double.parse(precio),
        'numeroTelefono': numeroTelefono,
      });
      print('Datos guardados en Firebase Firestore');
    } catch (error) {
      print('Error al guardar los datos en Firebase Firestore: $error');
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Row(
          children: [Title(color: Colors.cyan, child: const Text("Ingreso"))],
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text("Producto:    "),
              DropdownButton<String>(
                isExpanded: true,
                hint: const Text('Seleccione un item'),
                items: lista
                    .map((String item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(item),
                        ))
                    .toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text("Descripcion:    "),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                  labelText: 'Ingrese la descripción',
                ),
                onChanged: (value) {
                  setState(() {
                    descripcion = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text("Fecha de caducidad:    "),
              InkWell(
                onTap: () => _selectDate(context),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.brown),
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${selectedDate.toLocal()}".split(' ')[0]),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Text("Precio:    "),
              TextFormField(
                keyboardType: TextInputType.number, // Teclado numérico
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                  labelText: 'Ingrese el precio',
                ),
                onChanged: (value) {
                  setState(() {
                    precio = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text("Número de Teléfono:    "),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.brown),
                  ),
                  labelText: 'Ingrese el número de teléfono',
                ),
                onChanged: (value) {
                  setState(() {
                    numeroTelefono = value;
                  });
                },
              ),
              SizedBox(height: 20),
              Text("Foto:    "),
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      final image = await getImage();
                      setState(() {
                        imagen_to_upload = File(image!.path);
                      });
                    },
                    child: Text("Seleccionar Imagen"),
                  ),
                  imagen_to_upload != null
                      ? Image.file(
                          imagen_to_upload!,
                          height: 150,
                        )
                      : SizedBox(height: 150),
                ],
              ),
              ElevatedButton(
                onPressed: _uploadAndSave,
                child: Text("Guardar"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
