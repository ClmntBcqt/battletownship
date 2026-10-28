import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/utils/base64_bytes_converter.dart';

part 'scan.freezed.dart';
part 'scan.g.dart';

@freezed
abstract class ScanDto with _$ScanDto {
  const factory ScanDto({
    required String id,
    required String townshipName,
    required DateTime createdAt,
    required bool hasTownship,
    required int reportNumber,
    @Base64BytesConverter() required Uint8List picture,
  }) = _ScanDto;

  factory ScanDto.fromJson(Map<String, dynamic> json) =>
      _$ScanDtoFromJson(json);
}
