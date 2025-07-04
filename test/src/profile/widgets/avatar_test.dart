import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/profile/widgets/avatar.dart";

import "../../../dummies/user.dart";
import "../../../helpers.dart";

void main() {
  group("Avatar", () {
    testWidgets("renders SVG correctly", (WidgetTester tester) async {
      await tester.pumpLocalizedWidget(Avatar(svg: dummySvg));

      expect(find.byType(Avatar), findsOneWidget);
    });

    testWidgets("calls onTap when tapped", (WidgetTester tester) async {
      // Arrange
      bool wasTapped = false;
      final avatar = Avatar(svg: dummySvg, onTap: () => wasTapped = true);

      // Act
      await tester.pumpLocalizedWidget(avatar);
      await tester.tap(find.byType(Avatar));
      await tester.pump();

      // Assert
      expect(wasTapped, isTrue);
    });
  });
}
