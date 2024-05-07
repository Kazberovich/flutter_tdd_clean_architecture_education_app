import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:tdd_education_app/core/res/colours.dart';
import 'package:tdd_education_app/core/res/media_resources.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';
import 'package:tdd_education_app/src/course/features/exams/data/models/user_exam_model.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/app/providers/exam_controller.dart';

class ExamView extends StatefulWidget {
  const ExamView({super.key});

  static const routeName = '/exam';

  @override
  State<ExamView> createState() => _ExamViewState();
}

class _ExamViewState extends State<ExamView> {
  bool showingLoader = false;
  late ExamController examController;

  Future<void> submitExam() async {
    if (!examController.isTimeUp) {
      examController.stopTimer();

      final isMinutesLeft = examController.remainingTimeInSeconds > 60;
      final ifHoursLeft = examController.remainingTimeInSeconds > 3600;
      final timeLeftText = ifHoursLeft
          ? 'hours'
          : isMinutesLeft
              ? 'minutes'
              : 'seconds';
      final endExam = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog.adaptive(
            title: const Text('Submit Exam?'),
            content: Text(
                'You have ${examController.remainingTime} $timeLeftText left.\n'
                'Are you sure you want to submit? '),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: const Text(
                  'Submit exam',
                  style: TextStyle(color: Colours.redColour),
                ),
              ),
            ],
          );
        },
      );

      if (endExam ?? false) {
        return collectAndSend();
      } else {
        examController.startTimer();
        return;
      }
    }
    collectAndSend();
  }

  void collectAndSend() {
    final exam = examController.userExam;
    context.read<ExamCubit>().submitExam(exam);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    examController = context.read<ExamController>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      examController.addListener(() {
        if (examController.isTimeUp) submitExam();
      });
    });
  }

  @override
  void dispose() {
    examController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ExamController>(
      builder: (_, controller, __) {
        return BlocConsumer<ExamCubit, ExamState>(
          listener: (_, state) {
            if (showingLoader) {
              Navigator.pop(context);
              showingLoader = false;
            }
            if (state is ExamError) {
              CoreUtils.showSnackBar(context, state.message);
            } else if (state is SubmittingExam) {
              CoreUtils.showLoadingDialog(context);
              showingLoader = true;
            } else if (state is ExamSubmitted) {
              CoreUtils.showSnackBar(context, 'Exam Submitted');
              Navigator.pop(context);
            }
          },
          builder: (_, state) => WillPopScope(
            onWillPop: () async {
              if (state is SubmittingExam) return false;
              if (controller.isTimeUp) return true;
              final result = await showDialog<bool>(
                context: context,
                builder: (context) {
                  return AlertDialog.adaptive(
                    title: const Text('Exit Exam'),
                    content:
                        const Text('Are you sure you want to exit the Exam?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('Exit exam'),
                      ),
                    ],
                  );
                },
              );
              return result ?? false;
            },
            child: Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                centerTitle: true,
                title: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      MediaRes.examTimeRed,
                      height: 30,
                      width: 30,
                    ),
                    const SizedBox(width: 10),
                    Text(
                      controller.remainingTime,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: submitExam,
                    child: const Text('Submit', style: TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
