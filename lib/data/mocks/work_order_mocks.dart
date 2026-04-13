import 'package:demo_task/domain/model/work_order_model.dart';

List<WorkOrderModel> buildWorkOrderMocks() {
  final now = DateTime.now();

  return [
    WorkOrderModel(
      id: 'wo-104',
      title: 'Backflow Testing & Prevention',
      description:
          'Keep clean water clean with certified testing and prevention.',
      location: 'Dallas, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 1, hour: 9),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-101',
      title: 'Camera Line Inspection',
      description:
          'See inside your lines and find problems before they spread.',
      location: 'Fort Worth, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 2, hour: 10),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-102',
      title: 'Drain Cleaning',
      description: 'Clear the clog fast and restore flow without the fuss.',
      location: 'Plano-Frisco, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 3, hour: 8),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-103',
      title: 'Tankless Water Heater Install',
      description: 'Endless hot water with a compact and efficient upgrade.',
      location: 'Houston, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 4),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-105',
      title: 'Major HVAC Overhaul',
      description: 'Big install and overhaul work to rebuild efficiency.',
      location: 'Austin, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 5, hour: 13),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-106',
      title: 'Service Electrical Diagnostic',
      description: 'Smart diagnostics and quick fixes to keep lights on.',
      location: 'Katy, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 6),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-107',
      title: 'Garage Door Repair',
      description: 'Restore safe operation and smoother day-to-day access.',
      location: 'Round Rock, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 7, hour: 11),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-108',
      title: 'Drywall High Ceiling Repair',
      description:
          'Hard-to-reach ceiling damage repaired with a seamless finish.',
      location: 'The Woodlands, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 8),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-109',
      title: 'Roofing Repair Assessment',
      description:
          'Stop leaks fast and extend the roof life with targeted repairs.',
      location: 'San Antonio, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 9, hour: 14),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-110',
      title: 'French Drain Installation',
      description: 'Move water away from the yard and foundation effectively.',
      location: 'Sugar Land, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 10),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-111',
      title: 'Gutter Cleaning',
      description: 'Keep gutters clog-free and flowing to protect roof edges.',
      location: 'New Braunfels / Schertz, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 11),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-112',
      title: 'Pressure Washing',
      description: 'Blast away grime and restore curb appeal quickly.',
      location: 'El Paso, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 12, hour: 15),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-113',
      title: 'Attic Insulation Upgrade',
      description: 'Improve comfort year-round and lower utility bills.',
      location: 'Dallas, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 13),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-114',
      title: 'House Cleaning',
      description: 'Spotless spaces with a complete top-to-bottom clean.',
      location: 'Houston, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 14),
      status: WorkOrderStatus.pending,
    ),
    WorkOrderModel(
      id: 'wo-115',
      title: 'Tile Replacement',
      description: 'Fresh patterns and flawless lines for damaged floor areas.',
      location: 'Austin, Texas',
      scheduledDate: _relativeDate(now, daysFromNow: 15, hour: 9),
      status: WorkOrderStatus.pending,
    ),
  ];
}

DateTime _relativeDate(DateTime now, {required int daysFromNow, int hour = 0}) {
  return DateTime(now.year, now.month, now.day + daysFromNow, hour);
}
