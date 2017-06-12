import 'dart:async';

import 'dart:ui';
import 'package:flutter/services.dart';

typedef void AvailabilityHandler(bool result);
typedef void RecognitionResultHandler(String text);

/// the channel to control the speech recognition
class SpeechRecognition {
  final MethodChannel _channel = const MethodChannel('speech_recognition');

  static final SpeechRecognition _speech = new SpeechRecognition._internal();

  factory SpeechRecognition() =>_speech;

  SpeechRecognition._internal(){
    _channel.setMethodCallHandler(_platformCallHandler);
  }

  AvailabilityHandler availabilityHandler;

  RecognitionResultHandler recognitionResultHandler;

  VoidCallback recognitionStartedHandler;

  VoidCallback recognitionCompleteHandler;

  /// ask for speech  recognizer permission
  Future activate() {
    return _channel.invokeMethod("speech.activate");
  }

  /// start listening
  Future listen({String locale}) {
    return _channel.invokeMethod("speech.listen", locale);
  }

  Future cancel() {
    return _channel.invokeMethod("speech.cancel");
  }

  Future stop() {
    return _channel.invokeMethod("speech.stop");
  }

  Future _platformCallHandler(MethodCall call) async {
    print("_platformCallHandler call ${call.method} ${call.arguments}");
    switch (call.method) {
      case "speech.onSpeechAvailability":
        availabilityHandler(call.arguments);
        break;
      case "speech.onSpeech":
        recognitionResultHandler(call.arguments);
        break;
      case "speech.onRecognitionStarted":
        recognitionStartedHandler();
        break;
      case "speech.onRecognitionComplete":
        recognitionCompleteHandler();
        break;
      default:
        print('Unknowm method ${call.method} ');
    }
  }

  // define a method to handle availability / permission result
  void setAvailabilityHandler(AvailabilityHandler handler) {
    availabilityHandler = handler;
  }

  // define a method to handle recognition result
  void setRecognitionResultHandler(VoidCallback handler) {
    recognitionStartedHandler = handler;
  }

  // define a method to handle native call
  void setRecognitionStartedHandler(VoidCallback handler) {
    recognitionStartedHandler = handler;
  }

  // define a method to handle native call
  void setRecognitionCompleteHandler(VoidCallback handler) {
    recognitionCompleteHandler = handler;
  }
}
