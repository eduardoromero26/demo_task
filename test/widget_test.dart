import 'package:demo_task/data/repositories/in_memory_work_order_repository.dart';
import 'package:demo_task/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renders loaded work orders and supports filtering', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      DemoTaskApp(
        repository: InMemoryWorkOrderRepository(latency: Duration.zero),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Active Jobs'), findsOneWidget);
    expect(find.text('HVAC System Overhaul'), findsOneWidget);
    expect(find.text('Filter'), findsOneWidget);

    await tester.tap(find.text('Filter'));
    await tester.pumpAndSettle();

    final completedOption = find.text('Completed');
    await tester.ensureVisible(completedOption);
    await tester.tap(completedOption);
    await tester.pumpAndSettle();

    expect(find.text('Boiler Repair'), findsOneWidget);
    expect(find.text('Sensor Calibration'), findsOneWidget);
    expect(find.text('HVAC System Overhaul'), findsNothing);
  });
}
