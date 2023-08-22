import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:segundointento/models/producto.dart';
import 'dart:developer' as developer;

import '../Models/producto.dart';


class ProductoService {
  ProductoService();

  Future<List<Producto>?> getProductos() async {
    List<Producto> result = [];
    try {
      var url = Uri.http('demo6196295.mockable.io', 'api/tienda');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          return result;
        } else {
          List<dynamic> ListBody = json.decode(response.body);
          for (var item in ListBody) {
            var NewProducto = Producto.fromJson(item);
            result.add(NewProducto);
          }
        }
      } else {
        developer.log('Request failed with status: ${response.statusCode}.');
      }
      return result;
    } catch (ex) {
      developer.log(ex.toString());
      return null;
    }
  }
}
