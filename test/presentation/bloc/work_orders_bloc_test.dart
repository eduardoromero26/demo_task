import 'package:demo_task/data/repositories/in_memory_work_order_repository.dart';
import 'package:demo_task/domain/repositories/work_order_photo_repository.dart';
import 'package:demo_task/domain/usecases/attach_work_order_photo.dart';
import 'package:demo_task/domain/usecases/advance_work_order_status.dart';
import 'package:demo_task/domain/usecases/capture_work_order_photo.dart';
import 'package:demo_task/domain/usecases/get_work_orders_page.dart';
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
    test(
      'keeps loaded items visible when page 3 fails and retries it',
      () async {
        final repository = InMemoryWorkOrderRepository(latency: Duration.zero);
        final bloc = WorkOrdersBloc(
          getWorkOrdersPage: GetWorkOrdersPage(repository),
          advanceWorkOrderStatus: AdvanceWorkOrderStatus(repository),
          captureWorkOrderPhoto: CaptureWorkOrderPhoto(
            const _NoopWorkOrderPhotoRepository(),
          ),
          attachWorkOrderPhoto: AttachWorkOrderPhoto(repository),
        );

        bloc.add(const WorkOrdersStarted());
        await bloc.stream.firstWhere(
          (state) => state.status == WorkOrdersLoadStatus.success,
        );
        expect(bloc.state.workOrders, hasLength(5));

        bloc.add(const WorkOrdersNextPageRequested());
        await bloc.stream.firstWhere((state) => state.workOrders.length == 10);
        expect(bloc.state.paginationErrorMessage, isNull);

        bloc.add(const WorkOrdersNextPageRequested());
        final failedState = await bloc.stream.firstWhere(
          (state) => state.paginationErrorMessage != null,
        );
        expect(failedState.workOrders, hasLength(10));

        bloc.add(const WorkOrdersRetryNextPageRequested());
        final recoveredState = await bloc.stream.firstWhere(
          (state) => state.workOrders.length == 15,
        );
        expect(recoveredState.paginationErrorMessage, isNull);

        await bloc.close();
      },
    );
  });
}
