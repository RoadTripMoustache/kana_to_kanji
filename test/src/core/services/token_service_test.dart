import "package:firebase_auth/firebase_auth.dart";
import "package:flutter_test/flutter_test.dart";
import "package:kana_to_kanji/src/core/services/token_service.dart";
import "package:mockito/annotations.dart";
import "package:mockito/mockito.dart";

@GenerateNiceMocks([MockSpec<UserCredential>(), MockSpec<User>()])
import "token_service_test.mocks.dart";

void main() {
  group("TokenService", () {
    final service = TokenService();
    group("getToken", () {
      test("Before initialisation", () async {
        final String? token = await service.getToken();

        expect(token, null);
      });

      test("After initialisation without user", () async {
        final userCredentialMock = MockUserCredential();

        service.token = userCredentialMock;
        final String? token = await service.getToken();

        expect(token, null);
        verify(userCredentialMock.user).called(1);
        verifyNever(userCredentialMock.user?.getIdToken());
      });

      test("After initialisation with a valid user", () async {
        final userCredentialMock = MockUserCredential();
        final userMock = MockUser();
        when(
          userMock.getIdToken(),
        ).thenAnswer((realInvocation) => Future.value("toto"));
        when(userCredentialMock.user).thenReturn(userMock);

        service.token = userCredentialMock;
        final String? token = await service.getToken();

        expect(token, "toto");
        verify(userCredentialMock.user?.getIdToken()).called(1);
      });
    });
  });
}
