import 'package:equatable/equatable.dart';

class Faq extends Equatable {
  final String? question;
  final String? answer;
  const Faq({this.question, this.answer});
  @override
  List<Object?> get props {
    return [question, answer];
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'question': question,
      'answer': answer,
    };
  }
}
