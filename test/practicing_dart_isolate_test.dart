import 'dart:async';
import 'dart:io';
import 'dart:isolate';

import 'package:practicing_dart_isolate/practicing_dart_isolate.dart';
import 'package:test/test.dart';

void main() {
  group('Practicing Dart Isolate >', () {
    test('Isolate.run()', () async {
      expect(await Isolate.run(singleHeavyCalculation), equals(4950));
    });

    test('Isolate.spawn()', () async {
      String text = '';
      final receivePort = ReceivePort();
      final completer = Completer();
      final subscription = receivePort.listen(
        (message) {
          try {
            text = '$text${String.fromCharCode(message)}';
            if ((message as int) >= 90) completer.complete();
          } catch (error, stackTrace) {
            completer.completeError(error, stackTrace);
          }
        },
      );
      Isolate.spawn(sendCharCodes, receivePort.sendPort);
      await completer.future;
      subscription.cancel();
      expect(text, equals('ABCDEFGHIJKLMNOPQRSTUVWXYZ'));
    });

    test('Isolate.spawnUri()', () async {
      String text = '';
      final uri = Uri.base.replace(path: '${Directory.current.path}/lib/isolates/spawn_uri.dart');    
      final receivePort = ReceivePort();
      final completer = Completer();
      final subscription = receivePort.listen(
        (message) {
          try {
            text = '$text${String.fromCharCode(message)}';
            if ((message as int) >= 122) completer.complete();
          } catch (error, stackTrace) {
            completer.completeError(error, stackTrace);
          }
        },
      );
      Isolate.spawnUri(uri, [], receivePort.sendPort);
      await completer.future;
      subscription.cancel();
      expect(text, equals('abcdefghijklmnopqrstuvwxyz'));
    });
  });
}
