import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mama_kris/core/common/widgets/buttons/custom_primary_button.dart';
import 'package:mama_kris/core/common/widgets/custom_scaffold.dart';
import 'package:mama_kris/core/common/widgets/custom_text.dart';
import 'package:mama_kris/core/constants/app_palette.dart';
import 'package:mama_kris/features/employe_home/applications/post_job/post_job_bloc.dart';

class PostJobPage extends StatefulWidget {
  const PostJobPage({super.key});

  @override
  State<PostJobPage> createState() => _PostJobPageState();
}

class _PostJobPageState extends State<PostJobPage> {
  final _professionController = TextEditingController();
  final _salaryController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _professionController.dispose();
    _salaryController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFF9E3), Color(0xFFCEE5DB)],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: BlocConsumer<PostJobBloc, PostJobState>(
              listener: (context, state) {
                if (state is PostJobSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Job posted successfully!')),
                  );
                  Navigator.of(context).pop();
                } else if (state is PostJobError) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${state.message}')),
                  );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CustomText(
                      text: 'Post a Job',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _professionController,
                      decoration: const InputDecoration(
                        labelText: 'Profession',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: AppPalette.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _salaryController,
                      decoration: const InputDecoration(
                        labelText: 'Salary',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: AppPalette.white,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: AppPalette.white,
                      ),
                      maxLines: 5,
                    ),
                    const SizedBox(height: 20),
                    if (state is PostJobLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      CustomPrimaryButton(
                        btnText: 'Post Job',
                        onTap: () {
                          final profession = _professionController.text.trim();
                          final salary = _salaryController.text.trim();
                          final description = _descriptionController.text
                              .trim();

                          if (profession.isEmpty ||
                              salary.isEmpty ||
                              description.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill all fields'),
                              ),
                            );
                            return;
                          }

                          // context.read<PostJobBloc>().add(
                          //   PostJobSubmitEvent(
                          //     profession: profession,
                          //     salary: salary,
                          //     description: description,
                          //   ),
                          // );
                        },
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
