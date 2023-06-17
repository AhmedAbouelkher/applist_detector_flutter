import 'package:flutter/foundation.dart' show immutable;

@immutable
class PlayIntegrityResponse {
  final int statusCode;
  final dynamic body;
  final Map<String, String> headers;
  const PlayIntegrityResponse({
    required this.statusCode,
    required this.body,
    required this.headers,
  });
}
