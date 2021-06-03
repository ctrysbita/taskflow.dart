part of '../taskflow.dart';

/// A task that runs its children parallelly.
class ParallelTask implements Task {
  @override
  Object get key => _key ?? this;
  final Object? _key;

  final List<Task> tasks;

  ParallelTask(this.tasks, {Object? key}) : _key = key;

  ParallelTask.fromFunc(List<TaskFunc> tasks, {Object? key})
      : _key = key,
        tasks = tasks.map((t) => Task(t)).toList();

  @override
  Future<void> call(TaskFlowContext context) async {
    if (context.isCanceled) return;

    await Future.wait(tasks.map((t) => t(context)));
  }
}
