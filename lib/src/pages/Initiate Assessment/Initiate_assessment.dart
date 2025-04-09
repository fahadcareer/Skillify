import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:Skillify/src/provider/Initiateassessment_provider.dart';
import 'package:Skillify/src/res/dimentions/space.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:Skillify/src/widgets/cus_appbar.dart';
import 'package:Skillify/src/widgets/cus_button.dart';

class Initiateassessment extends StatefulWidget {
  const Initiateassessment({super.key});

  @override
  State<Initiateassessment> createState() => _InitiateassessmentState();
}

class _InitiateassessmentState extends State<Initiateassessment> {
  @override
  void initState() {
    super.initState();
    Future.microtask(
        () => context.read<InitiateassessmentProvider>().fetchNames());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(c: context, title: "Assign Skill Info"),
      body: Consumer<InitiateassessmentProvider>(
        builder: (context, provider, child) {
          return Padding(
            padding: const EdgeInsets.all(20),
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DropdownButton<Student>(
                        value: provider.selectedStudent,
                        hint: Text("Select Student", style: TextStyles.b1b!),
                        isExpanded: true,
                        items: provider.students.map((student) {
                          return DropdownMenuItem<Student>(
                            value: student,
                            child: Text(student.name, style: TextStyles.b2!),
                          );
                        }).toList(),
                        onChanged: provider.setSelectedStudent,
                      ),
                      Space.y1!,
                      if (provider.selectedStudent != null) ...[
                        TextField(
                          controller: provider.fieldController,
                          style: TextStyles.b2!,
                          decoration: InputDecoration(
                            labelText: 'Current Field',
                            labelStyle: TextStyles.b2!,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        Space.y1!,
                        TextField(
                          controller: provider.skillsController,
                          style: TextStyles.b2!,
                          decoration: InputDecoration(
                            labelText: 'Skills',
                            hintText: 'e.g., HTML, CSS, JavaScript',
                            labelStyle: TextStyles.b2!,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        Space.y1!,
                        TextField(
                          controller: provider.certificationController,
                          style: TextStyles.b2!,
                          decoration: InputDecoration(
                            labelText: 'Certifications',
                            hintText: 'e.g., AWS, PMP, Google Ads',
                            labelStyle: TextStyles.b2!,
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 24),
                        CustomButton(
                          context: context,
                          txt: "Submit",
                          txtColor: Colors.white,
                          onPressed: () async {
                            final message = await provider.handleSubmit();
                            if (message == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text("Assignment saved successfully!")),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                            }
                          },
                        )
                      ]
                    ],
                  ),
          );
        },
      ),
    );
  }
}
