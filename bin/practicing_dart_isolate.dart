import 'package:practicing_dart_isolate/practicing_dart_isolate.dart';

/// The main function for practicing dart isolate usage.
void main(List<String> arguments) async {
  isolateSingleHeavyCalculation();
  isolateSendCharCodes();
  isolateReadBunchOfCharCodes();
  for(int i = 1; i <= 20; i++){
    await Future.delayed(const Duration(milliseconds: 100));
    print(i);
  }
}
