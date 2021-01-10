class ThemeStock {
  String stockName;
  String ratesDay;
  String ratesAverage;

  ThemeStock({this.stockName, this.ratesDay, this.ratesAverage});
  ThemeStock.fromMap(Map<String, dynamic> map)
      : stockName = map['stockName'],
        ratesDay = map['ratesDay'],
        ratesAverage = map['ratesAverage'];

  ThemeStock.fromJson(Map<String, dynamic> json)
      : stockName = json['stockName'],
        ratesDay = json['ratesDay'],
        ratesAverage = json['ratesAverage'];
}
