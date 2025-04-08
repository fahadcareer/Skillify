import 'package:Skillify/src/data/local/cache_helper.dart';
import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/res/drawable/drawables.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/widgets/cus_appbar.dart';
import 'package:Skillify/src/widgets/cus_bottom_nav.dart';
import 'package:Skillify/src/widgets/cus_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final int userRole = CacheHelper.getInt(key: "role");
    final bool isManager = userRole == 0;
    return Scaffold(
      bottomNavigationBar: CustomBottomNavigation(currentIndex: 0),
      appBar: CustomAppBar(
        c: context,
        title: "Skill Assessment",
        backButton: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.8,
                height: 250,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(SkillAssessmentAssetsFile.skillasses),
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
              ),
              Space.y2!,
              Text(
                'Welcome to Skill Assessment App',
                style: TextStyles.b1b?.copyWith(
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              Space.y1!,
              Text(
                "Identify your strengths, improve your skills, and receive personalized roadmaps for growth.",
                style: TextStyles.b2?.copyWith(color: Colors.black54),
                textAlign: TextAlign.center,
              ),
              Space.y0!,
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  context: context,
                  txtColor: Colors.white,
                  txt: 'Get Started',
                  onPressed: () {
                    context.push('/profile');
                  },
                ),
              ),
              if (isManager) ...[
                Space.y!,
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    context: context,
                    txtColor: Colors.white,
                    txt: 'Assignment for Students',
                    onPressed: () {
                      context.push('/assignments');
                    },
                  ),
                ),
              ],
              Space.y!,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _infoCard(
                    icon: Icons.school_rounded,
                    title: 'Skill Tests',
                    description:
                        'Evaluate your skills with real-time assessments.',
                    context: context,
                  ),
                  _infoCard(
                    icon: Icons.trending_up_rounded,
                    title: 'Growth Roadmap',
                    description: 'Get personalized roadmaps for improvement.',
                    context: context,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
  }) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 40,
            color: Theme.of(context).primaryColor,
          ),
          Space.y1!,
          Text(
            title,
            style: TextStyles.b1b?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          Space.y1!,
          Text(
            description,
            style: TextStyles.b2?.copyWith(color: Colors.black54),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
