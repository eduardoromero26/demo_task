import 'package:demo_task/data/repositories/in_memory_work_order_repository.dart';
import 'package:demo_task/domain/usecases/advance_work_order_status.dart';
import 'package:demo_task/domain/usecases/get_work_orders_page.dart';
import 'package:demo_task/presentation/bloc/work_orders_bloc.dart';
import 'package:demo_task/presentation/bloc/work_orders_event.dart';
import 'package:demo_task/presentation/bloc/work_orders_state.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('WorkOrdersBloc', () {
    test(
      'keeps loaded items visible when page 3 fails and retries it',
      () async {
        final repository = InMemoryWorkOrderRepository(latency: Duration.zero);
        final bloc = WorkOrdersBloc(
          getWorkOrdersPage: GetWorkOrdersPage(repository),
          advanceWorkOrderStatus: AdvanceWorkOrderStatus(repository),
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
