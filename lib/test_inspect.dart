// import 'dart:mirrors';
// import 'package:genui/genui.dart';

// void main() {
//   final lib = reflectNamespace(Symbol('')); // Get root
//   final genuiLib = currentMirrorSystem().libraries.values.firstWhere((l) => l.uri.toString().contains('genui'));
//   print('================= All Classes in genui =================');
//   genuiLib.declarations.forEach((key, value) {
//     if (value is ClassMirror) {
//       final name = MirrorSystem.getName(value.simpleName);
//       if (name.contains('Call') || name.contains('Message') || name.contains('A2')) {
//         print('  Class: $name, isAbstract: ${value.isAbstract}');
//         value.declarations.forEach((k, val) {
//           if (val is MethodMirror && val.isConstructor) {
//             print('    Constructor: ${MirrorSystem.getName(val.simpleName)}, parameters: ${val.parameters.map((p) => '${MirrorSystem.getName(p.type.simpleName)} ${MirrorSystem.getName(p.simpleName)}').toList()}');
//           }
//         });
//       }
//     }
//   });
// }
