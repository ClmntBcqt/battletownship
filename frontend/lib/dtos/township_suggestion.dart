import 'package:freezed_annotation/freezed_annotation.dart';

part 'township_suggestion.freezed.dart';
part 'township_suggestion.g.dart';

@freezed
abstract class TownshipSuggestionDto with _$TownshipSuggestionDto {
  const factory TownshipSuggestionDto({
    required String code,
    required String nom,
    required List<String> codesPostaux,
  }) = _TownshipSuggestionDto;

  factory TownshipSuggestionDto.fromJson(Map<String, dynamic> json) =>
      _$TownshipSuggestionDtoFromJson(json);
}
