import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';

import 'package:bu_pulse/data/models/online/category_model.dart';
import 'package:bu_pulse/data/resources/online/category/category_repo.dart';

part 'category_event.dart';
part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRepository _categoryRepository = CategoryRepository();

  CategoryBloc() : super(CategoryInitialState()) {
    /// Getting all the categories w/o surveys
    on<GetCategoryListEvent>((event, emit) async {
      try {
        emit(CategoryLoadingState());
        final categories = await _categoryRepository.getCategoryList();
        emit(CategoryLoadedState(categories));
      } catch (error) {
        emit(CategoryErrorState(error.toString()));
      }
    });

    /// Getting a category w/ surveys
    on<GetCategoryWithSurveyListEvent>((event, emit) async {
      try {
        emit(CategoryWithSurveyLoadingState());
        final categoryWithSurvey = await _categoryRepository.getCategoryWithSurvey(
          categoryId: event.categoryId,
        );
        emit(CategoryWithSurveyLoadedState(categoryWithSurvey));
      } catch (error) {
        emit(CategoryErrorState(error.toString()));
      }
    });
  }
}
