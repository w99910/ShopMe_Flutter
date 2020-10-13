import 'dart:convert';

import 'package:ShopMe/models/User.dart';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Api {
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

        SharedPreferences localStorage = await SharedPreferences.getInstance();

        await localStorage.setString('token', decode['token']);
        print(localStorage.getString('token'));
        // print(jsonEncode(User.fromJson(decode['user'])));
        User authuser = User.fromJson(decode['user']);
        Map decode_options = jsonDecode(response.body);

        String myuser = jsonEncode(User.fromJson(decode_options['user']));

        localStorage.setString('user', myuser);
        if (isRemember) {
          localStorage.setBool('remember', true);
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
      }); //sendRequest

      if (response.statusCode == 201) {
        var decode = json.decode(response.body); //decode_The_Response_Json
        User authuser = User.fromJson(decode['user']);

        SharedPreferences storage = await SharedPreferences.getInstance();
        var checkuser = storage.getString('user');
        var checktoken = storage.getString('token');
        var remember = storage.getBool('remember');
        if (remember == null) {
          storage.setBool('remember', true);
        }
        if (checkuser == null) {
          String myuser = jsonEncode(User.fromJson(decode[
              'user'])); //EncodetheJson_because_Shared_prefrences_store_string_or_integer
          //nowWecanstore_encoded_value
          storage.setString('user', myuser); //completeStore
        }

        if (checktoken == null) {
          //Store the token if there is no token
          storage.setString('token', decode['token']);
        }
        //To get the stored user
        Map userMap = await jsonDecode(storage.getString('user'));
        var user = User.fromJson(userMap);
        print(user);
        return authuser;
      }
    } catch (e) {
      print(e);
    }
  }
}
