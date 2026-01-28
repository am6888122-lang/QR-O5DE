class QRCodeModel {
  int? id;
  String type;
  String data;
  int timestamp;

  QRCodeModel({
    this.id,
    required this.type,
    required this.data,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {'type': type, 'data': data, 'timestamp': timestamp};
  }

  factory QRCodeModel.fromMap(Map<String, dynamic> map) {
    return QRCodeModel(
      id: map['_id'],
      type: map['type'],
      data: map['data'],
      timestamp: map['timestamp'],
    );
  }
}
