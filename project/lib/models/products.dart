class Products {
  final List<Product> products;
  Products({required this.products});

  factory Products.fromJson(List<dynamic> json) {
    List<Product> productList = json.map((i) => Product.fromJson(i)).toList();

    return Products(products: productList);
  }
}

class Product {
  String code;
  var mainImage;
  String uuid;
  String name;

  Product(
      {required this.code,
      required this.mainImage,
      required this.name,
      required this.uuid});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      code: json['code'],
      mainImage: json['mainImage']['document'].toString().replaceAll('\n', ''),
      uuid: json['uuid'],
      name: json['name'] == null ? "noNameVariable" : json['name'],
    );
  }
}
