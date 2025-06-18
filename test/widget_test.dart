// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:victim_voice/screens/registration_form.dart';

void main() {
  group('RegistrationForm Widget Tests', () {
    late WidgetTester tester;

    Future<void> pumpRegistrationForm() async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RegistrationForm(),
          ),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('Registration form should render without crashing', (WidgetTester widgetTester) async {
      tester = widgetTester;
      await pumpRegistrationForm();

      // Verify that the registration form renders
      expect(find.byType(RegistrationForm), findsOneWidget);
      expect(find.text('Complaint Form'), findsOneWidget);
    });

    testWidgets('Registration form should show all sections', (WidgetTester widgetTester) async {
      tester = widgetTester;
      await pumpRegistrationForm();

      // Verify all form sections are present
      expect(find.text('Filing Type'), findsOneWidget);
      expect(find.text('Personal Details'), findsOneWidget);
      expect(find.text('Complaint Details'), findsOneWidget);
      expect(find.text('Accused Information'), findsOneWidget);
      expect(find.text('Evidence & Attachments'), findsOneWidget);
      expect(find.text('Terms & Verification'), findsOneWidget);
    });

    testWidgets('Should toggle anonymous mode correctly', (WidgetTester widgetTester) async {
      tester = widgetTester;
      await pumpRegistrationForm();

      // Find the anonymous switch
      final anonymousSwitch = find.byType(SwitchListTile);
      expect(anonymousSwitch, findsOneWidget);

      // Toggle anonymous mode
      await tester.tap(anonymousSwitch);
      await tester.pumpAndSettle();

      // Verify personal details section is hidden
      expect(find.text('Personal Details'), findsNothing);
    });

    testWidgets('Should show progress indicator', (WidgetTester widgetTester) async {
      tester = widgetTester;
      await pumpRegistrationForm();

      // Verify progress indicator exists
      expect(find.text('Form Progress'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsOneWidget);
      expect(find.text('20% completed'), findsOneWidget); // Initial progress
    });

    testWidgets('Should show attachments section with proper info', (WidgetTester widgetTester) async {
      tester = widgetTester;
      await pumpRegistrationForm();

      // Verify attachments section exists with proper labels
      expect(find.text('Attachments'), findsOneWidget);
      expect(find.text('Allowed files: Images, PDF, DOC, MP4 (Max 10MB each)'), findsOneWidget);
      expect(find.text('Add Files (0/5)'), findsOneWidget);
      expect(find.text('No attachments added'), findsOneWidget);
    });
  });
}
