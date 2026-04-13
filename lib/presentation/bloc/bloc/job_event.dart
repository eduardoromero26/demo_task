part of 'job_bloc.dart';

sealed class JobEvent {}

// events : load
class LoadJobs extends JobEvent {}

class FetchMoreJobs extends JobEvent {}
