import 'package:flutter/material.dart';
import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/widgets/cus_appbar.dart';
import 'package:flutter/services.dart';
import 'package:Skillify/src/widgets/cus_button.dart';
import 'package:go_router/go_router.dart';

class LearningPathPage extends StatefulWidget {
  final List<dynamic> recommendations;
  final Map<String, dynamic> learningPlan;

  const LearningPathPage({
    Key? key,
    required this.recommendations,
    required this.learningPlan,
  }) : super(key: key);

  @override
  State<LearningPathPage> createState() => _LearningPathPageState();
}

class _LearningPathPageState extends State<LearningPathPage> {
  bool _expandedLearningPlan = true;

  Widget _buildRecommendationsList() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Recommended Learning Path",
              style: TextStyles.h3?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const Divider(),
            if (widget.recommendations.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text("No recommendations available"),
              )
            else
              ...widget.recommendations.map((recommendation) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.lightbulb,
                            color: Colors.amber, size: 22),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            recommendation.toString(),
                            style: TextStyles.b2,
                          ),
                        ),
                      ],
                    ),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningPlan() {
    // Sort the days numerically before copying
    List<String> sortedDays = widget.learningPlan.keys.toList()
      ..sort((a, b) {
        int dayA = int.parse(a.split('_')[1]);
        int dayB = int.parse(b.split('_')[1]);
        return dayA.compareTo(dayB);
      });

    // Generate the entire learning plan text in order
    String learningPlanText = sortedDays.map((day) {
      final dayName = day.replaceAll('_', ' ').toUpperCase();
      final activities =
          (widget.learningPlan[day] as List<dynamic>).join('\n- ');
      return "$dayName:\n- $activities";
    }).join('\n\n');

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "30-Day Learning Plan",
                  style: TextStyles.h3?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.content_copy),
                  tooltip: "Copy Plan",
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: learningPlanText));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Learning plan copied!')),
                    );
                  },
                ),
              ],
            ),
            const Divider(),
            if (widget.learningPlan.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text("No learning plan available"),
              )
            else if (_expandedLearningPlan)
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: sortedDays.length,
                itemBuilder: (context, index) {
                  final dayKey = sortedDays[index];
                  final dayNumber = int.parse(dayKey.split('_')[1]);
                  final activities =
                      widget.learningPlan[dayKey] as List<dynamic>;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 12.0),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            "DAY $dayNumber",
                            style: TextStyles.b1?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...activities.map((activity) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(
                                    Icons.check_circle,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      activity.toString(),
                                      style: TextStyles.b2,
                                    ),
                                  ),
                                ],
                              ),
                            )),
                        const SizedBox(height: 8),
                      ],
                    ),
                  );
                },
              )
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  "Tap to expand your personalized 30-day learning plan",
                  style: TextStyles.b2?.copyWith(color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // Widget _buildActionButtons() {
  //   return Padding(
  //     padding: const EdgeInsets.symmetric(vertical: 16.0),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //       children: [
  //          ElevatedButton.icon(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Theme.of(context).primaryColor,
  //             foregroundColor: Colors.white,
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //           ),
  //           onPressed: () {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                   content: Text('Download functionality coming soon!')),
  //             );
  //           },
  //           icon: const Icon(Icons.download),
  //           label: const Text('Download Plan'),
  //         ),
  //         ElevatedButton.icon(
  //           style: ElevatedButton.styleFrom(
  //             backgroundColor: Theme.of(context).primaryColor,
  //             foregroundColor: Colors.white,
  //             padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //           ),
  //           onPressed: () {
  //             ScaffoldMessenger.of(context).showSnackBar(
  //               const SnackBar(
  //                   content: Text('Download functionality coming soon!')),
  //             );
  //           },
  //           icon: const Icon(Icons.download),
  //           label: const Text('Download Plan'),
  //         ),
  //         // ElevatedButton.icon(
  //         //   style: ElevatedButton.styleFrom(
  //         //     backgroundColor: Theme.of(context).primaryColor,
  //         //     foregroundColor: Colors.white,
  //         //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  //         //   ),
  //         //   onPressed: () {
  //         //     ScaffoldMessenger.of(context).showSnackBar(
  //         //       const SnackBar(
  //         //           content: Text('Share functionality coming soon!')),
  //         //     );
  //         //   },
  //         //   icon: const Icon(Icons.share),
  //         //   label: const Text('Share Plan'),
  //         // ),
  //       ],
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        c: context,
        title: "Learning Resources",
        backButton: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Personalized Learning Path",
              style: TextStyles.h2?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Based on your assessment results, we've created a customized 30-day learning plan to help you reach your goals.",
              style: TextStyles.b1,
              textAlign: TextAlign.center,
            ),
            Space.y2!,
            _buildRecommendationsList(),
            Space.y2!,
            _buildLearningPlan(),
            Space.y2!,
            // _buildActionButtons(),
            CustomButton(
              context: context,
              txtColor: Colors.white,
              txt: 'Back to Home',
              onPressed: () {
                context.go('/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}
