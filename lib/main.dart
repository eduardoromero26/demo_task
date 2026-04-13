import 'package:demo_task/core/theme/app_theme.dart';
import 'package:demo_task/data/repositories/image_picker_work_order_photo_repository.dart';
import 'package:demo_task/data/repositories/in_memory_work_order_repository.dart';
import 'package:demo_task/domain/repositories/work_order_photo_repository.dart';
import 'package:demo_task/domain/repositories/work_order_repository.dart';
import 'package:demo_task/domain/usecases/advance_work_order_status.dart';
import 'package:demo_task/presentation/bloc/work_orders_bloc.dart';
import 'package:demo_task/presentation/bloc/work_orders_event.dart';
import 'package:demo_task/presentation/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const DemoTaskApp());
}

class DemoTaskApp extends StatelessWidget {
  const DemoTaskApp({
    super.key,
    WorkOrderRepository? repository,
    WorkOrderPhotoRepository? photoRepository,
  }) : _repository = repository,
       _photoRepository = photoRepository;

  final WorkOrderRepository? _repository;
  final WorkOrderPhotoRepository? _photoRepository;

  @override
  Widget build(BuildContext context) {
    final repository = _repository ?? InMemoryWorkOrderRepository();
    final photoRepository =
        _photoRepository ?? ImagePickerWorkOrderPhotoRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<WorkOrderRepository>.value(value: repository),
        RepositoryProvider<WorkOrderPhotoRepository>.value(
          value: photoRepository,
        ),
      ],
      child: BlocProvider(
        create: (_) => WorkOrdersBloc(
          workOrderRepository: repository,
          workOrderPhotoRepository: photoRepository,
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
