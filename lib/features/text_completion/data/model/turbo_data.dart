// To parse this JSON data, do
//
//     final textCompletionModelTurbo = textCompletionModelTurboFromJson(jsonString);

import 'dart:convert';

TextCompletionModelTurbo textCompletionModelTurboFromJson(String str) =>
    TextCompletionModelTurbo.fromJson(json.decode(str));

String textCompletionModelTurboToJson(TextCompletionModelTurbo data) =>
    json.encode(data.toJson());

class TextCompletionModelTurbo {
  TextCompletionModelTurbo({
    this.id,
    this.object,
    this.created,
    this.model,
    this.usage,
    this.choices,
  });

  String? id;
  String? object;
  int? created;
  String? model;
  Usage? usage;
  List<Choice>? choices;

  factory TextCompletionModelTurbo.fromJson(Map<String, dynamic> json) =>
      TextCompletionModelTurbo(
        id: json["id"],
        object: json["object"],
        created: json["created"],
        model: json["model"],
        usage: json["usage"] == null ? null : Usage.fromJson(json["usage"]),
        choices: json["choices"] == null
            ? []
            : List<Choice>.from(
                json["choices"]!.map((x) => Choice.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "object": object,
        "created": created,
        "model": model,
        "usage": usage?.toJson(),
        "choices": choices == null
            ? []
            : List<dynamic>.from(choices!.map((x) => x.toJson())),
      };
}

class Choice {
  Choice({
    this.message,
    this.finishReason,
    this.index,
  });

  Message? message;
  String? finishReason;
  int? index;

  factory Choice.fromJson(Map<String, dynamic> json) => Choice(
        message:
            json["message"] == null ? null : Message.fromJson(json["message"]),
        finishReason: json["finish_reason"],
        index: json["index"],
      );

  Map<String, dynamic> toJson() => {
        "message": message?.toJson(),
        "finish_reason": finishReason,
        "index": index,
      };
}

class Message {
  Message({
    this.role,
    this.content,
  });

  String? role;
  String? content;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        role: json["role"],
        content: json["content"],
      );

  Map<String, dynamic> toJson() => {
        "role": role,
        "content": content,
      };
}

class Usage {
  Usage({
    this.promptTokens,
    this.completionTokens,
    this.totalTokens,
  });

  int? promptTokens;
  int? completionTokens;
  int? totalTokens;

  factory Usage.fromJson(Map<String, dynamic> json) => Usage(
        promptTokens: json["prompt_tokens"],
        completionTokens: json["completion_tokens"],
        totalTokens: json["total_tokens"],
      );

  Map<String, dynamic> toJson() => {
        "prompt_tokens": promptTokens,
        "completion_tokens": completionTokens,
        "total_tokens": totalTokens,
      };
}
