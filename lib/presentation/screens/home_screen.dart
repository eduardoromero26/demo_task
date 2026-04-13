import 'package:demo_task/presentation/bloc/bloc/job_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    context.read<JobBloc>().add(LoadJobs());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<JobBloc, JobState>(
        builder: (BuildContext context, JobState state) {
          switch (state) {
            case JobInitial():
              return Text('Im on initial');
            case JobLoading():
              return Center(child: CircularProgressIndicator());
            case JobLoadedSuccesfull():
              return ListView.builder(
                itemCount: state.jobs.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(title: Text(state.jobs[index].title ?? ''));
                },
              );
            case JobLoadedWithError():
              return Center(child: Text('Loaded with Errors'));
          }
        },
        listener: (BuildContext context, JobState state) {},
      ),
    );
  }
}
