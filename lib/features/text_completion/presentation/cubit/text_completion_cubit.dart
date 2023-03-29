import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_chatgpt/core/custom_exceptions.dart';
import 'package:flutter_chatgpt/features/text_completion/data/model/text_completion_model.dart';
import 'package:flutter_chatgpt/features/text_completion/data/model/turbo_data.dart';
import 'package:flutter_chatgpt/features/text_completion/domain/usecases/text_completion_usecase.dart';

part 'text_completion_state.dart';

class TextCompletionCubit extends Cubit<TextCompletionState> {
  final TextCompletionUseCase textCompletionUseCase;
  TextCompletionCubit({required this.textCompletionUseCase})
      : super(TextCompletionInitial());

  Future<void> textCompletion({required String query}) async {
    emit(TextCompletionLoading());
    try {
      final textCompletionModelData = await textCompletionUseCase.call(query);
      emit(TextCompletionLoaded(
          textCompletionModelData: textCompletionModelData));
    } on SocketException catch (e) {
      emit(TextCompletionFailure(errorMsg: e.message));
    } on ServerException catch (e) {
      emit(TextCompletionFailure(errorMsg: e.message));
    }
  }

  Future<void> textCompletionTurbo(
      {required String query, required String role}) async {
    emit(TextCompletionLoading());
    try {
      final textCompletionModelData =
          await textCompletionUseCase.callTurbo(query, role);
      emit(TextCompletionLoadedTurbo(
          textCompletionModelTurboData: textCompletionModelData));
    } on SocketException catch (e) {
      emit(TextCompletionFailure(errorMsg: e.message));
    } on ServerException catch (e) {
      emit(TextCompletionFailure(errorMsg: e.message));
    }
  }
}
