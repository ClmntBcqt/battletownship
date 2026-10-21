import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_infos.freezed.dart';
part 'user_infos.g.dart';

@freezed
abstract class UserInfos with _$UserInfos {
  const factory UserInfos({required String username, required String email}) =
      _UserInfos;

  factory UserInfos.fromJson(Map<String, dynamic> json) =>
      _$UserInfosFromJson(json);
}
