import 'package:demo_task/core/theme/app_theme.dart';
import 'package:demo_task/data/repositories/in_memory_work_order_repository.dart';
import 'package:demo_task/domain/repositories/work_order_repository.dart';
import 'package:demo_task/domain/usecases/advance_work_order_status.dart';
import 'package:demo_task/domain/usecases/get_work_orders_page.dart';
import 'package:demo_task/presentation/bloc/work_orders_bloc.dart';
import 'package:demo_task/presentation/bloc/work_orders_event.dart';
import 'package:demo_task/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const DemoTaskApp());
}

class DemoTaskApp extends StatelessWidget {
  const DemoTaskApp({super.key, WorkOrderRepository? repository})
    : _repository = repository;

  final WorkOrderRepository? _repository;

  @override
  Widget build(BuildContext context) {
    final repository = _repository ?? InMemoryWorkOrderRepository();

    return RepositoryProvider<WorkOrderRepository>.value(
      value: repository,
      child: BlocProvider(
        create: (_) => WorkOrdersBloc(
          getWorkOrdersPage: GetWorkOrdersPage(repository),
          advanceWorkOrderStatus: AdvanceWorkOrderStatus(repository),
        )..add(const WorkOrdersStarted()),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Work Orders Demo',
          theme: AppTheme.light,
          home: const HomeScreen(),
        ),
      ),
    );
  }
}
