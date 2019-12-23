class SearchModel{
  List<Data> data;
  String searchWords;

  SearchModel({this.data});

  SearchModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = new List<Data>();
      json['data'].forEach((v) {
        data.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String word;
  String type;
  String districtname;
  String url;
  String price;
  String star;
  String zonename;

  Data(
      {this.word,
      this.type,
      this.districtname,
      this.url,
      this.price,
      this.star,
      this.zonename});

  Data.fromJson(Map<String, dynamic> json) {
    word = json['word'];
    type = json['type'];
    districtname = json['districtname'];
    url = json['url'];
    price = json['price'];
    star = json['star'];
    zonename = json['zonename'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['word'] = this.word;
    data['type'] = this.type;
    data['districtname'] = this.districtname;
    data['url'] = this.url;
    data['price'] = this.price;
    data['star'] = this.star;
    data['zonename'] = this.zonename;
    return data;
  }
}
