import 'dart:math';
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:bu_pulse/data/models/online/category_model.dart';
import 'package:bu_pulse/helpers/variables.dart';
import 'package:bu_pulse/screens/online/category_survey_screen.dart';

class CategoryWidget extends StatelessWidget {
  final Category category;
  final List<String> addresses;

  const CategoryWidget({
    super.key,
    required this.category,
    required this.addresses,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => CategorySurveyScreen(
          category: category,
          addresses: addresses,
        ),
      )),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.primaries[Random().nextInt(Colors.primaries.length)],
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FutureBuilder<bool>(
              future: InternetConnectionChecker().hasConnection,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Column();
                  } else {
                    if (snapshot.data == true) {
                      if (category.image != "undefined" && category.image != "NULL") {
                        return Image.network(
                          ApiConfig.baseUrl + category.image,
                          width: 70,
                          errorBuilder: (
                            BuildContext context,
                            Object exception,
                            StackTrace? stackTrace) {
                            return const Column();
                          },
                        );
                      } else {
                        return const Column();
                      }
                    } else {
                      return const Column();
                    }
                  }
                } else {
                  return const Column();
                }
              },
            ),
            const SizedBox(height: 10),
            Text(
              category.name,
              style: TextStyle(
                color: AppColor.subPrimary,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
