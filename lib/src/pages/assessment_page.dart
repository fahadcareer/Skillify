import 'package:Skillify/src/provider/assesment_provider.dart';
import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/widgets/cus_button.dart';
import 'package:flutter/material.dart';
import 'package:Skillify/src/widgets/cus_appbar.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class AssessmentPage extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  final Map<String, dynamic> assessment;

  const AssessmentPage({
    super.key,
    required this.userProfile,
    required this.assessment,
  });

  @override
  State<AssessmentPage> createState() => _AssessmentPageState();
}

class _AssessmentPageState extends State<AssessmentPage> {
  final Map<String, TextEditingController> _controllers = {};

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final questionsProvider =
          Provider.of<QuestionsProvider>(context, listen: false);
      final questionsJson = widget.assessment['assessment_questions'] as List;
      questionsProvider.setQuestions(questionsJson);

      for (var q in questionsProvider.questions) {
        print("Initializing controller for question: ${q.id}");
        if (q.id.isNotEmpty) {
          _controllers[q.id] = TextEditingController(text: q.userAnswer ?? '');
        } else {
          print("Warning: Found question with null or empty ID");
        }
      }
    });
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  Widget _buildQuestionWidget(Question question, int index) {
    print(
        "Building widget for question: ${question.id}, type: ${question.type}");

    final questionsProvider =
        Provider.of<QuestionsProvider>(context, listen: false);

    String safeId = question.id;

    switch (question.type) {
      case 'multiple_choice':
        if (question.options == null || question.options!.isEmpty) {
          return const Text('No options available for this question');
        }
        return Column(
          children: question.options!.map((option) {
            return RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: question.userAnswer,
              onChanged: (value) {
                questionsProvider.updateQuestionAnswer(safeId, value!);
              },
            );
          }).toList(),
        );

      case 'theoretical':
      case 'practical':
        if (!_controllers.containsKey(safeId)) {
          _controllers[safeId] =
              TextEditingController(text: question.userAnswer ?? '');
        }
        final controller = _controllers[safeId]!;

        return TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter your answer',
            border: OutlineInputBorder(),
          ),
          maxLines: question.type == 'practical' ? 5 : 3,
          onChanged: (value) {
            questionsProvider.updateQuestionAnswer(safeId, value);
          },
        );

      default:
        return const Text('Unsupported question type');
    }
  }

  void _submitAssessment() async {
    final questionsProvider =
        Provider.of<QuestionsProvider>(context, listen: false);

    for (var question in questionsProvider.questions) {
      if (question.userAnswer == null ||
          question.userAnswer.toString().trim().isEmpty) {
        questionsProvider.updateQuestionAnswer(question.id, "Don't Know");
      }
    }

    print('Assessment data being submitted:');
    print('Assessment ID: ${widget.assessment['assessment_id']}');
    print('Number of questions: ${questionsProvider.questions.length}');

    if (widget.assessment['assessment_id'] == null ||
        widget.assessment['assessment_id'].toString().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text(
                'Missing assessment ID. Please try generating the assessment again.')),
      );
      return;
    }

    final submissionSuccess =
        await questionsProvider.submitAssessment(widget.assessment);

    if (submissionSuccess) {
      context.push('/result', extra: {
        'userProfile': widget.userProfile,
        'score': questionsProvider.evaluationResult!['overall_score'].round(),
        'result': questionsProvider.generateResultText(),
        'evaluation': questionsProvider.evaluationResult,
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit: ${questionsProvider.error}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        c: context,
        title: "Skill Assessment",
        backButton: true,
      ),
      body: Consumer<QuestionsProvider>(
        builder: (context, questionsProvider, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                Space.y1!,
                Text(
                  "Assessment Questions",
                  style: TextStyles.h3?.copyWith(fontWeight: FontWeight.bold),
                ),
                Space.y0!,
                ...questionsProvider.questions.asMap().entries.map((entry) {
                  final index = entry.key;
                  final question = entry.value;
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  '${index + 1}. ${question.questionText}',
                                  style: TextStyles.b1,
                                  softWrap: true,
                                  overflow: TextOverflow.visible,
                                ),
                              ),
                            ],
                          ),
                          Space.y0!,
                          _buildQuestionWidget(question, index),
                        ],
                      ),
                    ),
                  );
                }).toList(),
                if (questionsProvider.error.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      questionsProvider.error,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Space.y2!,
                SizedBox(
                  width: 200,
                  height: 70,
                  child: questionsProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : CustomButton(
                          context: context,
                          txtColor: Colors.white,
                          txt: 'Submit Assessment',
                          onPressed: _submitAssessment,
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
