// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRequest _$ChatRequestFromJson(Map<String, dynamic> json) => ChatRequest(
  messages: (json['messages'] as List<dynamic>)
      .map((e) => MessageRequest.fromJson(e as Map<String, dynamic>))
      .toList(),
  locale: json['locale'] as String,
);

Map<String, dynamic> _$ChatRequestToJson(ChatRequest instance) =>
    <String, dynamic>{'messages': instance.messages, 'locale': instance.locale};
