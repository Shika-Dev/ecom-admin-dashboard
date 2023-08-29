class SliderModel {
  String? image;
  String? text;
  String? altText;
  String? bAltText;
  String? productImage;
  int? kBackgroundColor;

  SliderModel(this.image, this.text, this.altText, this.bAltText,
      this.productImage, this.kBackgroundColor);

  SliderModel.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    kBackgroundColor = json['kBackgroundColor'];
    text = json['text'];
    altText = json['altText'];
    bAltText = json['bAltText'];
    productImage = json['productImage'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = this.image;
    data['kBackgroundColor'] = this.kBackgroundColor;
    data['text'] = this.text;
    data['altText'] = this.altText;
    data['bAltText'] = this.bAltText;
    data['productImage'] = this.productImage;
    return data;
  }
}

List<SliderModel> slides =
    slideData.map((item) => SliderModel.fromJson(item)).toList();

var slideData = [
  {
    "image": "assets/slides/background-1.jpeg",
    "kBackgroundColor": 0xFF2c614f,
    "text": "Welcome to the Smart Smart Admin Dashboard!",
    "altText": "You can access & track your services in real-time.",
    "bAltText": "Are you ready for the next generation Dashboard?",
    "productImage": "assets/logo/sevva_logo.png"
  },
  {
    "image": "assets/slides/background-2.jpeg",
    "kBackgroundColor": 0xFF8a1a4c,
    "text": "Welcome to the Smart Smart Admin Dashboard!",
    "altText": "You can update, and manage your order",
    "bAltText": "Are you ready for the next generation Dashboard?",
    "productImage": "assets/logo/sevva_logo.png"
  },
  {
    "image": "assets/slides/background-3.jpeg",
    "kBackgroundColor": 0xFF0ab3ec,
    "text": "Welcome to the Smart Smart Admin Dashboard!",
    "altText": "Manage your product with ease",
    "bAltText": "Are you ready for the next generation Dashboard?",
    "productImage": "assets/logo/sevva_logo.png"
  }
];
