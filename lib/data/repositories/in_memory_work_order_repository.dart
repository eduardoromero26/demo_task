import 'package:demo_task/data/mocks/work_order_mock_pages.dart';
import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/domain/model/work_order_page.dart';
import 'package:demo_task/domain/repositories/work_order_repository.dart';

class InMemoryWorkOrderRepository implements WorkOrderRepository {
  InMemoryWorkOrderRepository({
    this.latency = const Duration(milliseconds: 2000),
    Map<int, List<WorkOrderModel>>? pages,
  }) : _pages = _clonePages(pages ?? buildWorkOrderMockPages());

  final Duration latency;
  final Map<int, List<WorkOrderModel>> _pages;
  bool _pageThreeShouldFail = true;

  @override
  Future<WorkOrderPage> fetchWorkOrders({required int page}) async {
    await Future<void>.delayed(latency);

    if (page == 3 && _pageThreeShouldFail) {
      _pageThreeShouldFail = false;
      throw Exception('Page 3 failed. Existing items remain visible.');
    }

    final items = _pages[page] ?? const <WorkOrderModel>[];
    return WorkOrderPage(
      items: items.map((workOrder) => workOrder.copyWith()).toList(),
      hasMore: page < _pages.length,
    );
  }

  @override
  Future<WorkOrderModel> updateWorkOrderStatus({
    required String workOrderId,
    required WorkOrderStatus newStatus,
  }) async {
    await Future<void>.delayed(latency);

    for (final entry in _pages.entries) {
      final index = entry.value.indexWhere((item) => item.id == workOrderId);
      if (index == -1) {
        continue;
      }

      final current = entry.value[index];
      final shouldAssignCurrentUser =
          newStatus != WorkOrderStatus.pending &&
          (current.assignedTo == null || current.assignedTo!.trim().isEmpty);
      final updated = current.copyWith(
        status: newStatus,
        assignedTo: shouldAssignCurrentUser ? 'You' : current.assignedTo,
      );
      entry.value[index] = updated;
      return updated.copyWith();
    }

    throw StateError('Work order $workOrderId was not found.');
  }

  static Map<int, List<WorkOrderModel>> _clonePages(
    Map<int, List<WorkOrderModel>> pages,
  ) {
    return {
      for (final entry in pages.entries)
        entry.key: entry.value
            .map((workOrder) => workOrder.copyWith())
            .toList(),
    };
  }
}
