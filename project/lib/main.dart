import 'package:flutter/material.dart';
import 'package:flutter_forms/models/products.dart';
import 'package:flutter_forms/view/login.dart';
import 'package:flutter_forms/models/usersecure.dart';
import 'dart:convert';
import 'package:flutter_forms/view/det.dart';
import 'fetch/fetch.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      color: Colors.yellow,
      title: 'Giriş',
      theme: ThemeData(primarySwatch: Colors.orange),
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.orangeAccent,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "GİRİŞ YAP",
          ),
          leading: new IconButton(
            icon: Icon(Icons.login),
            onPressed: () {},
          ),
        ),
        body: Login(),
      ),
    );
  }
}

class Anasayfa extends StatefulWidget {
  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  bool isLoading = false;
  void initState() {
    super.initState();

    init();
  }

  void refreshScreen() {
    setState(() {
      isLoading = !isLoading;
    });
  }

  Future init() async {
    await UserSecureStorage.getUsername().then((username) => {
          UserSecureStorage.getAuthToken().then((authToken) => {
                fetchProduct(authToken, username).then((value) => {
                      urunler.addAll(value.products),
                      refreshScreen(),
                    })
              })
        });
  }

  TextEditingController editingController = TextEditingController();

  List<Product> urunler = [];

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("ÜRÜN YÖNETİMİ"),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Hızlı Çıkış',
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.logout_sharp),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 15),
          Text(
            "${urunler.length} adet ürün listeleniyor",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          Container(
              child: Expanded(
                  child: Scrollbar(
                      thickness: 8,
                      radius: Radius.circular(20),
                      interactive: true,
                      isAlwaysShown: true,
                      child: ListView.builder(
                        padding: EdgeInsets.all(7),
                        itemCount: urunler.length,
                        itemBuilder: (context, index) => Card(
                          color: Colors.brown.shade50,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                                color: Colors.orangeAccent, width: 5),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: ListTile(
                              leading: Image(
                                  height: 40,
                                  width: 55,
                                  alignment: Alignment.center,
                                  image: new MemoryImage(Base64Decoder()
                                      .convert(urunler[index].mainImage))),
                              trailing: IconButton(
                                  icon: Icon(Icons.edit),
                                  tooltip: 'Düzenle',
                                  color: Colors.orange,
                                  onPressed: () async {
                                    final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                DetPage(urunler[index])));
                                    if (result == 'change') {
                                      refreshScreen();
                                    }
                                  }),
                              title: Column(
                                children: <Widget>[
                                  Align(
                                    alignment: Alignment(-0.99, 0.5),
                                    child: Text(
                                      urunler[index].name,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.99),
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      )))),
          Center(
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetPage(new Product(
                            code: '', mainImage: '', name: '', uuid: ''))));
              },
              child: Text('Yeni Ürün Ekle'),
              style: ElevatedButton.styleFrom(
                  primary: Colors.orange,
                  side: BorderSide(width: 5),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  textStyle:
                      TextStyle(fontSize: 20, fontStyle: FontStyle.italic)),
            ),
          )
        ],
      ),
    );
  }
}

class EditSayfa extends StatefulWidget {
  @override
  _EditSayfa createState() => _EditSayfa();
}

class _EditSayfa extends State<EditSayfa> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("EKLE"),
          centerTitle: true,
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            TextButton(onPressed: () {}, child: Text("LÜTFEN ÜRÜN EKLEYİN")),
            SizedBox(height: 50),
          ],
        )));
  }
}

class Duzenleme extends StatefulWidget {
  @override
  _Duzenleme createState() => _Duzenleme();
}

class _Duzenleme extends State<Duzenleme> {
  TextEditingController editingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("DÜZENLE"),
        ),
        body: Container(
            child: Column(
          children: <Widget>[
            TextButton(
                onPressed: () {}, child: Text("LÜTFEN ÜRÜNÜ DÜZENLEYİN")),
            SizedBox(height: 10),
          ],
        )));
  }
}
