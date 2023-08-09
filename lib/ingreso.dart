import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class Ingreso extends StatefulWidget {
  const Ingreso({Key? key}) : super(key: key);

  @override
  State<Ingreso> createState() => _IngresoState();
}

const List<String> lista = <String>['uno', 'dos', 'tres'];

class _IngresoState extends State<Ingreso> {
  String dropdownValue = lista.first;
  late DateTime selectedDate = DateTime.now();
  late File _image;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            children: [Title(color: Colors.cyan, child: Text("Ingreso"))],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              SizedBox(height: 40),
              Text("Marca:    "),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(150, 0, 0, 0),
                
                child: Row(
                  children: [
                    
                    DropdownButton<String>(
                      value: dropdownValue,
                      icon: const Icon(Icons.arrow_downward),
                      elevation: 16,
                      style: const TextStyle(color: Colors.deepPurple),
                      underline: Container(
                        height: 2,
                        color: Colors.deepPurpleAccent,
                      ),
                      onChanged: (String? value) {
                        setState(() {
                          dropdownValue = value!;
                        });
                      },
                      items:
                          lista.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text("Modelo:    "),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 30), // Agregado padding al TextField
                child: TextFormField(
                    decoration: const InputDecoration(
                  border:  OutlineInputBorder(borderSide: BorderSide(color: Colors.deepPurple),),
                  labelText: 'Ingrese el modelo',
                )
                    // Agrega tus propiedades personalizadas aquí
                    ),
              ),
              SizedBox(height: 20),
              Text("Fecha de lanzamiento:    "),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: InkWell(
                  onTap: () => _selectDate(context),
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple),
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
              ),
              SizedBox(height: 20),
              Text("Foto:    "),
              MaterialButton(
                color: Colors.deepPurple,
                child: Text(
                  "Abrir cámara",
                  style: TextStyle(
                      color: const Color.fromARGB(255, 255, 255, 255), fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  _pickImage();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
