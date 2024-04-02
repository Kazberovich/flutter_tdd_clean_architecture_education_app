import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'exam_state.dart';

class ExamCubit extends Cubit<ExamState> {
  ExamCubit() : super(ExamInitial());
}
