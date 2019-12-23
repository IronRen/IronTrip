
/// Time：2019-12-17 11:22
/// User：IronRen
/// Desc：启动页面数据

class SplashImageModel {
  List<Images> images;

  SplashImageModel({this.images});

  SplashImageModel.fromJson(Map<String, dynamic> json) {
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String startdate;
  String fullstartdate;
  String enddate;
  String url;
  String urlbase;
  String copyright;
  String copyrightlink;
  String title;
  String quiz;
  bool wp;
  String hsh;
  int drk;
  int top;
  int bot;

  Images(
      {this.startdate,
        this.fullstartdate,
        this.enddate,
        this.url,
        this.urlbase,
        this.copyright,
        this.copyrightlink,
        this.title,
        this.quiz,
        this.wp,
        this.hsh,
        this.drk,
        this.top,
        this.bot});

  Images.fromJson(Map<String, dynamic> json) {
    startdate = json['startdate'];
    fullstartdate = json['fullstartdate'];
    enddate = json['enddate'];
    url = json['url'];
    urlbase = json['urlbase'];
    copyright = json['copyright'];
    copyrightlink = json['copyrightlink'];
    title = json['title'];
    quiz = json['quiz'];
    wp = json['wp'];
    hsh = json['hsh'];
    drk = json['drk'];
    top = json['top'];
    bot = json['bot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['startdate'] = this.startdate;
    data['fullstartdate'] = this.fullstartdate;
    data['enddate'] = this.enddate;
    data['url'] = this.url;
    data['urlbase'] = this.urlbase;
    data['copyright'] = this.copyright;
    data['copyrightlink'] = this.copyrightlink;
    data['title'] = this.title;
    data['quiz'] = this.quiz;
    data['wp'] = this.wp;
    data['hsh'] = this.hsh;
    data['drk'] = this.drk;
    data['top'] = this.top;
    data['bot'] = this.bot;
    return data;
  }
}

