import 'package:demo_task/domain/model/work_order_model.dart';
import 'package:equatable/equatable.dart';

class WorkOrderPage extends Equatable {
  const WorkOrderPage({required this.items, required this.hasMore});

  final List<WorkOrderModel> items;
  final bool hasMore;

  @override
  List<Object?> get props => [items, hasMore];
}
