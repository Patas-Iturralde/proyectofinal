import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:segundointento/services/libro_services.dart';
import 'package:segundointento/services/select_image.dart';
import 'package:segundointento/services/upload_image.dart';
import 'package:segundointento/models/libro_model.dart';
import 'dart:io';

class Actualizar extends StatefulWidget {
  final String lid;
  final Function refreshPage;
  const Actualizar({
    Key? key,
    required this.lid,
    required this.refreshPage,
  }) : super(key: key);

  @override
  State<Actualizar> createState() => _ActualizarState();
}

const List<String> lista = <String>[
  'uno',
  'dos',
  'tres'
]; //Datos que se mostrararn en el combobox
String? selectedNombre;
String? imageurl;
String? insertDescripcion;
DateTime selectedDate = DateTime.now();

class _ActualizarState extends State<Actualizar> {
  late List<Map<String, dynamic>> dataList = [];
  late File _image;
  late String? nombre;
  late String? descripcion;
  late DateTime fecha;
  late String? imageurl;
  File? imagen_to_upload;
  late String lid;

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
    lid = widget.lid;
    _fetchData();
    loadLibros();
  }

  Future<void> _fetchData() async {
    dataList = await getDataById(lid);
    setState(() {
      selectedNombre = dataList[0]['nombre'];
      insertDescripcion = dataList[0]['descripcion'];
    });
  }

  String dropdownValue = lista.first;

  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1500),
      lastDate: DateTime(2024),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (dataList.isEmpty) {
      return CircularProgressIndicator();
    } else {
      // Usar dataList para acceder a sus valores
      nombre = dataList[0]['nombre'];
      descripcion = dataList[0]['descripcion'];
      fecha = (dataList[0]['fecha'] as Timestamp).toDate();
      imageurl = dataList[0]['imagen'];
      //selectedNombre = nombre;
    }
    return Padding(
      padding: EdgeInsets.zero,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          title: Row(
            children: [
              Title(color: Colors.cyan, child: const Text("Actualizar"))
            ],
          ),
        ),
        body: Center(
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Text("Nombre:    "),
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
                value: selectedNombre,
                onChanged: (String? value) {
                  setState(() {
                    selectedNombre = value!;
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
                    color: Colors.brown[300],
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
                  width: 350,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.brown[300],
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
                  initialValue: descripcion,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepPurple),
                    ),
                    labelText: 'Ingrese la descripcion',
                  ),
                  onChanged: (value) {
                    setState(() {
                      insertDescripcion = value;
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
                  onTap: () => _selectDate(context, fecha),
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
                      imagen_to_upload != null
                      ? Image.file(
                          imagen_to_upload!,
                          height: 150,
                        )
                      : SizedBox(height: 150),
                ],
              ),
              ElevatedButton(
                onPressed: () async {
                  if (imagen_to_upload == null) {
                    await updateLibro(lid, selectedNombre, insertDescripcion,
                        selectedDate, imageurl);
                  } else {
                    imageurl = await uploadImage(imagen_to_upload!);

                    await updateLibro(lid, selectedNombre, insertDescripcion,
                        selectedDate, imageurl);
                  }

                  widget.refreshPage();

                  Navigator.pop(context);
                }, // Call the _saveData function
                child: Text("Actualizar"), // Button text
              )
            ],
          ),
        ),
      ),
    );
  }
}
