import 'package:device_info/device_info.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:flutter/material.dart';

Color soft_pink = Hexcolor('#F1EEF9');
Color cello = Hexcolor('#28385e');
Color alert = Hexcolor('#FFAE33');
Color cello_600 = Hexcolor('#243255');
Color light_Green = Hexcolor('#78b0a0');
Color green_200 = Hexcolor('#709078');

class BuildText extends StatelessWidget {
  final String text;
  final FontWeight bold;
  final double fontsize;
  final Color color;
  final FontStyle italic;

  const BuildText({
    Key key,
    this.text,
    this.fontsize,
    this.color,
    this.bold,
    this.italic,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontsize,
          color: color,
          fontWeight: bold,
          fontStyle: italic),
    );
  }
}

class DeviceInfo {
  getDevicemodel() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.model;
  }
}

class Provide extends ChangeNotifier {
  bool isLoading = false;
  bool get loading => isLoading;
  set loading(bool val) {
    isLoading = val;
    notifyListeners();
  }

  toggle() {
    isLoading = !isLoading;
  }
}
