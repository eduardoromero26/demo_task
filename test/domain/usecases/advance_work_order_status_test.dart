import 'package:demo_task/data/repositories/in_memory_work_order_repository.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/domain/usecases/advance_work_order_status.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AdvanceWorkOrderStatus', () {
    test('throws when pending tries to move directly to completed', () async {
      final repository = InMemoryWorkOrderRepository(latency: Duration.zero);
      final useCase = AdvanceWorkOrderStatus(repository);
      final openWorkOrder = (await repository.fetchWorkOrders(
        page: 1,
      )).items.firstWhere((item) => item.status == WorkOrderStatus.pending);

      expect(
        () => useCase(
          workOrder: openWorkOrder,
          newStatus: WorkOrderStatus.completed,
        ),
        throwsA(isA<StateError>()),
      );
    });
  });
}
