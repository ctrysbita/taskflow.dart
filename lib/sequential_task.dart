part of 'taskflow.dart';

/// A task that runs its children sequentially.
///
/// The result of [SequentialTask] is the result of last inner task executed.
class SequentialTask implements Task {
  @override
  Object get key => _key ?? this;
  final Object? _key;

  List<Task> tasks;

  SequentialTask(this.tasks, {Object? key}) : _key = key;

  SequentialTask.fromFunc(List<TaskFunc> tasks, {Object? key})
      : _key = key,
        tasks = tasks.map((t) => Task(t)).toList();

  @override
  Future<TaskResult> call(TaskFlowContext context) async {
    if (context.isCanceled) return TaskResult.canceled();

    late TaskResult result;
    for (var task in tasks) {
      result = await task(context);
    }
    return result;
  }
}
