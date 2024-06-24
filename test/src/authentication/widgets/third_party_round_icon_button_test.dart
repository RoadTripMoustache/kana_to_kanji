import "package:flutter/material.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/authentication/widgets/third_party_round_icon_button.dart";
import "package:kana_to_kanji/src/core/constants/app_theme.dart";

import "../../../helpers.dart";

void main() {
  group("ThirdPartyRoundIconButton", () {
    testWidgets("It should have an rounded InkWell and Image",
        (WidgetTester tester) async {
      await tester
          .pumpLocalizedWidget(const ThirdPartyRoundIconButton.google());
      await tester.pumpAndSettle();

      final inkWell = find.byKey(const Key("third_party_round_icon_button"));

      expect(inkWell, findsOne);
      expect(tester.widget<InkWell>(inkWell).borderRadius,
          BorderRadius.circular(50.0),
          reason: "InkWell should be rounded");
      expect(find.descendant(of: inkWell, matching: find.byType(ClipRRect)),
          findsOne,
          reason: "It should have a ClipRRect to round the image");
      expect(
          find.descendant(of: inkWell, matching: find.byType(Image)), findsOne,
          reason: "It should have an image");
    });

    testWidgets("It should call onPressed when pressed",
        (WidgetTester tester) async {
      var pressed = 0;
      await tester.pumpLocalizedWidget(
          ThirdPartyRoundIconButton.google(onPressed: () => pressed++));
      await tester.pumpAndSettle();

      await tester.tap(find.byType(ThirdPartyRoundIconButton));

      expect(pressed, 1, reason: "Should have been pressed");

      expect(tester.widget<Image>(find.byType(Image)).color, isNull,
          reason: "Image should not have any color modification");
    });

    testWidgets("It should disable the InkWell when onPressed isn't provided",
        (WidgetTester tester) async {
      await tester
          .pumpLocalizedWidget(const ThirdPartyRoundIconButton.google());
      await tester.pumpAndSettle();

      expect(
          tester
              .widget<InkWell>(
                  find.byKey(const Key("third_party_round_icon_button")))
              .onTap,
          null,
          reason: "Should not have a function set");

      // Validate the image color
      expect(tester.widget<Image>(find.byType(Image)).color,
          AppTheme.light().disabledColor,
          reason: "Image should be grayed out to signify it's disabled");
    });

    const brands = [
      {"brand": "Google", "widget": ThirdPartyRoundIconButton.google()},
      {"brand": "Apple", "widget": ThirdPartyRoundIconButton.apple()}
    ];

    for (final Map<String, dynamic> brand in brands) {
      group("${brand["brand"]}", () {
        testWidgets("It should have use the light image and theme is light",
            (WidgetTester tester) async {
          await tester.pumpLocalizedWidget(brand["widget"]);
          await tester.pumpAndSettle();

          final image = tester.widget<Image>(find.byType(Image)).image;
          expect(image, isA<AssetImage>());

          expect((image as AssetImage).assetName, endsWith("_light.png"),
              reason: "Image asset should use the light version");
        });

        testWidgets("It should have use the dark image and theme is dark",
            (WidgetTester tester) async {
          await tester.pumpLocalizedWidget(brand["widget"],
              themeMode: ThemeMode.dark);
          await tester.pumpAndSettle();

          final image = tester.widget<Image>(find.byType(Image)).image;
          expect(image, isA<AssetImage>());

          expect((image as AssetImage).assetName, endsWith("_dark.png"),
              reason: "Image asset should use the dark version");
        });
      });
    }
  });
}
