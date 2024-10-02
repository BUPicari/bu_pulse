import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:bu_pulse/blocs/online/category/category_bloc.dart';
import 'package:bu_pulse/data/models/online/category_model.dart';
import 'package:bu_pulse/helpers/functions.dart';
import 'package:bu_pulse/helpers/variables.dart';
import 'package:bu_pulse/screens/error_screen.dart';
import 'package:bu_pulse/screens/online/category_screen.dart';
import 'package:bu_pulse/widgets/online/category_survey_widget.dart';
import 'package:bu_pulse/widgets/loading_overlay_widget.dart';

class CategorySurveyScreen extends StatelessWidget {
  final Category category;
  final List<String> addresses;

  const CategorySurveyScreen({
    super.key,
    required this.category,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    /// Local to API not yet sent items submission
    Functions.localToApi();

    return BlocProvider(
      create: (context) => CategoryBloc()
        ..add(GetCategoryWithSurveyListEvent(categoryId: category.id)),
      child: Scaffold(
        appBar: AppBar(
          leading: GestureDetector(
            child: Icon(
              Icons.arrow_back,
              color: AppColor.subPrimary,
            ),
            onTap: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => LoadingOverlayWidget(
                progressText: AppConfig.offlineModeText,
                child: CategoryScreen(addresses: addresses),
              ),
            )),
          ),
          foregroundColor: AppColor.subPrimary,
          title: Text(category.name),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(80),
            child: Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.centerLeft,
              child: _buildWelcome(),
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: AppColor.linearGradient,
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryWithSurveyLoadingState) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (state is CategoryWithSurveyLoadedState) {
                if (state.categoryWithSurvey?.name == "none") {
                  return const ErrorScreen(
                    error: "No Active Survey as of the moment!",
                  );
                }

                return ListView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.all(10),
                  children: [
                    _buildCategorySurveys(categoryWithSurvey: state.categoryWithSurvey),
                  ],
                );
              }
              if (state is CategoryErrorState) {
                return ErrorScreen(error: state.error);
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildWelcome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tap below your selected',
          style: TextStyle(fontSize: 16, color: AppColor.subPrimary),
        ),
        Text(
          'Active Surveys',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColor.subPrimary,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySurveys({ Category? categoryWithSurvey }) {
    return SizedBox(
      height: 200,
      child: GridView(
        primary: false,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        children: categoryWithSurvey!.surveys!
          .map((survey) => CategorySurveyWidget(
            category: category,
            survey: survey,
            addresses: addresses,
          )).toList(),
      ),
    );
  }
}
