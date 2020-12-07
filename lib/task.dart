part of 'taskflow.dart';

typedef TaskFunc = Future<TaskResult> Function(TaskFlowContext);

enum TaskState {
  ok,
  skipped,
  canceled,
}

class TaskResult<T> {
  final TaskState state;
  final T? result;

  TaskResult(this.result) : state = TaskState.ok;

  TaskResult.skipped()
      : state = TaskState.skipped,
        result = null;

  TaskResult.canceled()
      : state = TaskState.canceled,
        result = null;
}

/// A derivable and composable unit in taskflow.
abstract class Task {
  /// Identifier of task in task flow.
  ///
  /// If a task has no key specified, itself will be use as its key. None of
  /// tasks can have same key in a single flow.
  Object get key => this;

  factory Task(TaskFunc task, {Object? key}) = _Task;

  factory Task.when(Future<bool> Function() condition, TaskFunc task) =>
      ConditionalTask(condition, task);

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
