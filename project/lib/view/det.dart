import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_forms/fetch/fetch.dart';
import 'package:flutter_forms/models/products.dart';
import 'package:flutter_forms/models/usersecure.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_forms/main.dart';
import 'dart:io' as Io;

final ImagePicker _picker = ImagePicker();

class DetPage extends StatefulWidget {
  final Product index;
  DetPage(this.index);

  @override
  _DetPageState createState() => _DetPageState();
}

class _DetPageState extends State<DetPage> {
  TextEditingController productnameController = TextEditingController();

  TextEditingController codeController = TextEditingController();

  Widget productnameButton() {
    return TextFormField(
      controller: productnameController,
      style: TextStyle(fontSize: 18, height: 0.4),
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          hintText: ('${widget.index.name}'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      onSaved: (value) {},
    );
  }

  Widget productcodeButton() {
    return TextFormField(
      controller: codeController,
      style: TextStyle(fontSize: 18, height: 0.4),
      decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
          hintText: ('${widget.index.code}'),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
      onSaved: (value) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    this.codeController.text = widget.index.code;
    this.productnameController.text = widget.index.name;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('DÜZENLE'),
          actions: <Widget>[
            PopupMenuButton(
                itemBuilder: (context) => [
                      PopupMenuItem(
                        child: Text("Galeriden Fotoğraf Ekle"),
                        value: 1,
                      ),
                      PopupMenuItem(
                        child: Text("Kamera"),
                        value: 2,
                      ),
                    ],
                onSelected: (int menu) async {
                  if (menu == 1) {
                    final XFile? image =
                        await _picker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      if (image != null) {
                        final bytes = Io.File(image.path).readAsBytesSync();
                        String img64 = base64Encode(bytes);
                        widget.index.mainImage = img64;
                      }
                    });
                  } else if (menu == 2) {
                    final XFile? photo =
                        await _picker.pickImage(source: ImageSource.camera);
                    setState(() {
                      if (photo != null) {
                        final bytes = Io.File(photo.path).readAsBytesSync();
                        String img64 = base64Encode(bytes);
                        widget.index.mainImage = img64;
                      }
                    });
                  }
                })
          ],
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          SizedBox(height: 18),
          widget.index.mainImage.toString().compareTo("") == 0
              ? Container()
              : Container(
                  width: 300.0,
                  height: 200.0,
                  padding: EdgeInsets.all(70),
                  decoration: new BoxDecoration(
                    shape: BoxShape.rectangle,
                    image: new DecorationImage(
                      fit: BoxFit.fill,
                      image: new MemoryImage(
                          Base64Decoder().convert(widget.index.mainImage)),
                    ),
                  ),
                ),
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 10.0,
              horizontal: 20.0,
            ),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Ürün Adı",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.orange,
                    ),
                  ),
                  SizedBox(height: 5),
                  productnameButton(),
                  SizedBox(height: 16),
                  Text(
                    "Ürün Kodu",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.orange),
                  ),
                  SizedBox(height: 5),
                  productcodeButton(),
                ],
              ),
            ),
          ),
          SizedBox(height: 5),
          widget.index.uuid == ""
              ? Container()
              : Center(
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                          barrierDismissible: false,
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Ürünü Sil",
                                  style: TextStyle(
                                    fontSize: 20,
                                  )),
                              backgroundColor: Colors.brown.shade50,
                              content: Text("Seçtiğiniz Ürün Silinsin Mi?",
                                  style: TextStyle(
                                    fontSize: 18,
                                  )),
                              actions: <Widget>[
                                MaterialButton(
                                    child: Text("İPTAL",
                                        style: TextStyle(
                                          fontSize: 16,
                                        )),
                                    onPressed: () => Navigator.pop(context)),
                                MaterialButton(
                                  child: Text("SİL",
                                      style: TextStyle(
                                        fontSize: 16,
                                      )),
                                  onPressed: () {
                                    UserSecureStorage.getUsername()
                                        .then((value) => {
                                              UserSecureStorage.getAuthToken()
                                                  .then((authToken) => {
                                                        if (widget.index.uuid !=
                                                            "")
                                                          {
                                                            fetchDelete(
                                                                    widget
                                                                        .index,
                                                                    value,
                                                                    authToken)
                                                                .then(
                                                                    (statusCode) =>
                                                                        {
                                                                          if (statusCode >= 200 &&
                                                                              statusCode < 300)
                                                                            {
                                                                              Navigator.pop(context, 'change'),
                                                                              Navigator.pop(context, 'change'),
                                                                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Anasayfa())),
                                                                            }
                                                                        })
                                                          }
                                                      })
                                            });
                                  },
                                )
                              ],
                            );
                          });
                    },
                    child: Text('Ürünü Sil'),
                    style: ElevatedButton.styleFrom(
                        primary: Colors.orange,
                        side: BorderSide(width: 5),
                        padding:
                            EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                        textStyle: TextStyle(
                            fontSize: 20, fontStyle: FontStyle.italic)),
                  ),
                ),
          SizedBox(height: 12),
          Container(
            child: ElevatedButton(
              onPressed: () {
                widget.index.code = codeController.text;
                widget.index.name = productnameController.text;
                UserSecureStorage.getUsername().then((value) => {
                      UserSecureStorage.getAuthToken().then((authToken) => {
                            if (widget.index.code == "" &&
                                widget.index.name == "")
                              {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          backgroundColor: Colors.brown.shade50,
                                          title: Text("DİKKAT",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold)),
                                          content: Text(
                                              "Ürün adı ve ürün kodu boş bırakılamaz!",
                                              style: TextStyle(
                                                fontSize: 18,
                                              )),
                                          actions: <Widget>[
                                            MaterialButton(
                                                child: Text("Geri Dön",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    )),
                                                onPressed: () =>
                                                    Navigator.pop(context)),
                                          ]);
                                    })
                              }
                            else if (widget.index.code == "")
                              {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          backgroundColor: Colors.brown.shade50,
                                          title: Text("DİKKAT",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold)),
                                          content:
                                              Text("Ürün kodu boş bırakılamaz!",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  )),
                                          actions: <Widget>[
                                            MaterialButton(
                                                child: Text("Geri Dön",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    )),
                                                onPressed: () =>
                                                    Navigator.pop(context)),
                                          ]);
                                    })
                              }
                            else if (widget.index.name == "")
                              {
                                showDialog(
                                    barrierDismissible: false,
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                          backgroundColor: Colors.brown.shade50,
                                          title: Text("DİKKAT",
                                              style: TextStyle(
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold)),
                                          content:
                                              Text("Ürün adı boş bırakılamaz!",
                                                  style: TextStyle(
                                                    fontSize: 18,
                                                  )),
                                          actions: <Widget>[
                                            MaterialButton(
                                                child: Text("Geri Dön",
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                    )),
                                                onPressed: () =>
                                                    Navigator.pop(context)),
                                          ]);
                                    })
                              }
                            else if (widget.index.uuid != "")
                              {
                                fetchUpdate(widget.index, value, authToken)
                                    .then((statusCode) => {
                                          if (statusCode >= 200 &&
                                              statusCode < 300)
                                            {
                                              Navigator.pop(context, 'change'),
                                            }
                                        })
                              }
                            else
                              {
                                fetchSave(widget.index, value, authToken)
                                    .then((statusCode) => {
                                          if (statusCode >= 200 &&
                                              statusCode < 300)
                                            {
                                              Navigator.pop(context, 'change'),
                                              Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          Anasayfa())),
                                            }
                                        })
                              }
                          })
                    });
              },
              child: Text('KAYDET'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  side: BorderSide(width: 5),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                  textStyle:
                      TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
            ),
          ),
        ]));
  }
}
