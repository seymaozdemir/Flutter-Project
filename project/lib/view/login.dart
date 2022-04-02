import 'package:flutter/material.dart';
import 'package:flutter_forms/fetch/fetch.dart';
import 'package:flutter_forms/main.dart';
import 'package:flutter_forms/models/usersecure.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

final _storage = FlutterSecureStorage();

class Login extends StatefulWidget {
  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  TextEditingController kullaniciadiController = TextEditingController();
  TextEditingController sifreController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    final name = await UserSecureStorage.getUsername();
    {
      this.kullaniciadiController.text = name == null ? "" : name;
    }
    final password = await UserSecureStorage.getSifre();
    {
      this.sifreController.text = password == null ? "" : password;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: 100.0,
        horizontal: 40.0,
      ),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              "Kullanıcı Adı",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            emailButton(),
            SizedBox(height: 50),
            Text(
              "Şifre",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: 10),
            sifreButton(),
            SizedBox(height: 60),
            submitButton(),
          ],
        ),
      ),
    );
  }

  Widget emailButton() {
    return TextFormField(
      controller: kullaniciadiController,
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(Icons.account_box),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black),
          ),
          hintText: "Lütfen Kullanıcı Adınızı Girin",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      onSaved: (value) {},
    );
  }

  Widget sifreButton() {
    return TextFormField(
      controller: sifreController,
      obscureText: true,
      style: TextStyle(fontSize: 15),
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          prefixIcon: Icon(Icons.password),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.black),
          ),
          hintText: "Lütfen Şifrenizi Girin",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      onSaved: (value) {},
    );
  }

  Widget submitButton() {
    return ElevatedButton(
        child: Text("GİRİŞ", textAlign: TextAlign.start),
        style: ElevatedButton.styleFrom(
            primary: Colors.orange,
            side: BorderSide(width: 5),
            minimumSize: Size(360, 60),
            textStyle: TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
        onPressed: () async {
          await UserSecureStorage.setUsername(kullaniciadiController.text);
          await UserSecureStorage.setSifre(sifreController.text);

          fetchUser(kullaniciadiController.text, sifreController.text)
              .then((value) => {
                    if (value.success)
                      {
                        _storage.write(
                            key: "authToken", value: value.authorization),
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Anasayfa()),
                        )
                      }
                    else
                      {
                        showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                  backgroundColor: Colors.brown.shade50,
                                  title: Text("HATALI GİRİŞ",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 22,
                                        color: Colors.red.shade900,
                                        fontWeight: FontWeight.bold,
                                      )),
                                  content:
                                      Text("Kullanıcı Adı ya da Şifre Yanlış!",
                                          style: TextStyle(
                                            fontSize: 18,
                                          )),
                                  actions: <Widget>[
                                    MaterialButton(
                                        child: Text("Geri Dön",
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        onPressed: () =>
                                            Navigator.pop(context)),
                                  ]);
                            })
                      }
                  });
        });
  }
}
