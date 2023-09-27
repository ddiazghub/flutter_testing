// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:f_testing_template/main.dart';
import 'package:f_testing_template/ui/pages/authentication/login.dart';
import 'package:f_testing_template/ui/pages/content/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

void testForm(WidgetTester tester, String form, String email, String password, void Function() callback) async {
  const app = MyApp();
  await tester.pumpWidget(app);

  final emailField = find.byKey(Key("TextFormField${form}Email"));
  final passwordField = find.byKey(Key("TextFormField${form}Password"));

  await tester.enterText(emailField, email);
  await tester.enterText(passwordField, password);

  await tester.pump();
  await tester.tap(find.byKey(Key("Button${form}Submit")));
  await tester.pumpAndSettle();

  callback();
}

void findText(String text) {
  final errorMessage = find.text(text);
  expect(errorMessage, findsOneWidget);
}

void testLogin(WidgetTester tester, String email, String password, String error) async {
  testForm(tester, "Login", email, password, () => findText(error));
}

void testSignUp(WidgetTester tester, String email, String password, String error) async {
  testForm(tester, "Login", email, password, () => findText(error));
}

void main() {
  testWidgets('Widget login validación @ email', (WidgetTester tester) async {
    testLogin(tester, "invalid", "password", "Enter valid email address");
  });

  testWidgets('Widget login validación campo vacio email', (WidgetTester tester) async {
    testLogin(tester, "", "password", "Enter email");
  });

  testWidgets('Widget login validación número de caracteres password', (WidgetTester tester) async {
    testLogin(tester, "user@email.com", "pass", "Password should have at least 6 characters");
  });

  testWidgets('Widget login validación campo vacio password', (WidgetTester tester) async {
    testLogin(tester, "user@email.com", "", "Enter password");
  });

  testWidgets('Widget login autenticación exitosa', (WidgetTester tester) async {
  });

  testWidgets('Widget login autenticación no exitosa', (WidgetTester tester) async {
    testLogin(tester, "user@email.com", "12345678", "User or passwor nok");
  });

  testWidgets('Widget signUp validación @ email', (WidgetTester tester) async {
    const email = "user@email.com";
    const password = "12345678";
    const app = GetMaterialApp(home: LoginScreen(email: email, password: password));
    await tester.pumpWidget(app);

    final emailField = find.byKey(const Key("TextFormFieldLoginEmail"));
    final passwordField = find.byKey(const Key("TextFormFieldLoginPassword"));

    await tester.enterText(emailField, email);
    await tester.enterText(passwordField, password);

    await tester.pump();
    await tester.tap(find.byKey(const Key("ButtonLoginSubmit")));
    await tester.pumpAndSettle();

    findText("Hello $email");
  });

  testWidgets('Widget signUp validación campo vacio email', (WidgetTester tester) async {
    testSignUp(tester, "", "password", "Enter email");
  });

  testWidgets('Widget signUp validación número de caracteres password', (WidgetTester tester) async {
    testSignUp(tester, "user@email.com", "pass", "Password should have at least 6 characters");
  });

  testWidgets('Widget signUp validación campo vacio password', (WidgetTester tester) async {
    testSignUp(tester, "user@email.com", "", "Enter password");
  });

  testWidgets('Widget home visualización correo', (WidgetTester tester) async {
    const email = "user@email.com";
    const password = "12345678";
    const app = GetMaterialApp(home: HomePage(loggedEmail: email, loggedPassword: password));
    await tester.pumpWidget(app);

    findText("Hello $email");
  });

  testWidgets('Widget home nevegación detalle', (WidgetTester tester) async {
    const email = "user@email.com";
    const password = "12345678";
    const app = GetMaterialApp(home: HomePage(loggedEmail: email, loggedPassword: password));
    await tester.pumpWidget(app);

    final detailsButton = find.byKey(const Key("ButtonHomeDetail"));
    await tester.tap(detailsButton);
    await tester.pumpAndSettle();

    findText("Some detail");
  });

  testWidgets('Widget home logout', (WidgetTester tester) async {
    const email = "user@email.com";
    const password = "12345678";
    const app = GetMaterialApp(home: HomePage(loggedEmail: email, loggedPassword: password));
    await tester.pumpWidget(app);

    final logout = find.byKey(const Key("ButtonHomeLogOff"));
    await tester.tap(logout);
    await tester.pumpAndSettle();

    findText("Login with email");
  });
}
