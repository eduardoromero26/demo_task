part of 'job_bloc.dart';

sealed class JobState {}

final class JobInitial extends JobState {}

final class JobLoading extends JobState {}

final class JobLoadedSuccesfull extends JobState {
  final List<JobModel> jobs;

  JobLoadedSuccesfull({required this.jobs});
}

final class JobLoadedWithError extends JobState {}
