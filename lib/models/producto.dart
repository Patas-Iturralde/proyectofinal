import 'dart:convert';

Producto ProductoFromJson(String str) => Producto.fromJson(json.decode(str));

String ProductoToJson(Producto data) => json.encode(data.toJson());

class Producto {
    int? id;
    String? producto;

    Producto({
        required this.id,
        required this.producto,
    });

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id"],
        producto: json["Producto"],
    );

    factory Producto.init() => 
      Producto(id: 0, producto: "Toyota");

    Map<String, dynamic> toJson() => {
        "id": id,
        "Producto": producto,
    };

    Map<String, dynamic> toMap() {
      return {
        "id": id,
        "Producto": producto,
      };
    }
}
