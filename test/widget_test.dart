import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:business_managment_system/model/Course.dart';
import 'package:business_managment_system/presentation/screens/courses/courses_page.dart';
import 'package:business_managment_system/presentation/screens/dashboard/dashboard_page.dart';

void main() {
  testWidgets('Dashboard shows academy overview', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    expect(find.text('CourseAcademy'), findsOneWidget);
    expect(find.text('Dashboard'), findsWidgets);
    expect(find.text('Active Courses'), findsOneWidget);
    expect(find.text('Recent Registrations'), findsOneWidget);
    expect(find.text('Popular Courses'), findsOneWidget);
  });

  testWidgets('Dashboard Add Course opens add course page', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(const MaterialApp(home: DashboardPage()));

    await tester.tap(find.text('+  Add Course'));
    await tester.pumpAndSettle();

    expect(find.text('Add New Course'), findsOneWidget);
    expect(find.text('Create Course'), findsOneWidget);
  });

  testWidgets('Courses page shows course table', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: CoursesPage(
          loader: () async =>  [
            Course(
              id: 1,
              createdAt: DateTime.fromMillisecondsSinceEpoch(0),
              name: 'Flutter Development',
              price: 3000,
              posterUrl: '',
              description: 'Build modern apps with Flutter',
              duration: '12 weeks',
              status: 'Active',
              capacity: 20,
              instructor: 'Ahmed Mohamed',
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Courses'), findsWidgets);
    expect(find.text('Flutter Development'), findsOneWidget);
    expect(find.text('Add Course'), findsOneWidget);
    expect(find.text('All Statuses'), findsOneWidget);
  });

  testWidgets('Add Course opens add course page', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: CoursesPage(loader: () async => const []),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Add Course'));
    await tester.pumpAndSettle();

    expect(find.text('Add New Course'), findsOneWidget);
    expect(find.text('Back to Courses'), findsOneWidget);
    expect(find.text('Create Course'), findsOneWidget);
    expect(find.text('Course Information'), findsOneWidget);
    expect(find.text('Choose Image'), findsOneWidget);
  });

  testWidgets('Edit action opens edit course page', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(1600, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: CoursesPage(
          loader: () async => [
            Course(
              id: 1,
              createdAt: DateTime.fromMillisecondsSinceEpoch(0),
              name: 'Flutter Development',
              price: 3000,
              posterUrl: '',
              description: 'Build modern apps with Flutter',
              duration: '12 weeks',
              status: 'Active',
              capacity: 20,
              instructor: 'Ahmed Mohamed',
            ),
          ],
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.byTooltip('Edit'));
    await tester.pumpAndSettle();

    expect(find.text('Edit Course'), findsOneWidget);
    expect(find.text('Update the course details and save changes.'), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
    expect(find.text('Choose Image'), findsOneWidget);
    expect(find.text('Flutter Development'), findsWidgets);
    expect(find.text('Ahmed Mohamed'), findsWidgets);
    expect(find.text('Preview'), findsOneWidget);
  });
}
