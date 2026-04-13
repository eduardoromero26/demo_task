import 'package:demo_task/data/repositories/in_memory_work_order_repository.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/domain/repositories/work_order_photo_repository.dart';
import 'package:demo_task/main.dart';
import 'package:demo_task/presentation/bloc/work_orders_bloc.dart';
import 'package:demo_task/presentation/bloc/work_orders_event.dart';
import 'package:demo_task/presentation/screens/work_order_preview/work_order_preview_screen.dart';
import 'package:demo_task/presentation/screens/work_order_preview/widgets/work_order_status_confirmation_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _FakeWorkOrderPhotoRepository implements WorkOrderPhotoRepository {
  const _FakeWorkOrderPhotoRepository(this.path);

  final String path;

  @override
  Future<String?> capturePhoto() async => path;
}

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

  testWidgets('requires a photo before completing a work order', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      DemoTaskApp(
        repository: InMemoryWorkOrderRepository(latency: Duration.zero),
        photoRepository: const _FakeWorkOrderPhotoRepository(
          'test/completion-photo.jpg',
        ),
      ),
    );

    await tester.pumpAndSettle();

    await tester.tap(find.text('Backflow Testing & Prevention'));
    await tester.pumpAndSettle();

    final previewContext = tester.element(find.byType(WorkOrderPreviewScreen));
    previewContext.read<WorkOrdersBloc>().add(
      const WorkOrderStatusChangeRequested(
        workOrderId: 'wo-104',
        newStatus: WorkOrderStatus.inProgress,
      ),
    );
    await tester.pumpAndSettle();

    final confirmation = showWorkOrderStatusConfirmationDialog(
      previewContext,
      workOrderId: 'wo-104',
      workOrderTitle: 'Backflow Testing & Prevention',
      currentStatus: WorkOrderStatus.inProgress,
      nextStatus: WorkOrderStatus.completed,
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Completion requires at least one photo.'),
      findsOneWidget,
    );
    expect(find.text('Take Photo'), findsOneWidget);

    await tester.tap(find.text('Take Photo'));
    await tester.pumpAndSettle();

    expect(find.text('1 photo attached.'), findsOneWidget);

    await tester.ensureVisible(find.text('Complete'));
    await tester.tap(find.text('Complete'));
    await tester.pumpAndSettle();

    expect(await confirmation, isTrue);

    previewContext.read<WorkOrdersBloc>().add(
      const WorkOrderStatusChangeRequested(
        workOrderId: 'wo-104',
        newStatus: WorkOrderStatus.completed,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('COMPLETED'), findsOneWidget);
    expect(find.text('Completion photo'), findsOneWidget);
    expect(
      find.text('Backflow Testing & Prevention updated to Completed.'),
      findsOneWidget,
    );
  });
}
