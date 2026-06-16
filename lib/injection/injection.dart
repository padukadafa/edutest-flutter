import 'package:get_it/get_it.dart';
import 'injection_vark.dart';
import '../features/discuss/injection_discuss.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await initVark();
  await initDiscuss();
}
