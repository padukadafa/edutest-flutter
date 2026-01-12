import 'package:get_it/get_it.dart';
import 'injection_vark.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize VARK feature
  await initVark();

  // Initialize other features...
}
