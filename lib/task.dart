part of 'taskflow.dart';

typedef TaskFunc = Future<TaskResult> Function(TaskFlowContext);

enum TaskState {
  ok,
  skipped,
}

class TaskResult {
  TaskResult();
  TaskResult.skipped();
  TaskResult.canceled();
}

/// A derivable and composable unit in taskflow.
abstract class Task {
  /// Identifier of task in task flow.
  ///
  /// If a task has no key specified, itself will be use as its key. None of
  /// tasks can have same key in a single flow.
  Object get key => this;

  factory Task(TaskFunc task, {Object? key}) = _Task;

  /// Execute current task.
  Future<TaskResult> call(TaskFlowContext context);
}

/// A simple task that wraps a [TaskFunc].
class _Task implements Task {
  @override
  Object get key => _key ?? this;
  final Object? _key;

  final TaskFunc _task;

  _Task(this._task, {Object? key}) : _key = key;

  @override
  Future<TaskResult> call(TaskFlowContext context) async {
    if (context.isCanceled) return TaskResult.canceled();

    var future = _task(context);
    context.markAsRunning(this, future);
    var result = await future;
    context.markAsCompleted(this, result);
    return result;
  }
}
