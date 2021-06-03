import 'package:taskflow/taskflow.dart';

void main() {
  // Define task flow.
  var task = ParallelTask([
    Task((context) async {
      print('I am a simple task.');
    }),
    SequentialTask([
      Task((context) async {
        await Future.delayed(Duration(milliseconds: 30));
        print('I am sequential task 1.');
      }),
      Task((context) async {
        await Future.delayed(Duration(milliseconds: 20));
        print('I am sequential task 2.');
      }),
    ]),
    ParallelTask([
      Task((context) async {
        await Future.delayed(Duration(milliseconds: 30));
        print('I am parallel task 1.');
      }),
      Task((context) async {
        await Future.delayed(Duration(milliseconds: 20));
        print('I am parallel task 2.');
      }),
      Task((context) async {
        await Future.delayed(Duration(milliseconds: 10));
        print('I am parallel task 3.');
      }),
    ]),
    ConditionalTask(
      () async => DateTime.now().isAfter(DateTime(2077)),
      (context) async {
        print('Skipped task.');
      },
    ),
    ConditionalTask(
      () async => DateTime.now().isAfter(DateTime(2000)),
      (context) async {
        print('Now is 21st century.');
      },
    ),
  ]);

  // Create a context.
  var context = TaskFlowContext();

  // Run tasks.
  task(context);
}
