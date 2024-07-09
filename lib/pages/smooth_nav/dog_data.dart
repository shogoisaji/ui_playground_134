import 'dart:convert';

import 'package:flutter/widgets.dart';

import 'package:http/http.dart' as http;

class DogData {
  final Image image;
  final String name;
  final String description;
  final double rating;
  const DogData(
      {required this.image,
      required this.name,
      required this.description,
      required this.rating});

  static Future<List<DogData>> createData(int count) async {
    if (count > dogs.length) throw Exception("Count is out of range");
    final futures = List.generate(count, (i) async {
      final image = await _fetchImage();
      return DogData(
        image: image,
        name: dogs[i]["name"] as String,
        description: dogs[i]["description"] as String,
        rating: dogs[i]["rating"] as double,
      );
    });
    return await Future.wait(futures);
  }

  static Future<Image> _fetchImage() async {
    const dogImageUrl = "https://dog.ceo/api/breeds/image/random";

    final response = await http.get(Uri.parse(dogImageUrl));

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return Image.network(
        data['message'],
        fit: BoxFit.cover,
      );
    }
    throw Exception("Failed to load image");
  }
}

const List<Map<String, dynamic>> dogs = [
  {
    "name": "柴犬",
    "description":
        "日本原産の中型犬で、忠実で賢い性格が特徴。赤、黒、白などの毛色があり、くるりと巻いた尻尾が愛らしい。警戒心が強く、番犬として優秀。運動量が多く、活発な犬種です。",
    "rating": 4.8,
  },
  {
    "name": "ゴールデンレトリバー",
    "description":
        "優しい性格と知性を兼ね備えた大型犬。金色の美しい被毛が特徴で、家族向けのペットとして人気。水泳が得意で、救助犬や介助犬としても活躍。子供との相性も抜群です。",
    "rating": 4.7,
  },
  {
    "name": "コーギー",
    "description":
        "イギリス王室に愛される小型犬。短い脚と長い胴体が特徴的で、賢く活発な性格。牧畜犬としての歴史があり、頭が良く訓練しやすい。愛嬌があり、家族との絆を大切にします。",
    "rating": 4.6,
  },
  {
    "name": "シベリアンハスキー",
    "description":
        "シベリア原産の中型犬で、青や茶色の美しい目が特徴。寒冷地での犬ぞり用に bred された犬種。エネルギッシュで知的、独立心が強い。定期的な運動が必要で、遠吠えが得意です。",
    "rating": 4.5,
  },
  {
    "name": "トイプードル",
    "description":
        "小型で知的、洗練された外見の犬種。巻き毛の被毛が特徴で、様々な色やカットスタイルがある。アレルギー反応が少なく、賢くてトレーニングしやすい。長寿で、愛玩犬として人気です。",
    "rating": 4.4,
  },
];
