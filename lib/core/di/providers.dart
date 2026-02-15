import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dropzone_app/core/config/env.dart';

final envProvider = Provider<Env>((ref) => devEnv);
