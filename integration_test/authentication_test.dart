import 'package:f_testing_template/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

Future<void> fillForm(WidgetTester tester, String form, String email, String password) async {
  final emailField = find.byKey(Key("TextFormField${form}Email"));
  final passwordField = find.byKey(Key("TextFormField${form}Password"));

  await tester.enterText(emailField, email);
  await tester.enterText(passwordField, password);

  await tester.pump();
  await tester.tap(find.byKey(Key("Button${form}Submit")));
  await tester.pumpAndSettle();
}

void findText(String text) {
  final errorMessage = find.text(text);
  expect(errorMessage, findsOneWidget);
}

void main() {
  Future<Widget> createHomeScreen() async {
    WidgetsFlutterBinding.ensureInitialized();
    return const MyApp();
  }

  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("Login sin creación de usuario", (WidgetTester tester) async {
    Widget w = await createHomeScreen();
    await tester.pumpWidget(w);

    await fillForm(tester, "Login", "user@email.com", "12345678");
    findText("User or passwor nok");
  });

  testWidgets("Login -> signup -> creación usuario -> login no exitoso", (WidgetTester tester) async {
    Widget w = await createHomeScreen();
    await tester.pumpWidget(w);

    await tester.tap(find.byKey(const Key("ButtonLoginCreateAccount")));
    await fillForm(tester, "SignUp", "user@email.com", "12345678");
    await fillForm(tester, "Login", "user@email.com", "1234567");
    findText("User or passwor nok");
  });

  testWidgets("Login -> signup -> creación usuario -> login exitoso -> logout", (WidgetTester tester) async {
    Widget w = await createHomeScreen();
    await tester.pumpWidget(w);

    const email = "user@email.com";
    await tester.tap(find.byKey(const Key("ButtonLoginCreateAccount")));
    await fillForm(tester, "SignUp", email, "12345678");
    await fillForm(tester, "Login", email, "12345678");

    findText("Hello $email");

    final logout = find.byKey(const Key("ButtonHomeLogOff"));
    await tester.tap(logout);
    await tester.pumpAndSettle();

    findText("Login with email");
  });

  testWidgets("Login -> signup -> creación usuario -> login éxitoso -> logout -> login exitoso", (WidgetTester tester) async {
    Widget w = await createHomeScreen();
    await tester.pumpWidget(w);

    const email = "user@email.com";
    await tester.tap(find.byKey(const Key("ButtonLoginCreateAccount")));
    await fillForm(tester, "SignUp", email, "12345678");
    await fillForm(tester, "Login", email, "12345678");

    findText("Hello $email");

    final logout = find.byKey(const Key("ButtonHomeLogOff"));
    await tester.tap(logout);
    await tester.pumpAndSettle();

    findText("Login with email");

    await fillForm(tester, "Login", email, "12345678");
    findText("Hello $email");
  });

  testWidgets("Login -> signup -> creación usuario -> login éxitoso -> logout -> login no exitoso", (WidgetTester tester) async {
    Widget w = await createHomeScreen();
    await tester.pumpWidget(w);

    const email = "user@email.com";
    await tester.tap(find.byKey(const Key("ButtonLoginCreateAccount")));
    await fillForm(tester, "SignUp", email, "12345678");
    await fillForm(tester, "Login", email, "12345678");

    findText("Hello $email");

    final logout = find.byKey(const Key("ButtonHomeLogOff"));
    await tester.tap(logout);
    await tester.pumpAndSettle();

    findText("Login with email");

    await fillForm(tester, "Login", email, "1234567");
    findText("User or passwor nok");
  });
}
