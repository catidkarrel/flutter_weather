import 'package:flutter/services.dart';

const MethodChannel methodChannel = MethodChannel('sample_channel');

Future<int?> getUnreadCount() async {
  try {
    final int? result = await methodChannel.invokeMethod('getUnreadCount');
    return result;
  } on Exception catch(e) {
    print(e);
  }
  return null;

}

Future<String?> getDataFromNative() async {
  try {
    final String? result = await methodChannel.invokeMethod('getDataFromNative');
    return result;
  } on Exception catch(e) {
    print(e);
  }
  return null;
}