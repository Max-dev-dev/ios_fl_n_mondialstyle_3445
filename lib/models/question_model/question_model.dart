class QuizQuestion {
  final String question;
  final List<String> options;
  final int correctIndex;

  QuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
  });
}

class QuizResult {
  final String title;
  final String image;
  final String description;

  QuizResult({
    required this.image,
    required this.title,
    required this.description,
  });
}
