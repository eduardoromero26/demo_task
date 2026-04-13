import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:demo_task/domain/model/work_order_page.dart';
import 'package:demo_task/domain/repositories/work_order_repository.dart';

class InMemoryWorkOrderRepository implements WorkOrderRepository {
  InMemoryWorkOrderRepository({
    this.latency = const Duration(milliseconds: 3000),
  }) : _pages = _buildPages();

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

      final updated = entry.value[index].copyWith(status: newStatus);
      entry.value[index] = updated;
      return updated.copyWith();
    }

    throw StateError('Work order $workOrderId was not found.');
  }

  static Map<int, List<WorkOrderModel>> _buildPages() {
    return {
      1: [
        WorkOrderModel(
          id: 'wo-104',
          title: 'HVAC System Overhaul',
          description: 'Enterprise Data Center - Phase 2',
          location: 'Enterprise Data Center - Phase 2',
          scheduledDate: DateTime(2023, 10, 24, 9),
          assignedTo: 'A. Rivera',
          status: WorkOrderStatus.pending,
          priority: WorkOrderPriority.high,
        ),
        WorkOrderModel(
          id: 'wo-101',
          title: 'Boiler Repair',
          description: 'Residential Unit #402',
          location: 'Residential Unit #402',
          scheduledDate: DateTime(2023, 10, 22),
          assignedTo: 'J. Chen',
          status: WorkOrderStatus.completed,
          priority: WorkOrderPriority.medium,
        ),
        WorkOrderModel(
          id: 'wo-102',
          title: 'Circuit Panel Test',
          description: 'West Wing Substation',
          location: 'West Wing Substation',
          scheduledDate: DateTime(2023, 10, 23),
          assignedTo: 'K. Adams',
          status: WorkOrderStatus.inProgress,
          priority: WorkOrderPriority.high,
        ),
        WorkOrderModel(
          id: 'wo-103',
          title: 'Generator Audit',
          description: 'Emergency Backup Unit',
          location: 'Emergency Backup Unit',
          scheduledDate: DateTime(2023, 10, 24),
          assignedTo: 'M. Patel',
          status: WorkOrderStatus.pending,
          priority: WorkOrderPriority.medium,
        ),
        WorkOrderModel(
          id: 'wo-105',
          title: 'Sensor Calibration',
          description: 'Lab 7 Gas Detectors',
          location: 'Lab 7 Gas Detectors',
          scheduledDate: DateTime(2023, 10, 21),
          assignedTo: 'L. Gomez',
          status: WorkOrderStatus.completed,
          priority: WorkOrderPriority.low,
        ),
      ],
      2: [
        WorkOrderModel(
          id: 'wo-106',
          title: 'Roof drain cleaning',
          description: 'Preventive maintenance before next storm window.',
          location: 'Warehouse 3',
          scheduledDate: DateTime(2026, 4, 16),
          assignedTo: 'R. Lewis',
          status: WorkOrderStatus.pending,
          priority: WorkOrderPriority.medium,
        ),
        WorkOrderModel(
          id: 'wo-107',
          title: 'Lighting panel rebalance',
          description: 'Current draw indicates uneven load distribution.',
          location: 'Production Hall',
          scheduledDate: DateTime(2026, 4, 17),
          assignedTo: 'S. Novak',
          status: WorkOrderStatus.scheduled,
          priority: WorkOrderPriority.high,
        ),
        WorkOrderModel(
          id: 'wo-108',
          title: 'Pump vibration follow-up',
          description: 'Second pass after bearing replacement.',
          location: 'Water Treatment',
          scheduledDate: DateTime(2026, 4, 17),
          assignedTo: 'I. Silva',
          status: WorkOrderStatus.inProgress,
          priority: WorkOrderPriority.high,
        ),
        WorkOrderModel(
          id: 'wo-109',
          title: 'Fence line camera alignment',
          description: 'Resume after network switch change freeze.',
          location: 'Perimeter East',
          scheduledDate: DateTime(2026, 4, 18),
          assignedTo: 'D. Brooks',
          status: WorkOrderStatus.blocked,
          priority: WorkOrderPriority.low,
        ),
        WorkOrderModel(
          id: 'wo-110',
          title: 'Cooling tower water test',
          description: 'Routine chemistry sample collection.',
          location: 'Utilities Plant',
          scheduledDate: DateTime(2026, 4, 18),
          assignedTo: 'T. Young',
          status: WorkOrderStatus.completed,
          priority: WorkOrderPriority.medium,
        ),
      ],
      3: [
        WorkOrderModel(
          id: 'wo-111',
          title: 'Emergency shower flush verification',
          description: 'Monthly compliance spot check.',
          location: 'Lab Wing',
          scheduledDate: DateTime(2026, 4, 19),
          assignedTo: 'E. Price',
          status: WorkOrderStatus.pending,
          priority: WorkOrderPriority.low,
        ),
        WorkOrderModel(
          id: 'wo-112',
          title: 'Dock leveler hydraulic test',
          description: 'Post-repair functional validation.',
          location: 'Receiving Bay',
          scheduledDate: DateTime(2026, 4, 20),
          assignedTo: 'N. Ford',
          status: WorkOrderStatus.scheduled,
          priority: WorkOrderPriority.medium,
        ),
        WorkOrderModel(
          id: 'wo-113',
          title: 'Battery room exhaust calibration',
          description: 'Recalibrate after air flow sensor replacement.',
          location: 'Energy Storage',
          scheduledDate: DateTime(2026, 4, 21),
          assignedTo: 'P. King',
          status: WorkOrderStatus.inProgress,
          priority: WorkOrderPriority.high,
        ),
        WorkOrderModel(
          id: 'wo-114',
          title: 'Water ingress inspection',
          description: 'Resume after ceiling panel access approval.',
          location: 'Archive Room',
          scheduledDate: DateTime(2026, 4, 21),
          assignedTo: 'B. White',
          status: WorkOrderStatus.blocked,
          priority: WorkOrderPriority.medium,
        ),
        WorkOrderModel(
          id: 'wo-115',
          title: 'Server rack grounding audit',
          description: 'Final verification signed by facilities engineering.',
          location: 'Server Hall B',
          scheduledDate: DateTime(2026, 4, 22),
          assignedTo: 'C. Bell',
          status: WorkOrderStatus.completed,
          priority: WorkOrderPriority.low,
        ),
      ],
    };
  }
}
