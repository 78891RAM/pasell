// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'userModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['_id'] as String?,
      email: json['email'] as String?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      country: json['country'] as String?,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      '_id': instance.id,
      'email': instance.email,
      'username': instance.username,
      'password': instance.password,
      'country': instance.country,
    };
