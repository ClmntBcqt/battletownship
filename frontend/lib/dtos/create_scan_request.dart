import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/utils/base64_bytes_converter.dart';

part 'create_scan_request.freezed.dart';
part 'create_scan_request.g.dart';

@freezed
abstract class CreateScanRequest with _$CreateScanRequest {
  const factory CreateScanRequest({
    required String townshipName,
    @Base64BytesConverter() required Uint8List picture,
  }) = _CreateScanRequest;

  factory CreateScanRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateScanRequestFromJson(json);
}
