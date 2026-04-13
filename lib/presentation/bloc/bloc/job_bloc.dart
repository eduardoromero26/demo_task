import 'package:bloc/bloc.dart';
import 'package:demo_task/data/repositories/job_repository.dart';
import 'package:demo_task/domain/model/job_model.dart';

part 'job_event.dart';
part 'job_state.dart';

class JobBloc extends Bloc<JobEvent, JobState> {
  final FakeJobRepository jobRepository;
  JobBloc(this.jobRepository) : super(JobInitial()) {
    late List<JobModel> jobs;
    int page = 1;
    on<LoadJobs>((event, emit) async {
      emit(JobLoading());
      try {
        jobs = await jobRepository.fetchJobs(page: page);
        page++;
        emit(JobLoadedSuccesfull(jobs: jobs));
      } catch (e) {
        emit(JobLoadedWithError());
      }
    });
  }
}
