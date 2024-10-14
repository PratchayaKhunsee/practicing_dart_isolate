import 'dart:isolate';

/// The main function that be used for running as another isolate in another main function with [Isolate.spawnUri].
void main(List<String> args, SendPort message) async {
  for(int i = 0; i < 26; i++){
    await Future.delayed(const Duration(milliseconds: 50));
    message.send(97 + i);
  }
}