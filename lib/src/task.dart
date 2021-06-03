part of '../taskflow.dart';

typedef TaskFunc = Future<void> Function(TaskFlowContext);

/// A derivable and composable unit in taskflow.
abstract class Task {
  /// Identifier of task in task flow.
  ///
  /// If a task has no key specified, itself will be use as its key. None of
  /// tasks can have same key in a single flow.
  Object get key => this;

  /// Create a simple task.
  factory Task(TaskFunc task, {Object? key}) = _Task;

  /// Create a [ConditionalTask].
  factory Task.when(
    ConditionFunc condition,
    TaskFunc task, {
    Object? key,
  }) = ConditionalTask;

  /// Execute current task.
  Future<void> call(TaskFlowContext context);
}

/// A simple task that wraps a [TaskFunc].
class _Task implements Task {
  @override
  Object get key => _key ?? this;
  final Object? _key;

  final TaskFunc _task;

  _Task(this._task, {Object? key}) : _key = key;

  @override
  Future<void> call(TaskFlowContext context) async {
    if (context.isCanceled) return;

    final future = _task(context);
    context.markAsRunning(this, future);
    await future;
    context.markAsFinished(this);
  }
}
