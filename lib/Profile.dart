import 'dart:convert';

import 'package:ShopMe/settings/variable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'models/User.dart';

class ProfilePage extends StatefulWidget {
  User auth_user;
  ProfilePage(this.auth_user);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  User user;
  TextEditingController textControl = TextEditingController();
  TextEditingController oldpassword = TextEditingController();
  changeName(User user, String name) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    var token = store.getString('token');
    if (token != null) {
      try {
        final response = await http.post('http://10.0.2.2:8000/api/change/name',
            headers: {'Authorization': 'Bearer ' + token},
            body: {'id': user.id.toString(), 'name': name});
        print(response.body);
        if (response.statusCode == 201) {
          return null;
        } else
          return response.body;
      } catch (e) {
        print(e);
      }
    }
  }

  changeEmail(User user, String email) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    var token = store.getString('token');
    if (token != null) {
      try {
        final response = await http.post(
            'http://10.0.2.2:8000/api/change/email',
            headers: {'Authorization': 'Bearer ' + token},
            body: {'id': user.id.toString(), 'email': email});
        print(response.body);
        if (response.statusCode == 201) {
          return null;
        } else
          return response.body;
      } catch (e) {
        print(e);
      }
    }
  }

  changePassword(User user, String password, String oldpassword) async {
    SharedPreferences store = await SharedPreferences.getInstance();
    var token = store.getString('token');
    print(token);
    print(user.id);
    print(oldpassword);
    if (token != null) {
      try {
        final response = await http
            .post('http://10.0.2.2:8000/api/change/password', headers: {
          'Authorization': 'Bearer ' + token
        }, body: {
          'id': user.id.toString(),
          "new_password": password,
          'old_password': oldpassword
        });
        print(response.body);
        if (response.statusCode == 201) {
          return null;
        } else
          return json.decode(response.body);
      } catch (e) {
        print(e);
      }
    }
  }

  void setUser(User user) async {
    SharedPreferences store = await SharedPreferences.getInstance();

    String storedUser = jsonEncode(user);
    if (store.getString('user') != null) {
      store.remove('user');
      store.setString('user', storedUser);
    }
  }

  @override
  void initState() {
    super.initState();
    user = new User(
        id: widget.auth_user.id,
        email: widget.auth_user.email,
        password: widget.auth_user.password,
        name: widget.auth_user.name,
        profile: widget.auth_user.profile);
  }

  show(BuildContext context, String word) {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => AlertDialog(
              title: Center(
                child: Icon(
                  Icons.info,
                  size: 30,
                  color: Colors.orangeAccent,
                ),
              ),
              content: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Center(child: Text(word))),
              elevation: 0,
            ));
  }

  Widget alert(String field, BuildContext context) {
    String error = '';
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        title: Text('Change ' + field),
        content: Container(
          height: field == 'password' ? 150 : 80,
          child: Column(
            children: [
              TextField(
                obscureText: field == 'password' ? true : false,
                controller: textControl,
                decoration: InputDecoration(
                    hintText: field == 'password' ? 'New Password' : field,
                    hintStyle: TextStyle(color: Colors.black26)),
              ),
              field == 'password'
                  ? TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          hintText: "Old Password",
                          hintStyle: TextStyle(color: Colors.black26)),
                      controller: oldpassword,
                    )
                  : Spacer(),
              BuildText(text: error, color: Colors.red, fontsize: 15),
            ],
          ),
        ),
        actions: [
          FlatButton(
            padding: EdgeInsets.all(10),
            color: Colors.orangeAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            onPressed: () {
              textControl.clear();
              oldpassword.clear();
              setState(() {
                error = '';
              });
              Navigator.of(context).pop();
            },
            child: Center(
                child:
                    BuildText(text: "Cancel", color: soft_pink, fontsize: 15)),
          ),
          FlatButton(
              padding: EdgeInsets.all(10),
              onPressed: () async {
                print(textControl.text.trim() == '');
                print('hello');
                if (textControl.text.trim() == '') {
                  setState(() {
                    error = 'You must write something';
                  });
                  print(error);
                } else {
                  if (field == 'name') {
                    print('name');
                    var api = await changeName(user, textControl.text);
                    if (api == null) {
                      await setUser(user);
                      setState(() {
                        error = '';
                        user.name = textControl.text;
                      });
                      setUser(user);
                      textControl.clear();
                      await Navigator.of(context).pop();
                      show(context, 'Successfully Changed Name');
                    }
                  }
                  if (field == 'email') {
                    if (RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(textControl.text)) {
                      print('email');
                      final resp = await changeEmail(user, textControl.text);
                      if (resp == null) {
                        await setUser(user);
                        setState(() {
                          user.email = textControl.text;
                        });
                        setUser(user);
                        textControl.clear();
                        await Navigator.of(context).pop();
                        show(context, 'Successfully Changed Email');
                      } else {
                        await Navigator.of(context).pop();
                        show(context, resp);
                      }
                    } else {
                      setState(() {
                        error = 'Invalid Email';
                      });
                    }
                  }
                  if (field == 'password') {
                    if (textControl.text.length > 7) {
                      print('password');
                      var api = await changePassword(
                          user, textControl.text, oldpassword.text);
                      if (api == null) {
                        textControl.clear();
                        oldpassword.clear();
                        await Navigator.of(context).pop();
                        show(context, 'Successfully Changed Password');
                      } else {
                        await Navigator.of(context).pop();
                        show(context, api);
                      }
                    } else {
                      setState(() {
                        error = "Password minimum length must be 7";
                      });
                    }
                  }
                }
              },
              color: Colors.lightBlueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                  child: BuildText(
                      text: "Change", color: soft_pink, fontsize: 15)))
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: soft_pink,
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(
            Icons.arrow_back,
            color: cello,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
            vertical: height * 0.03, horizontal: width * 0.05),
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.only(topRight: Radius.circular(height * 0.05)),
          color: cello,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              CircleAvatar(
                backgroundImage: user.profile == null
                    ? AssetImage('lib/assets/images/add-user.png')
                    : NetworkImage(user.profile),
              ),
              FlatButton(
                onPressed: () {
                  return null;
                },
                color: light_Green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25)),
                child: Center(
                    child: BuildText(
                  text: "Change Profile",
                  color: soft_pink,
                  fontsize: 17,
                )),
              )
            ]),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BuildText(
                  text: user.name,
                  fontsize: 17,
                  color: soft_pink,
                ),
                FlatButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return alert("name", context);
                      },
                    );
                  },
                  color: light_Green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                      child: BuildText(
                    text: "Change Name",
                    color: soft_pink,
                    fontsize: 17,
                  )),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BuildText(
                  text: user.email,
                  fontsize: 17,
                  color: soft_pink,
                ),
                FlatButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert('email', context);
                      },
                    );
                  },
                  color: light_Green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                      child: BuildText(
                    text: "Change Email",
                    color: soft_pink,
                    fontsize: 17,
                  )),
                )
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BuildText(
                  text: "********",
                  fontsize: 17,
                  color: soft_pink,
                ),
                FlatButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return alert('password', context);
                      },
                    );
                  },
                  color: light_Green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  child: Center(
                      child: BuildText(
                    text: "Change Password",
                    color: soft_pink,
                    fontsize: 17,
                  )),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
