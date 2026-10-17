import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/utils/base64_bytes_converter.dart';

part 'scan.freezed.dart';
part 'scan.g.dart';

@freezed
abstract class ScanDto with _$ScanDto {
  const factory ScanDto({
    required String name,
    required Map<String, dynamic> geojson,
    required String username,
    required DateTime createdAt,
    @Base64BytesConverter() required Uint8List picture,
  }) = _ScanDto;

  factory ScanDto.fromJson(Map<String, dynamic> json) =>
      _$ScanDtoFromJson(json);
}
