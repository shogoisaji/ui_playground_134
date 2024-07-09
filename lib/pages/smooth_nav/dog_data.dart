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
    final List<DogData> list = [];
    for (int i = 0; i < count; i++) {
      final image = await _fetchImage();
      list.add(DogData(
        image: image,
        name: dogs[i]["name"] as String,
        description: dogs[i]["description"] as String,
        rating: dogs[i]["rating"] as double,
      ));
    }
    return list;

    /// ランダムにならない可能性がある。パフォーマンスは良い
    ///
    // final futures = List.generate(count, (i) async {
    //   final image = await _fetchImage();
    //   return DogData(
    //     image: image,
    //     name: dogs[i]["name"] as String,
    //     description: dogs[i]["description"] as String,
    //     rating: dogs[i]["rating"] as double,
    //   );
    // });
    // return await Future.wait(futures);
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
        "日本原産の中型犬で、忠実で賢い性格が特徴。赤、黒、白などの毛色があり、くるりと巻いた尻尾が愛らしい。警戒心が強く、番犬として優秀。運動量が多く、活発な犬種です。独立心が強く、飼い主との絆を大切にします。古くから日本人に愛され、忠犬ハチ公として有名な秋田犬の親戚でもあります。適度な運動と訓練が必要で、しつけをしっかりすることで素晴らしい家族の一員となります。",
    "rating": 4.8,
  },
  {
    "name": "ゴールデンレトリバー",
    "description":
        "優しい性格と知性を兼ね備えた大型犬。金色の美しい被毛が特徴で、家族向けのペットとして人気。水泳が得意で、救助犬や介助犬としても活躍。子供との相性も抜群です。非常に従順で訓練しやすく、飼い主の指示に喜んで従います。運動量が多いため、毎日の散歩やアクティビティが必要です。優しい性格ゆえに番犬には向きませんが、その代わりに家族全員と深い絆を築くことができます。定期的なグルーミングが必要ですが、その分家族との時間を楽しめます。",
    "rating": 4.7,
  },
  {
    "name": "コーギー",
    "description":
        "イギリス王室に愛される小型犬。短い脚と長い胴体が特徴的で、賢く活発な性格。牧畜犬としての歴史があり、頭が良く訓練しやすい。愛嬌があり、家族との絆を大切にします。体は小さいですが、エネルギッシュで活発な犬種です。知的で学習能力が高く、様々な芸を覚えることができます。警戒心もあるため、番犬としての役割も果たせます。定期的な運動と精神的な刺激が必要で、パズルのおもちゃなどで遊ぶのも好きです。被毛の手入れは比較的簡単ですが、抜け毛が多いので注意が必要です。",
    "rating": 4.6,
  },
  {
    "name": "シベリアンハスキー",
    "description":
        "シベリア原産の中型犬で、青や茶色の美しい目が特徴。寒冷地での犬ぞり用に bred された犬種。エネルギッシュで知的、独立心が強い。定期的な運動が必要で、遠吠えが得意です。非常に活発で、毎日長時間の運動が必要です。知能が高く、問題解決能力に優れていますが、頑固な一面もあります。pack 動物なので、家族との強い絆を形成しますが、見知らぬ人にも友好的です。厚い被毛のため、暑さに弱く、定期的なブラッシングが必要です。escape artist としても知られ、しっかりとした囲いが必要です。",
    "rating": 4.5,
  },
  {
    "name": "トイプードル",
    "description":
        "小型で知的、洗練された外見の犬種。巻き毛の被毛が特徴で、様々な色やカットスタイルがある。アレルギー反応が少なく、賢くてトレーニングしやすい。長寿で、愛玩犬として人気です。非常に賢く、サーカスの芸犬としても活躍するほどトレーニング性に優れています。人懐っこく、家族との強い絆を形成します。運動量は中程度で、室内でも十分に飼育できます。ただし、知的刺激を必要とするため、パズルやトレーニングで精神的な運動を提供することが重要です。被毛は抜け毛が少ないですが、定期的なグルーミングとトリミングが必要です。",
    "rating": 4.4,
  },
];
