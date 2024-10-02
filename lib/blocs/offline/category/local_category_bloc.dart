import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:bu_pulse/data/models/offline/category.dart';
import 'package:bu_pulse/data/resources/offline/local_repo.dart';

part 'local_category_event.dart';
part 'local_category_state.dart';

class LocalCategoryBloc extends Bloc<LocalCategoryEvent, LocalCategoryState> {
  final LocalRepository _localRepository = LocalRepository();

  LocalCategoryBloc() : super(LocalCategoryInitialState()) {
    /// Get local categories
    on<GetLocalCategoryListEvent>((event, emit) async {
      try {
        emit(LocalCategoryLoadingState());
        final categories = await _localRepository.getCategories();
        emit(LocalCategoryLoadedState(categories));
      } catch (error) {
        emit(LocalCategoryErrorState(error.toString()));
      }
    });
  }
}
