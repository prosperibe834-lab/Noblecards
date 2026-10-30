class FAQModel {
  final String question;
  final String answer;
  final String category;

  const FAQModel({
    required this.question,
    required this.answer,
    this.category = 'General',
  });
}

