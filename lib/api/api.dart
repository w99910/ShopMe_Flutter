import 'dart:convert';

import 'package:ShopMe/models/User.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
  void getProduct() async {
    print('hello products');
    try {
      final response =
          await http.get('http://10.0.0.2:8000/api/home/products', headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer Bearer 54|8IJuxbTBbIqQOQyZp7wnkyNOoMvJ7b5GpN5jlfNq'
      });
      print(response.body);
      var body = response.body;
      print(body);
    } catch (e) {
      print(e);
    }
  }

  signIn(User user, bool isRemember) async {
    try {
      print(user.email + '' + user.password);
      final response = await http.post("http://10.0.2.2:8000/api/login", body: {
        'email': user.email,
        'password': user.password,
      });

      if (response.statusCode == 201) {
        var body = response.body;

        var decode = json.decode(response.body);
        print(decode['token']);
        print(jsonEncode(User.fromJson(decode['user'])));
        User authuser = User.fromJson(decode['user']);

        if (isRemember) {
          Map decode_options = jsonDecode(response.body);

          String myuser = jsonEncode(User.fromJson(decode_options['user']));

          SharedPreferences localStorage =
              await SharedPreferences.getInstance();
          localStorage.setString('user', myuser);
          Map userMap = jsonDecode(localStorage.getString('user'));
          var user = User.fromJson(userMap);
        }
        return authuser;
      } else {
        return null;
      }
    } catch (e) {
      print(e);
    }
  }

  signUp(User user) async {
    final String url = 'http://10.0.2.2:8000/api';
    try {
      print(user.name);
      final response = await http.post("$url/signup", body: {
        "username": user.name,
        "email": user.email,
        "password": user.password
      });

      if (response.statusCode == 201) {
        print(response.body);

        var results = jsonDecode(response.body);
        // print(results);
      }
    } catch (e) {
      print(e);
    }
  }

  hasToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return token != null;
  }

  setToken(token) async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('token', token);
  }

  getToken() async {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    var token = localStorage.getString('token');
    return token;
  }
}
