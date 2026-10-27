import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:frontend/utils/base64_bytes_converter.dart';

part 'township.freezed.dart';
part 'township.g.dart';

@freezed
abstract class TownshipDto with _$TownshipDto {
  const factory TownshipDto({
    required String scanId,
    required String name,
    required Map<String, dynamic> geojson,
    required String username,
    required DateTime createdAt,
    @Base64BytesConverter() required Uint8List picture,
  }) = _TownshipDto;

  factory TownshipDto.fromJson(Map<String, dynamic> json) =>
      _$TownshipDtoFromJson(json);
}
