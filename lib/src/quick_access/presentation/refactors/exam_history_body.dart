import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_education_app/core/common/views/loading_view.dart';
import 'package:tdd_education_app/core/common/widgets/not_found_text.dart';
import 'package:tdd_education_app/core/utils/core_utils.dart';
import 'package:tdd_education_app/src/course/features/exams/presentation/app/cubit/exam_cubit.dart';
import 'package:tdd_education_app/src/quick_access/presentation/widgets/exam_history_tile.dart';

class ExamHistoryBody extends StatefulWidget {
  const ExamHistoryBody({super.key});

  @override
  State<ExamHistoryBody> createState() => _ExamHistoryBodyState();
}

class _ExamHistoryBodyState extends State<ExamHistoryBody> {
  void getHistory() {
    context.read<ExamCubit>().getUserExams();
  }

  @override
  void initState() {
    super.initState();
    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ExamCubit, ExamState>(
      listener: (_, state) {
        if (state is ExamError) {
          CoreUtils.showSnackBar(context, state.message);
        }
      },
      builder: (context, state) {
        if (state is GettingUserExams) {
          return const LoadingView();
        } else if ((state is UserExamsLoaded && state.exams.isEmpty) ||
            state is ExamError) {
          return const NotFoundText('No exams completed yet');
        } else if (state is UserExamsLoaded) {
          final exams = state.exams
            ..sort((a, b) => b.dateSubmitted.compareTo(a.dateSubmitted));
          return ListView.builder(
            itemBuilder: (_, index) {
              final exam = exams[index];
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ExamHistoryTile(exam: exam),
                  if (index != exams.length - 1) const SizedBox(height: 20),
                ],
              );
            },
            itemCount: exams.length,
            padding: const EdgeInsets.symmetric(horizontal: 16),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
