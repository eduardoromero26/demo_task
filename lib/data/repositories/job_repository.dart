import 'package:demo_task/domain/model/job_model.dart';

abstract class JobRepository {
  Future<List<JobModel>> fetchJobs({required int page});
}

class FakeJobRepository implements JobRepository {
  @override
  Future<List<JobModel>> fetchJobs({required int page}) async {
    await Future.delayed(const Duration(seconds: 1));

    if (page == 3) {
      throw Exception('Network error');
    }

    return List.generate(
      10,
      (index) => JobModel(id: '${page}_$index', title: 'Job ${page}_$index'),
    );
  }
}
