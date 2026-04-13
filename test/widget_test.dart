import 'package:demo_task/data/repositories/in_memory_work_order_repository.dart';
import 'package:demo_task/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders pending work orders and updates one from preview', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      DemoTaskApp(
        repository: InMemoryWorkOrderRepository(latency: Duration.zero),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Active Jobs'), findsOneWidget);
    expect(find.text('Backflow Testing & Prevention'), findsOneWidget);
    expect(find.text('Filter'), findsOneWidget);
    expect(find.text('PENDING'), findsWidgets);

    await tester.tap(find.text('Backflow Testing & Prevention'));
    await tester.pumpAndSettle();

    final statusDropdown = find.byKey(
      const ValueKey('work-order-status-dropdown'),
    );
    await tester.ensureVisible(statusDropdown);
    await tester.tap(statusDropdown);
    await tester.pumpAndSettle();

    expect(find.text('Completed (Locked)'), findsOneWidget);

    await tester.tap(find.text('In Progress').last);
    await tester.pumpAndSettle();

    expect(find.text('Start this work order?'), findsOneWidget);

    await tester.tap(find.text('Start'));
    await tester.pumpAndSettle();

    expect(find.text('IN PROGRESS'), findsOneWidget);
    expect(find.text('Backflow Testing & Prevention'), findsOneWidget);
    expect(
      find.text('Backflow Testing & Prevention updated to In Progress.'),
      findsOneWidget,
    );
  });
}
