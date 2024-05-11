import 'dart:convert';

class Noti {
  int srNo;
  String notiTitle;
  String notiContent;
  String imageUrl;

  Noti({
    required this.srNo,
    required this.notiTitle,
    required this.notiContent,
    required this.imageUrl,
  });

  factory Noti.fromJson(Map<String, dynamic> json) {
    return Noti(
      srNo: json['Sr. No'] as int,
      notiTitle: json['Noti Title'] as String,
      notiContent: json['Noti Content'] as String,
      imageUrl: json['Image Url'] as String,
    );
  }

  String toJsonString() {
    Map<String, dynamic> jsonMap = {
      "Sr. No": srNo,
      "Noti Title": notiTitle,
      "Noti Content": notiContent,
      "Image Url": imageUrl
    };
    return jsonEncode(jsonMap, toEncodable: utf8Encode);
  }

  // Utility function to encode non-UTF-8 characters
  dynamic utf8Encode(dynamic object) {
    if (object is String) {
      return utf8.encode(object);
    }
    return object;
  }
}
