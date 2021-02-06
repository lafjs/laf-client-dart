import 'dart:mirrors';

typeof(dynamic obj) {
  return reflect(obj).type.reflectedType.toString();
}
