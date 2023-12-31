import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:pub_puzzler/domain/question.dart';
import 'package:pub_puzzler/domain/question_repository.dart';

const String apiURL = 'https://opentdb.com/api.php';
const String questionType = '&type=multiple';
final QuestionRepository questionRepository = QuestionRepository();

Future<Question> fetchQuestion() async {
  final response = await http.get(Uri.parse('$apiURL?amount=1$questionType'));
  if (response.statusCode == 200) {
    Question question = Question.fromJson(jsonDecode(response.body)['results'][0]);
    await questionRepository.addQuestion(question);
    return question;
  } else {
    throw Exception('Failed to load question');
  }
}

Future<List<Question>> fetchQuestions(int amount) async {
  final response = await http.get(Uri.parse('$apiURL?amount=$amount$questionType'));
  if (response.statusCode == 200) {
    List<Question> questions = (jsonDecode(response.body)['results'] as List).map((item) => Question.fromJson(item)).toList();
    for (final question in questions) {
      await questionRepository.addQuestion(question);
    }
    return questions;
  } else {
    throw Exception('Failed to load questions');
  }
}