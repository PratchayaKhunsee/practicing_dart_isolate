import 'dart:async';
import 'dart:io';
import 'dart:isolate';

/// Calculate the sum of sequence numbers starting at 1 to 100. Each increment has a delay before doing addition. 
Future<int> singleHeavyCalculation() async {
  int value = 0;
  for (int i = 1; i < 100; i++) {
    await Future.delayed(const Duration(milliseconds: 5));
    value += i;
  }
  return value;
}

/// The isolate function that being used with [Isolate.run].
/// 
/// - Just run a simple caculation with isolate [singleHeavyCalculation].
Future<void> isolateSingleHeavyCalculation() async {
  final result = await Isolate.run(singleHeavyCalculation);
  print(result);
}

/// Send the character codes from isolated via [SendPort]. Starting at "A" to "Z".
void sendCharCodes(SendPort sender) async {
  for (int i = 0; i < 26; i++) {
    await Future.delayed(const Duration(milliseconds: 100));
    sender.send(65 + i);
  }
}

/// The isolate function that being used with [Isolate.spawn].
/// 
/// - Reading each character codes being sent from [sendCharCodes].  
Future<void> isolateSendCharCodes() async {
  final receivePort = ReceivePort();
  final completer = Completer<void>();
  await Isolate.spawn(sendCharCodes, receivePort.sendPort);
  final listener = receivePort.listen((charCode) {
    print(String.fromCharCode(charCode));
    if (charCode >= 90) completer.complete();
  });

  await completer.future;
  listener.cancel();
}

/// The isolate function that being used with [Isolate.spawnUri].
/// 
/// - Reading each character codes being sent from isolate main function in `lib/isolates/spawn_uri.dart`.  
Future<void> isolateReadBunchOfCharCodes() async {
  final uri = Uri.base.replace(path: '${Directory.current.path}/lib/isolates/spawn_uri.dart');
  final receivePort = ReceivePort();
  final completer = Completer<void>();
  await Isolate.spawnUri(uri, [], receivePort.sendPort);
  final listener = receivePort.listen((charCode) {
    print(String.fromCharCode(charCode));
    if (charCode >= 122) completer.complete();
  });

  await completer.future;
  listener.cancel();
}
