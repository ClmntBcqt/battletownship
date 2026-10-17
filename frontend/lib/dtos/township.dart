import 'package:freezed_annotation/freezed_annotation.dart';

part 'township.freezed.dart';
part 'township.g.dart';

@freezed
abstract class TownshipDto with _$TownshipDto {
  const factory TownshipDto({
    required String name,
    required Map<String, dynamic> geojson,
  }) = _TownshipDto;

  factory TownshipDto.fromJson(Map<String, dynamic> json) =>
      _$TownshipDtoFromJson(json);
}
