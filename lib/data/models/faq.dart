import 'dart:convert';

import 'package:equatable/equatable.dart';

class Faq extends Equatable {
  final String? question;
  final String? answer;
  const Faq({
    this.question,
    this.answer,
  });
  @override
  List<Object?> get props => [question, answer];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'question': question,
      'answer': answer,
    };
  }

  Faq copyWith({
    String? question,
    String? answer,
  }) {
    return Faq(
      question: question ?? this.question,
      answer: answer ?? this.answer,
    );
  }

  factory Faq.fromMap(Map<String, dynamic> map) {
    return Faq(
      question: map['question'] != null ? map['question'] as String : null,
      answer: map['answer'] != null ? map['answer'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Faq.fromJson(String source) => Faq.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  bool get stringify => true;
}
