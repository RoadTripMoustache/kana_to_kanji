import 'package:feedback/feedback.dart';
import 'package:feedback/src/feedback_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:kana_to_kanji/src/core/services/dialog_service.dart';
import 'package:kana_to_kanji/src/core/services/info_service.dart';
import 'package:kana_to_kanji/src/core/widgets/app_config.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_form_fields.dart';
import 'package:kana_to_kanji/src/feedback/constants/feedback_type.dart';
import 'package:kana_to_kanji/src/feedback/feedback_view_model.dart';
import 'package:kana_to_kanji/src/feedback/service/github_service.dart';
import 'package:kana_to_kanji/src/feedback/utils/build_issue_helper.dart';
import 'package:kana_to_kanji/src/locator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:image/image.dart' as image;

import '../../helpers.dart';

@GenerateNiceMocks([
  MockSpec<GoRouter>(),
  MockSpec<GithubService>(),
  MockSpec<BuildContext>(),
  MockSpec<FeedbackData>(),
  MockSpec<FeedbackController>(),
  MockSpec<DialogService>(),
  MockSpec<InfoService>()
])
import 'feedback_view_model_test.mocks.dart';

class MockCallbackFunction extends Mock {
  call();
}

void main() {
  // Needed for screenshot testing.
  TestWidgetsFlutterBinding.ensureInitialized();

  group("FeedbackViewModel", () {
    const AppConfig appConfig =
        AppConfig(environment: Environment.dev, child: Placeholder());
    late final AppLocalizations l10n;
    final MockGithubService githubServiceMock = MockGithubService();
    final GoRouter goRouterMock = MockGoRouter();
    final MockDialogService dialogServiceMock = MockDialogService();
    final MockInfoService infoServiceMock = MockInfoService();
    final MockCallbackFunction notifyListenersCallback = MockCallbackFunction();

    late FeedbackViewModel viewModel;

    setUpAll(() async {
      l10n = await setupLocalizations();
      locator.registerSingleton<DialogService>(dialogServiceMock);
      locator.registerSingleton<InfoService>(infoServiceMock);
    });

    setUp(() {
      viewModel = FeedbackViewModel(
          appConfig: appConfig,
          router: goRouterMock,
          l10n: l10n,
          githubService: githubServiceMock)
        ..addListener(notifyListenersCallback.call);
    });

    tearDown(() {
      reset(goRouterMock);
      reset(githubServiceMock);
      reset(dialogServiceMock);
      reset(infoServiceMock);
      reset(notifyListenersCallback);
    });

    tearDownAll(() {
      locator.unregister<DialogService>(instance: dialogServiceMock);
      locator.unregister<InfoService>(instance: infoServiceMock);
    });

    group("Feedback type", () {
      test("selectedFeedbackType set by constructor", () {
        expect(viewModel.selectedFeedbackType, null,
            reason: "Default value should be null");
        viewModel = FeedbackViewModel(
            appConfig: appConfig,
            router: goRouterMock,
            l10n: l10n,
            githubService: githubServiceMock,
            feedbackType: FeedbackType.bug);
        expect(viewModel.selectedFeedbackType, FeedbackType.bug,
            reason: "Should follow the value passed to the constructor");
      });

      test("onFeedbackTypePressed should set selectedFeedbackType", () {
        expect(viewModel.selectedFeedbackType, null,
            reason: "Default value should be null");
        viewModel.onFeedbackTypePressed(FeedbackType.featureRequest);
        expect(viewModel.selectedFeedbackType, FeedbackType.featureRequest);
        verify(notifyListenersCallback()).called(1);
      });
    });

    group("Form", () {
      group("isFormSubmitEnabled", () {});

      group("isFormAddScreenshotEnabled", () {});

      test(
          "onFormChange should update the corresponding value and call listeners",
          () {
        for (final field in FeedbackFormFields.values) {
          expect(viewModel.formData[field], "",
              reason: "Should be empty by default");
          viewModel.onFormChange(field, field.name);
          expect(viewModel.formData[field], field.name,
              reason:
                  "Should have been updated with the passed value (in this case the field name)");
        }

        verify(notifyListenersCallback())
            .called(FeedbackFormFields.values.length);
      });

      group("formValidator", () {
        test("email", () {
          final Map<String?, String?> emails = {
            "invalid": l10n.invalid_email,
            "asd@@asd.com": l10n.invalid_email,
            "asd@asd": l10n.invalid_email,
            "abc-@mail.com": l10n.invalid_email,
            ".abc@mail.com": l10n.invalid_email,
            "abc..def@mail.c": l10n.invalid_email,
            "abc@mail..com": l10n.invalid_email,
            "abc@mail#test.com": l10n.invalid_email,
            "test@test.com": null,
            "test.test@test.com": null,
            "test+123@test.com": null,
            "test-test@mail.com": null,
            "test_test@mail.com": null,
            "": null,
            null: null
          };

          for (final entry in emails.entries) {
            expect(viewModel.formValidator(FeedbackFormFields.email, entry.key),
                entry.value,
                reason:
                    "${entry.key} should be ${entry.value == null ? "allowed" : "refused"}");
          }
        });

        test("description", () {
          // Description required
          viewModel.onFeedbackTypePressed(FeedbackType.featureRequest);
          expect(viewModel.formValidator(FeedbackFormFields.description, null),
              l10n.feedback_empty_description,
              reason:
                  "Null description isn't allowed when feedback is feature request");
          expect(viewModel.formValidator(FeedbackFormFields.description, ""),
              l10n.feedback_empty_description,
              reason:
                  "Empty description isn't allowed when feedback is feature request");
          expect(
              viewModel.formValidator(
                  FeedbackFormFields.description, "Description"),
              null,
              reason: "Filled description should be allowed");

          // Description not required
          viewModel.onFeedbackTypePressed(FeedbackType.bug);
          expect(viewModel.formValidator(FeedbackFormFields.description, null),
              null,
              reason: "Null description is allowed when feedback is bug");
          expect(
              viewModel.formValidator(FeedbackFormFields.description, ""), null,
              reason: "Empty description is allowed when feedback is bug");
          expect(
              viewModel.formValidator(
                  FeedbackFormFields.description, "Description"),
              null,
              reason: "Filled description should be allowed");
        });

        test("steps to reproduce", () {
          // Description required
          viewModel.onFeedbackTypePressed(FeedbackType.bug);
          expect(
              viewModel.formValidator(
                  FeedbackFormFields.stepsToReproduce, null),
              l10n.feedback_empty_steps_to_reproduce,
              reason: "Null isn't allowed when feedback is bug");
          expect(
              viewModel.formValidator(FeedbackFormFields.stepsToReproduce, ""),
              l10n.feedback_empty_steps_to_reproduce,
              reason: "Empty isn't allowed when feedback is bug");
          expect(
              viewModel.formValidator(
                  FeedbackFormFields.stepsToReproduce, "Steps to reproduce"),
              null,
              reason: "Filled should be allowed");

          // Description not required
          viewModel.onFeedbackTypePressed(FeedbackType.featureRequest);
          expect(
              viewModel.formValidator(
                  FeedbackFormFields.stepsToReproduce, null),
              null,
              reason: "Null is allowed when feedback is feature request");
          expect(
              viewModel.formValidator(FeedbackFormFields.stepsToReproduce, ""),
              null,
              reason: "Empty is allowed when feedback is feature request");
          expect(
              viewModel.formValidator(
                  FeedbackFormFields.stepsToReproduce, "steps"),
              null,
              reason: "Filled should be allowed");
        });
      });

      test("onIncludeScreenshotPressed", () {
        final MockFeedbackController feedbackControllerMock =
            MockFeedbackController();
        final BuildContext contextMock = MockBuildContext();
        final FeedbackData feedbackDataMock = MockFeedbackData();
        when(feedbackDataMock.controller).thenReturn(feedbackControllerMock);
        when(contextMock.dependOnInheritedWidgetOfExactType<FeedbackData>())
            .thenReturn(feedbackDataMock);

        viewModel.onIncludeScreenshotPressed(contextMock);

        verifyInOrder([goRouterMock.pop(), feedbackControllerMock.show(any)]);

        verifyNoMoreInteractions(goRouterMock);
        verifyNoMoreInteractions(feedbackControllerMock);

        reset(feedbackControllerMock);
      });

      group("onFormSubmit", () {
        setUp(() {
          when(infoServiceMock.devicePlatformName)
              .thenReturn("devicePlatformName");
          when(infoServiceMock.platformVersion).thenReturn("platformVersion");
          when(infoServiceMock.appFullVersion).thenReturn("appFullVersion");
        });

        test("should create the github issue, close the popup and show success",
            () async {
          // Prepare the model
          viewModel.onFeedbackTypePressed(FeedbackType.featureRequest);
          viewModel.formData
              .update(FeedbackFormFields.email, (value) => "Email");
          viewModel.formData
              .update(FeedbackFormFields.description, (value) => "Description");

          // Execute the function
          await viewModel.onFormSubmit();

          // Verify Github create issue call
          final capturedArgs = verify(githubServiceMock.createIssue(
                  title: captureAnyNamed("title"),
                  body: captureAnyNamed("body"),
                  labels: captureThat(isList, named: "labels")))
              .captured;
          expect(capturedArgs.length, 3);
          expect(capturedArgs[0], buildIssueTitle(FeedbackType.featureRequest));
          expect(capturedArgs[1],
              buildIssueBody(appConfig.environment, viewModel.formData));
          expect(capturedArgs[2], <String>[FeedbackType.featureRequest.value]);

          // Verify all the other calls
          verifyInOrder([
            goRouterMock.pop(),
            dialogServiceMock.showModalBottomSheet(
                builder: anyNamed("builder"), isDismissible: false)
          ]);
          verifyNoMoreInteractions(goRouterMock);
          verifyNoMoreInteractions(githubServiceMock);
          verifyNoMoreInteractions(dialogServiceMock);
        });

        test("should upload image, create the github issue, and show success",
            () async {
          // Get an image
          final Uint8List bytes = (await rootBundle.load(
                  'packages/kana_to_kanji/assets/images/flutter_logo.png'))
              .buffer
              .asUint8List();
          final Uint8List screenshotData = image.encodePng(image.copyResize(
              image.decodeImage(bytes)!,
              width: kScreenshotLandscapeWidth));
          const String screenshotUrl = "screenshotUrl";

          // Stub returns
          when(githubServiceMock.uploadFileToGithub(
                  filePath: anyNamed("filePath"),
                  fileInBytes: anyNamed("fileInBytes")))
              .thenAnswer((_) async => screenshotUrl);

          // Prepare the model
          viewModel.onFeedbackTypePressed(FeedbackType.bug);
          viewModel.formData
              .update(FeedbackFormFields.email, (value) => "Email");
          viewModel.formData.update(FeedbackFormFields.stepsToReproduce,
              (value) => "Steps to reproduce");

          // Execute the function
          await viewModel.onFormSubmit(bytes);

          // Verify Github upload image call
          verify(githubServiceMock.uploadFileToGithub(
              filePath: anyNamed("filePath"),
              fileInBytes: screenshotData.toList(growable: false)));
          // Verify Github create issue call
          final capturedArgs = verify(githubServiceMock.createIssue(
                  title: captureAnyNamed("title"),
                  body: captureAnyNamed("body"),
                  labels: captureThat(isList, named: "labels")))
              .captured;
          expect(capturedArgs.length, 3);
          expect(capturedArgs[0], buildIssueTitle(FeedbackType.bug));
          expect(
              capturedArgs[1],
              buildIssueBody(
                  appConfig.environment, viewModel.formData, screenshotUrl));
          expect(capturedArgs[2], <String>[FeedbackType.bug.value]);

          // Verify success popup is opened
          verify(dialogServiceMock.showModalBottomSheet(
              builder: anyNamed("builder"), isDismissible: false));

          verifyNoMoreInteractions(goRouterMock);
          verifyNoMoreInteractions(githubServiceMock);
          verifyNoMoreInteractions(dialogServiceMock);
        });
      });
    });
  });
}
