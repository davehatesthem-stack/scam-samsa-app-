import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

class HomeRepository {
  static Future<List> GetSamsa() async {
    try {
      final response = await http.get(
        Uri.parse("https://6b043efc9e7cafb37dc01ceb.mockapi.io/samsa"),
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        // * Success
        return json.decode(response.body);
      } else {
        throw HttpException(response.body);
      }
    } on TimeoutException catch (_) {
      throw TimeoutException(
        "Slow internet connection try again with differnt network",
      );
    } on SocketException catch (_) {
      throw SocketException(
        "Check your connection and try again dont use ucell",
      );
    } catch (e) {
      throw Exception('Something went wrong !');
    }
  }

  static Future<void> addLaptop(Map data) async {
    print('Data $data');
    try {
      final response = await http.post(
        Uri.parse("https://6b043efc9e7cafb37dc01ceb.mockapi.io/samsa"),
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
        body: json.encode(data),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // * Success
        print('Malumot qoshildi');
      } else {
        throw HttpException(response.body);
      }
    } on TimeoutException catch (_) {
      throw TimeoutException(
        "Slow internet connection try again with differnt network",
      );
    } on SocketException catch (_) {
      throw SocketException(
        "Check your connection and try again dont use ucell",
      );
    } catch (e) {
      throw Exception('Something went wrong !');
    }
  }

  static Future<void> SamsaDelete(String id) async {
    try {
      final response = await http.delete(
        Uri.parse("https://6b043efc9e7cafb37dc01ceb.mockapi.io/samsa"),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        // * Success
      } else {
        throw HttpException("Something went wrong !");
      }
    } on SocketException catch (_) {
      throw SocketException("Slow connection try again !");
    } on TimeoutException catch (_) {
      throw TimeoutException("Slow network try again !");
    } catch (e) {
      throw Exception('Something went wrong !');
    }
  }
}