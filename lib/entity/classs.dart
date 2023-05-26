class Classs {
  late int _idClass;
  late String _nameClass;
  Classs();
  Classs.name(this._nameClass);
  Classs.init(this._nameClass);
  String get nameClass => _nameClass;
  set nameClass(String value) {
    _nameClass = value;
  }

  int get idClass => _idClass;

  set idClass(int value) {
    _idClass = value;
  }

  factory Classs.fromMap(Map<String, dynamic> map) {
    return Classs.init(map['nameClass']);
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'nameClass': _nameClass,
    };
    return map;
  }
}
