import 'package:flutter/material.dart';
import 'package:ios_fl_n_mondialstyle_3445/models/question_model/question_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final List<QuizQuestion> quizQuestions = [
  QuizQuestion(
    question: 'What’s your typical pace of life?',
    options: [
      'Chill and slow, like to take my time',
      'Fast and focused, always on the move',
      'Balanced — I shift between moods',
      'Energetic and spontaneous, like a kick-push',
    ],
    correctIndex: 1,
  ),
  QuizQuestion(
    question: 'Your ideal weekend plan includes:',
    options: [
      'A morning run and a smoothie stop',
      'Wandering around in a new district with my camera',
      'Hanging out at the skatepark with friends',
      'Visiting a minimalist art gallery, then coffee',
    ],
    correctIndex: 0,
  ),
  QuizQuestion(
    question: 'Pick your favorite footwear:',
    options: [
      'Trail sneakers with extra grip',
      'Lightweight running shoes',
      'Chunky skate sneakers',
      'Sleek slip-ons or monochrome trainers',
    ],
    correctIndex: 1,
  ),
  QuizQuestion(
    question: 'What do you carry in your bag?',
    options: [
      'Headphones, water bottle, map',
      'Phone, smartwatch, protein bar',
      'Stickers, snack, beanie',
      'Notebook, reusable tote, lip balm',
    ],
    correctIndex: 1,
  ),
  QuizQuestion(
    question: 'Which city vibe fits you best?',
    options: [
      'Tokyo\'s blend of tech and tradition',
      'New York’s fast-lane pulse',
      'Los Angeles skate scene',
      'Copenhagen’s clean lines and calm energy',
    ],
    correctIndex: 2,
  ),
  QuizQuestion(
    question: 'What describes your wardrobe best?',
    options: [
      'All about movement and breathability',
      'Layered techwear with smart accessories',
      'Statement pieces with retro flair',
      'Neutral tones, sharp cuts, less is more',
    ],
    correctIndex: 0,
  ),
  QuizQuestion(
    question: 'You’re most likely to post a story of:',
    options: [
      'Sunset hike',
      'New hoodie drop',
      'Kickflip attempt',
      'A perfect latte shot in a minimal cafe',
    ],
    correctIndex: 3,
  ),
  QuizQuestion(
    question: 'Your playlist vibe is:',
    options: [
      'Lo-fi or ambient beats',
      'High-tempo electronic',
      'Skate punk and indie rock',
      'Deep house or minimal techno',
    ],
    correctIndex: 1,
  ),
  QuizQuestion(
    question: 'Choose your workout fuel:',
    options: [
      'Granola and coconut water',
      'Pre-workout shake and banana',
      'Energy bar and cola',
      'Just water and a croissant',
    ],
    correctIndex: 1,
  ),
  QuizQuestion(
    question: 'Your go-to activewear brand is:',
    options: [
      'Arc\'teryx or Salomon',
      'Nike Performance',
      'Vans or Supreme',
      'Uniqlo Sport or COS Move',
    ],
    correctIndex: 3,
  ),
];

final List<QuizResult> quizQuestionResult = [
  QuizResult(
    // 1-2 correct answers
    image: 'assets/game_result/3.png',
    title: 'Minimalist in Motion',
    description:
        'Clean. Calm. Controlled. You’re the embodiment of thoughtful movement — both in style and lifestyle. You prefer quiet mornings, soft layers, and neutral colors. Whether you`re flowing through yoga or cruising through quiet streets, your fashion speaks volumes without shouting.\nStyle keywords: muted, relaxed, quietly refined',
  ),
  QuizResult(
    // 3-4 correct answers
    image: 'assets/game_result/2.png',
    title: 'Skate Flexer',
    description:
        'You`re effortlessly cool and unapologetically expressive. Your style is laid-back but intentional — bold sneakers, oversized hoodies, and a vibe that says “I just landed a trick and didn’t even break a sweat.” You thrive in skateparks, city backstreets, and anywhere freedom flows.\nStyle keywords: retro, streetwise, playful',
  ),
  QuizResult(
    // 5-7 correct answers
    image: 'assets/game_result/1.png',
    title: 'Techno-Trekker',
    description:
        'Explorer meets innovator — you’re all about functional fashion with an edge. You thrive in unexpected routes, mixing urban textures with outdoor grit. You favor utility gear, modular layers, and smart fabrics. With your crossbody bag, hiking shoes, and tactical hoodie, you’re always ready to discover something new — in the city or beyond.\nStyle keywords: utilitarian, layered, futuristic',
  ),
  QuizResult(
    // 8-10 correct answers
    image: 'assets/game_result/4.png',
    title: 'Urban Runner',
    description:
        'You`re powered by the rhythm of the city. Speed, focus, and minimal distractions define your lifestyle. Whether you`re sprinting through crosswalks or weaving between commuters, your gear is light, breathable, and built for performance. You live for early runs, sleek lines, and that post-workout dopamine hit. Efficiency is your aesthetic.\nStyle keywords: streamlined, technical, performance-driven.',
  ),
];

class QuizActionScreen extends StatefulWidget {
  const QuizActionScreen({super.key});

  @override
  State<QuizActionScreen> createState() => _QuizActionScreenState();
}

class _QuizActionScreenState extends State<QuizActionScreen> {
  int currentIndex = 0;
  int correctCount = 0;
  int? selectedIndex;

  void _nextQuestion() {
    if (selectedIndex == quizQuestions[currentIndex].correctIndex) {
      correctCount++;
    }
    if (currentIndex < quizQuestions.length - 1) {
      setState(() {
        currentIndex++;
        selectedIndex = null;
      });
    } else {
      final QuizResult result = _getQuizResult();
      _saveBestScore(correctCount);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder:
              (_) => _QuizResultScreen(result: result, score: correctCount),
        ),
      );
    }
  }

  Future<void> _saveBestScore(int score) async {
    final prefs = await SharedPreferences.getInstance();
    final best = prefs.getInt('best_score') ?? 0;
    if (score > best) {
      await prefs.setInt('best_score', score);
    }
  }

  QuizResult _getQuizResult() {
    if (correctCount <= 2) return quizQuestionResult[0];
    if (correctCount <= 4) return quizQuestionResult[1];
    if (correctCount <= 7) return quizQuestionResult[2];
    return quizQuestionResult[3];
  }

  @override
  Widget build(BuildContext context) {
    final question = quizQuestions[currentIndex];

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFFF0E12D)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          Positioned(
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/app_background.png'),
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    '${currentIndex + 1}/${quizQuestions.length}',
                    style: const TextStyle(
                      color: Color(0xFFF0E12D),
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    question.question,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFFF0E12D),
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ...List.generate(question.options.length, (index) {
                    final isSelected = selectedIndex == index;
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: GestureDetector(
                        onTap: () => setState(() => selectedIndex = index),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            vertical: 14,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: const Color(0xFFF0E12D)),
                            color:
                                isSelected
                                    ? const Color(0xFFEBFC00)
                                    : Colors.transparent,
                          ),
                          child: Text(
                            '${index + 1}.  ${question.options[index].toUpperCase()}',
                            style: TextStyle(
                              color:
                                  isSelected
                                      ? const Color(0xFF00590C)
                                      : const Color(0xFFF0E12D),
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: selectedIndex != null ? _nextQuestion : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        foregroundColor: Colors.yellow,
                        side: const BorderSide(color: Colors.yellow),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      child: Text(
                        'NEXT',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              selectedIndex != null
                                  ? const Color(0xFFF0E12D)
                                  : Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizResultScreen extends StatelessWidget {
  final QuizResult result;
  final int score;

  const _QuizResultScreen({required this.result, required this.score});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),
              Text(
                'YOUR RESULT',
                style: const TextStyle(
                  color: Color(0xFFF0E12D),
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$score/10',
                style: const TextStyle(
                  color: Color(0xFFF0E12D),
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                result.title.toUpperCase(),
                style: const TextStyle(
                  color: Color(0xFFF0E12D),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 24),
              Image.asset(result.image, height: 180),
              const SizedBox(height: 20),
              Text(
                result.description,
                style: const TextStyle(color: Color(0xFF39C64C), fontSize: 14),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    backgroundColor: Colors.transparent,
                    foregroundColor: Colors.yellow,
                    side: const BorderSide(color: Colors.yellow),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'GO TO HOME',
                    style: TextStyle(fontSize: 28),
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}
