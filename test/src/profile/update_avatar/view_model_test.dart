import "package:flutter_test/flutter_test.dart";
import "package:go_router/go_router.dart";
import "package:kana_to_kanji/src/core/repositories/user_repository.dart";
import "package:kana_to_kanji/src/locator.dart";
import "package:kana_to_kanji/src/profile/update_avatar/view_model.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

import "../../../dummies/user.dart";
import "../../../helpers.dart";
@GenerateNiceMocks([MockSpec<UserRepository>(), MockSpec<GoRouter>()])
import "view_model_test.mocks.dart";

/// Minimize SVG string to a single line.
String convertSvgToSingleLine(String svgString) =>
    svgString
        .replaceAll("\n", "")
        .replaceAll("\r", "")
        .replaceAll(RegExp(r"\s+"), " ")
        .trim();

void main() {
  group("UpdateAvatarViewModel", () {
    final MockUserRepository mockRepository = MockUserRepository();
    final MockGoRouter mockRouter = MockGoRouter();
    late UpdateAvatarViewModel viewModel;

    setUpAll(() {
      locator.registerSingleton<UserRepository>(mockRepository);
    });

    setUp(() {
      // Set up the mock repository to return a dummy user
      when(mockRepository.self).thenReturn(dummyUser);

      viewModel = UpdateAvatarViewModel(mockRouter);
    });

    tearDownAll(() async {
      await unregister<UserRepository>();
    });

    test("initializes with avatar from user", () {
      expect(convertSvgToSingleLine(viewModel.avatar), equals(dummySvg));
      verify(mockRepository.self).called(greaterThan(0));
    });

    test("updates avatar when controller changes", () {
      viewModel.makerController.randomizedSelectedOptions();

      expect(convertSvgToSingleLine(viewModel.avatar), isNot(equals(dummySvg)));
    });

    test("saves avatar and navigates back on successful save", () async {
      when(mockRepository.updateSelf(any)).thenAnswer((_) async => true);
      when(mockRouter.canPop()).thenReturn(true);

      await viewModel.save();

      verify(mockRepository.updateSelf(any)).called(1);
      verify(mockRouter.canPop()).called(1);
      verify(mockRouter.pop()).called(1);
      expect(viewModel.isBusy, isFalse);
    });

    test("handles save failure gracefully", () async {
      when(mockRepository.updateSelf(any)).thenAnswer((_) async => false);

      await viewModel.save();

      verify(mockRepository.updateSelf(any)).called(1);
      verifyNever(mockRouter.pop());
      expect(viewModel.isBusy, isFalse);
    });
  });
}
