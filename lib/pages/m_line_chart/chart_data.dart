class ChartData {
  final DateTime date;
  final double? value;
  const ChartData({required this.date, this.value});

  factory ChartData.fromJson(Map<String, dynamic> json) {
    return ChartData(
      date: DateTime.parse(json['date']),
      value: json['value']?.toDouble(),
    );
  }
}
