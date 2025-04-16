import 'package:Skillify/src/pages/roadmap_page.dart';
import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/widgets/cus_button.dart';
import 'package:Skillify/src/widgets/cus_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class ResultPage extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  final int score;
  final String result;
  final Map<String, dynamic> evaluation;

  const ResultPage({
    Key? key,
    required this.userProfile,
    required this.score,
    required this.result,
    required this.evaluation,
  }) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _showFullProfile = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget _buildScoreSection() {
    final Color scoreColor = widget.score >= 80
        ? Colors.green
        : (widget.score >= 60 ? Colors.amber : Colors.redAccent);

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Assessment Results",
              style: TextStyles.h3?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            Space.y2!,
            CircularPercentIndicator(
              radius: 80.0,
              lineWidth: 15.0,
              animation: true,
              animationDuration: 1500,
              percent: widget.score / 100,
              center: Text(
                "${widget.score}%",
                style: TextStyles.h2?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: scoreColor,
                ),
              ),
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: scoreColor,
              backgroundColor: Colors.grey.shade200,
            ),
            Space.y2!,
            Text(
              _getPerformanceText(widget.score),
              style: TextStyles.b1?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  String _getPerformanceText(int score) {
    if (score >= 80) {
      return "Excellent Performance! 🎉";
    } else if (score >= 60) {
      return "Good Performance! 👍";
    } else {
      return "Room for Improvement 💪";
    }
  }

  Widget _buildCategoryScores() {
    final categoryScores =
        widget.evaluation['category_scores'] as Map<String, dynamic>? ?? {};

    if (categoryScores.isEmpty) {
      return const Center(child: Text("No category scores available"));
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Performance by Category",
              style: TextStyles.b1?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            Space.y1!,
            ...categoryScores.entries.map((entry) {
              final categoryName = entry.key;
              final scoreInfo = entry.value as Map<String, dynamic>;
              final score = (scoreInfo['score'] as num).toDouble();
              final performance = scoreInfo['performance'] as String? ?? 'N/A';

              final Color progressColor = score >= 80
                  ? Colors.green
                  : (score >= 60 ? Colors.amber : Colors.redAccent);

              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(categoryName, style: TextStyles.b2),
                        Text(
                          "$score% - $performance",
                          style: TextStyles.b2?.copyWith(
                              color: progressColor,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Space.y0!,
                    LinearPercentIndicator(
                      lineHeight: 10.0,
                      percent: score / 100,
                      animation: true,
                      animationDuration: 1200,
                      backgroundColor: Colors.grey.shade200,
                      progressColor: progressColor,
                      barRadius: const Radius.circular(5),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthsAndImprovements() {
    final strengths = widget.evaluation['strengths'] as List<dynamic>? ?? [];
    final improvements =
        widget.evaluation['improvement_areas'] as List<dynamic>? ?? [];

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Strengths section
            Text(
              "Your Strengths",
              style: TextStyles.b1?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            if (strengths.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text("No strengths identified"),
              )
            else
              ...strengths
                  .map((strength) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check_circle,
                                color: Colors.green, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(strength.toString())),
                          ],
                        ),
                      ))
                  .toList(),

            Space.y2!,

            // Improvements section
            Text(
              "Areas for Improvement",
              style: TextStyles.b1?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(),
            if (improvements.isEmpty)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text("No improvement areas identified"),
              )
            else
              ...improvements
                  .map((improvement) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.arrow_circle_up,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 8),
                            Expanded(child: Text(improvement.toString())),
                          ],
                        ),
                      ))
                  .toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildLearningPath() {
    // Display a preview of the learning path with a button to navigate to full page
    final recommendations =
        widget.evaluation['recommended_learning_path'] as List<dynamic>? ?? [];

    return SingleChildScrollView(
      child: Column(
        children: [
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Recommended Learning Path",
                        style: TextStyles.b1
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          // Navigate to full learning path page
                          _navigateToLearningPathPage();
                        },
                        child: const Text("View Full Plan"),
                      ),
                    ],
                  ),
                  const Divider(),
                  if (recommendations.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.0),
                      child: Text("No recommendations available"),
                    )
                  else
                    ...recommendations
                        .take(3)
                        .map((recommendation) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.lightbulb,
                                      color: Colors.amber, size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                      child: Text(recommendation.toString())),
                                ],
                              ),
                            ))
                        .toList(),
                  if (recommendations.length > 3)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: TextButton(
                        onPressed: () {
                          _navigateToLearningPathPage();
                        },
                        child: Text(
                          "See ${recommendations.length - 3} more recommendations...",
                          style: TextStyles.b2?.copyWith(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Space.y2!,
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                _navigateToLearningPathPage();
              },
              child: const Text(
                "View Complete Learning Resources",
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToLearningPathPage() {
    final recommendations =
        widget.evaluation['recommended_learning_path'] as List<dynamic>? ?? [];
    final learningPlan =
        widget.evaluation['learning_plan'] as Map<String, dynamic>? ?? {};

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LearningPathPage(
          recommendations: recommendations,
          learningPlan: learningPlan,
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Profile Summary",
                  style: TextStyles.b1?.copyWith(fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _showFullProfile = !_showFullProfile;
                    });
                  },
                  child: Text(_showFullProfile ? "Show Less" : "Show More"),
                ),
              ],
            ),
            const Divider(),
            Text("Name: ${widget.userProfile['name']}"),
            const SizedBox(height: 4),
            Text("Age: ${widget.userProfile['age']}"),
            const SizedBox(height: 4),
            Text("Education: ${widget.userProfile['highest_qualification']}"),
            const SizedBox(height: 4),
            Text("Field: ${widget.userProfile['current_field']}"),
            if (_showFullProfile) ...[
              const SizedBox(height: 10),
              Text("Skills: ${_formatList(widget.userProfile['skills'])}"),
              const SizedBox(height: 4),
              Text(
                  "Certifications: ${_formatList(widget.userProfile['certifications'])}"),
              const SizedBox(height: 4),
              const SizedBox(height: 10),
              Text("Short-term Goals:",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("${widget.userProfile['short_term_goals']}"),
              const SizedBox(height: 10),
              Text("Long-term Goals:",
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text("${widget.userProfile['long_term_goals']}"),
              const SizedBox(height: 10),
              Text(
                  "Strengths: ${_formatList(widget.userProfile['strengths'])}"),
              const SizedBox(height: 4),
              Text(
                  "Areas to Improve: ${_formatList(widget.userProfile['weaknesses'])}"),
              const SizedBox(height: 10),
              Text("Projects: ${_formatList(widget.userProfile['projects'])}"),
            ]
          ],
        ),
      ),
    );
  }

  String _formatList(List<dynamic>? items) {
    if (items == null || items.isEmpty) return "None";
    return items.join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        c: context,
        title: "Assessment Results",
        backButton: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildProfileCard(),
            Space.y2!,
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const [
                Tab(text: "Overview"),
                Tab(text: "Categories"),
                Tab(text: "Analysis"),
                Tab(text: "Learning Path"),
              ],
            ),
            Space.y2!,
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  SingleChildScrollView(
                    child: _buildScoreSection(),
                  ),
                  SingleChildScrollView(
                    child: _buildCategoryScores(),
                  ),
                  SingleChildScrollView(
                    child: _buildStrengthsAndImprovements(),
                  ),
                  _buildLearningPath(),
                ],
              ),
            ),
            Space.y2!,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 150,
                  height: 65,
                  child: CustomButton(
                    context: context,
                    txtColor: Colors.white,
                    txt: 'Back to Home',
                    onPressed: () {
                      context.go('/home');
                    },
                  ),
                ),
                SizedBox(
                  width: 150,
                  height: 65,
                  child: CustomButton(
                    context: context,
                    txtColor: Colors.white,
                    txt: 'View Resources',
                    onPressed: () {
                      _navigateToLearningPathPage();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
