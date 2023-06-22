import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:kana_to_kanji/src/quiz/constants/categories.dart';

class SubCategoryCard extends StatelessWidget {
  final Categories category;
  final String subCategory;
  final Function(Categories, String)? onTap;
  final bool isChecked;

  const SubCategoryCard(
      {super.key,
      required this.category,
      required this.subCategory,
      this.onTap,
      this.isChecked = false});

  onChanged(bool? value) {
    if (onTap != null) {
      onTap!(category, subCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: CheckboxListTile(
        title: Text(subCategory),
        value: isChecked,
        onChanged: onChanged,
      ),
    );
  }
}
