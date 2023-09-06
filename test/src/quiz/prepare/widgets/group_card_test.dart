import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kana_to_kanji/src/core/constants/kana_type.dart';
import 'package:kana_to_kanji/src/quiz/prepare/widgets/group_card.dart';
import 'package:kana_to_kanji/src/core/constants/alphabets.dart';
import 'package:kana_to_kanji/src/core/models/group.dart';

import '../../../../helpers.dart';

void main() {
  group("GroupCard", () {
    final Group groupSample = Group(0, Alphabets.katakana, "Group name",
        KanaTypes.main, "Group name", "v1");
    final Group localizedGroupSample = Group(0, Alphabets.katakana,
        "Group name", KanaTypes.main, "Localized group name", "v1");

    group("UI", () {
      testWidgets("Default", (WidgetTester tester) async {
        await tester.pumpWidget(LocalizedWidget(
            child: GroupCard(
          group: groupSample,
          onTap: (Group group) {},
        )));

        final widget = find.byType(GroupCard);

        expect(widget, findsOneWidget);
        expect(
            find.descendant(of: widget, matching: find.text(groupSample.name)),
            findsOneWidget);
        expect(
            find.descendant(
                of: widget,
                matching: find.byWidgetPredicate((Widget widget) {
                  if (widget is Checkbox) {
                    return widget.value == false;
                  }
                  return false;
                })),
            findsOneWidget);
      });

      testWidgets("Checked", (WidgetTester tester) async {
        await tester.pumpWidget(LocalizedWidget(
            child: GroupCard(
          group: groupSample,
          onTap: (Group group) {},
          isChecked: true,
        )));

        final widget = find.byType(GroupCard);

        expect(widget, findsOneWidget);
        expect(
            find.descendant(of: widget, matching: find.text(groupSample.name)),
            findsOneWidget);
        expect(
            find.descendant(
                of: widget,
                matching: find.byWidgetPredicate((Widget widget) {
                  if (widget is Checkbox) {
                    return widget.value ?? false;
                  }
                  return false;
                })),
            findsOneWidget);
      });

      testWidgets("Localized name", (WidgetTester tester) async {
        await tester.pumpWidget(LocalizedWidget(
            child: GroupCard(
                group: localizedGroupSample, onTap: (Group group) {})));

        final widget = find.byType(GroupCard);

        expect(widget, findsOneWidget);
        expect(
            find.descendant(
                of: widget,
                matching: find.text(localizedGroupSample.localizedName!)),
            findsOneWidget);
      });
    });

    group("Interactions", () {
      final List<int> log = [];

      setUp(() {
        log.clear();
      });

      testWidgets("Tapping on the checkbox should call onTap",
          (WidgetTester tester) async {
        await tester.pumpWidget(LocalizedWidget(
            child: GroupCard(
          group: groupSample,
          onTap: (Group group) {
            log.add(group.id);
          },
        )));

        await tester.tap(find.byType(Checkbox));

        expect(log, equals([groupSample.id]));
      });

      testWidgets("Tapping on the text should call onTap",
          (WidgetTester tester) async {
        await tester.pumpWidget(LocalizedWidget(
            child: GroupCard(
          group: groupSample,
          onTap: (Group group) {
            log.add(group.id);
          },
        )));

        await tester.tap(find.text(groupSample.name));

        expect(log, equals([groupSample.id]));
      });

      testWidgets("Tapping on the card should call onTap",
          (WidgetTester tester) async {
        await tester.pumpWidget(LocalizedWidget(
            child: GroupCard(
          group: groupSample,
          onTap: (Group group) {
            log.add(group.id);
          },
        )));

        await tester.tap(find.byType(Card));

        expect(log, equals([groupSample.id]));
      });
    });
  });
}
