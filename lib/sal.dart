class SAL {
  final double ec;
  final double sal;
  final double temp;

  SAL({this.ec, this.sal, this.temp});

  factory SAL.fromJson(Map<dynamic, dynamic> json) {
    double parser(dynamic source) {
      try {
        return double.parse(source.toString());
      } on FormatException {
        return -1;
      }
    }

    return SAL(
        ec: parser(json['ec']),
        sal: parser(json['sal']),
        temp: parser(json['temp'])
        );
  }
}