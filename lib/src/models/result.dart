import 'package:flutter/foundation.dart';

enum DetectorResultType {
  notFound,
  methodUnavailable,
  suspicious,
  found,
}

@immutable
class DetectorResult {
  final DetectorResultType type;
  const DetectorResult({
    required this.type,
  });

  factory DetectorResult.fromMap(Map<dynamic, dynamic> map) {
    return DetectorResult(
      type: parseTypeString(map['type']),
    );
  }

  @override
  String toString() => 'DetectorResult(type: $type)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is DetectorResult && other.type == type;
  }

  @override
  int get hashCode => type.hashCode;
}

DetectorResultType parseTypeString(String type) {
  final data = {
    "NOT_FOUND": DetectorResultType.notFound,
    "METHOD_UNAVAILABLE": DetectorResultType.methodUnavailable,
    "SUSPICIOUS": DetectorResultType.suspicious,
    "FOUND": DetectorResultType.found,
  };
  return data[type] ?? DetectorResultType.notFound;
}
