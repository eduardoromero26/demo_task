import 'package:demo_task/data/repositories/in_memory_work_order_repository.dart';
import 'package:demo_task/domain/repositories/work_order_photo_repository.dart';
import 'package:demo_task/domain/usecases/advance_work_order_status.dart';
import 'package:demo_task/presentation/bloc/work_orders_bloc.dart';
import 'package:demo_task/presentation/bloc/work_orders_event.dart';
import 'package:demo_task/presentation/bloc/work_orders_state.dart';
import 'package:flutter_test/flutter_test.dart';

class _NoopWorkOrderPhotoRepository implements WorkOrderPhotoRepository {
  const _NoopWorkOrderPhotoRepository();

  @override
  Future<String?> capturePhoto() async => null;
}

void main() {
  group('WorkOrdersBloc', () {
    test('loads all mocked work orders on start', () async {
      final repository = InMemoryWorkOrderRepository(latency: Duration.zero);
      final bloc = WorkOrdersBloc(
        workOrderRepository: repository,
        workOrderPhotoRepository: const _NoopWorkOrderPhotoRepository(),
        advanceWorkOrderStatus: AdvanceWorkOrderStatus(repository),
      );

      bloc.add(const WorkOrdersStarted());
      await bloc.stream.firstWhere(
        (state) => state.status == WorkOrdersLoadStatus.success,
      );

      expect(bloc.state.workOrders, hasLength(15));
      expect(bloc.state.initialErrorMessage, isNull);

      await bloc.close();
    });
  });
}
