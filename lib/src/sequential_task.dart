part of '../taskflow.dart';

/// A task that runs its children sequentially.
class SequentialTask implements Task {
  @override
  Object get key => _key ?? this;
  final Object? _key;

  final List<Task> tasks;

  SequentialTask(this.tasks, {Object? key}) : _key = key;

  SequentialTask.fromFunc(List<TaskFunc> tasks, {Object? key})
      : _key = key,
        tasks = tasks.map((t) => Task(t)).toList();

  @override
  Future<void> call(TaskFlowContext context) async {
    if (context.isCanceled) return;

    for (var task in tasks) {
      await task(context);
    }
  }
}
