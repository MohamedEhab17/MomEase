import 'package:equatable/equatable.dart';

import 'package:new_mama/feature/depression/domain/entities/option.dart';

class Question extends Equatable {
  final int id;
  final String text;
  final String textAr;
  final List<Option> options;

  const Question({
    required this.id,
    required this.text,
    required this.textAr,
    this.options = const [],
  });

  Question copyWith({
    int? id,
    String? text,
    String? textAr,
    List<Option>? options,
  }) {
    return Question(
      id: id ?? this.id,
      text: text ?? this.text,
      textAr: textAr ?? this.textAr,
      options: options ?? this.options,
    );
  }

  @override
  List<Object?> get props => [id, text, textAr, options];
}

