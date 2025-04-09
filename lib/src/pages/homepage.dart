import 'package:Skillify/src/data/local/cache_helper.dart';
import 'package:Skillify/src/provider/profile_provider.dart';
import 'package:Skillify/src/provider/Initiateassessment_provider.dart';
import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/res/drawable/drawables.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/widgets/cus_appbar.dart';
import 'package:Skillify/src/widgets/cus_bottom_nav.dart';
import 'package:Skillify/src/widgets/cus_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<void> _navigateToAssessment(BuildContext context) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              Space.y1!,
              Text(
                "Preparing your assessment...",
                style: TextStyles.b1b,
              ),
            ],
          ),
        );
      },
    );

    try {
      final success = await profileProvider.generateAssessment();

      Navigator.pop(context);

      if (success) {
        context.push('/assessment', extra: {
          'userProfile': profileProvider.userProfile,
          'assessment': profileProvider.assessment,
          'isManagerAssessment': false,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Failed to generate assessment. Please try again.")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Future<void> _navigateToManagerAssessment(BuildContext context) async {
    final profileProvider =
        Provider.of<ProfileProvider>(context, listen: false);
    final initiateProvider =
        Provider.of<InitiateassessmentProvider>(context, listen: false);

    final userEmail = CacheHelper.getString(key: 'email');

    if (userEmail.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("User email not found. Please login again.")),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              Space.y1!,
              Text(
                "Fetching your manager assessment...",
                style: TextStyles.b1b,
              ),
            ],
          ),
        );
      },
    );

    try {
      await initiateProvider.fetchAssignmentByEmail(userEmail);

      if (initiateProvider.currentAssignment == null) {
        Navigator.pop(context); // Close dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("No manager assessment found for your profile.")),
        );
        return;
      }

      await profileProvider
          .setUserProfileFromAssignment(initiateProvider.currentAssignment!);

      final success = await profileProvider.generateAssessment();

      Navigator.pop(context);

      if (success) {
        context.push('/assessment', extra: {
          'userProfile': profileProvider.userProfile,
          'assessment': profileProvider.assessment,
          'isManagerAssessment': true,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text("Failed to generate assessment. Please try again.")),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

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
                  txt: 'Self Assessment',
                  onPressed: () => _navigateToAssessment(context),
                ),
              ),
              Space.y!,
              SizedBox(
                width: double.infinity,
                child: CustomButton(
                  context: context,
                  txtColor: Colors.white,
                  txt: 'Manager-Based Assessment',
                  onPressed: () => _navigateToManagerAssessment(context),
                ),
              ),
              if (isManager) ...[
                Space.y!,
                SizedBox(
                  width: double.infinity,
                  child: CustomButton(
                    context: context,
                    txtColor: Colors.white,
                    txt: 'Initiate Assessment',
                    onPressed: () {
                      context.push('/Initiateassessment');
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
