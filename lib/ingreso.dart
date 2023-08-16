import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:segundointento/services/libro_services.dart';
import 'package:segundointento/services/select_image.dart';
import 'package:segundointento/services/upload_image.dart';
import 'package:segundointento/models/libro_model.dart';
import 'dart:io';

class Ingreso extends StatefulWidget {
  const Ingreso({Key? key}) : super(key: key);

  @override
  State<Ingreso> createState() => _IngresoState();
}

const List<String> lista = <String>[
  'uno',
  'dos',
  'tres'
]; //Datos que se mostrararn en el combobox
String? selectedValue;
String? imageurl;

class _IngresoState extends State<Ingreso> {
  List<Result>? _lista;
  //String fondo = "lib/image/icono.png";
  Future<void> loadLibros() async {
    LibroService service = LibroService();
    _lista = await service.getLibros();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void initState() {
    super.initState();
    loadLibros();
  }

  File? imagen_to_upload;

  String descripcion = "";
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            children: [Title(color: Colors.cyan, child: const Text("Ingreso"))],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text("Marca:    "),
              DropdownButton2(
                isExpanded: true,
                hint: const Row(
                  children: [
                    Icon(
                      Icons.list,
                      size: 16,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Expanded(
                      child: Text(
                        'Select Item',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                items: _lista?.map((Result libro) {
                  return DropdownMenuItem<String>(
                    value: libro.title
                        .toString(), // Usar el título del libro como valor
                    child: Text(
                      libro.title.toString(),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                }).toList(),
                value: selectedValue,
                onChanged: (value) {
                  setState(() {
                    selectedValue = value as String?;
                  });
                },
                buttonStyleData: ButtonStyleData(
                  height: 50,
                  width: 300,
                  padding: const EdgeInsets.only(left: 14, right: 14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.black26,
                    ),
                    color: Colors.deepPurple,
                  ),
                  elevation: 2,
                ),
                iconStyleData: const IconStyleData(
                  icon: Icon(
                    Icons.arrow_forward_ios_outlined,
                  ),
                  iconSize: 14,
                  iconEnabledColor: Colors.yellow,
                  iconDisabledColor: Colors.grey,
                ),
                dropdownStyleData: DropdownStyleData(
                  maxHeight: 200,
                  width: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.deepPurple,
                  ),
                  offset: const Offset(-20, 0),
                  scrollbarTheme: ScrollbarThemeData(
                    radius: const Radius.circular(40),
                    thickness: MaterialStateProperty.all<double>(6),
                    thumbVisibility: MaterialStateProperty.all<bool>(true),
                  ),
                ),
                menuItemStyleData: const MenuItemStyleData(
                  height: 40,
                  padding: EdgeInsets.only(left: 14, right: 14),
                ),
              ),
              SizedBox(height: 20),
              Text("Descripcion:    "),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 30), // Agregado padding al TextField
                child: TextFormField(
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    labelText: 'Ingrese la descripcion',
                  ),
                  onChanged: (value) {
                    setState(() {
                      descripcion = value;
                    });
                  },
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
              Column(
                children: [
                  ElevatedButton(
                      onPressed: () async {
                        final image = await getImage();
                        setState(() {
                          imagen_to_upload = File(image!.path);
                        });
                      },
                      child: Text("Seleccionar Imagen")),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  if (imagen_to_upload == null) {
                    return;
                  }

                  imageurl = await uploadImage(imagen_to_upload!);

                  await addLibro(
                      selectedValue, descripcion, selectedDate, imageurl);

                  Navigator.pop(context, true);
                }, // Call the _saveData function
                child: Text("Guardar"), // Button text
              ),
            ],
          ),
        ),
      ),
    );
  }
}
