import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:globox/models/enums/loading_type.dart';

final globalLoadingProvider = StateProvider<LoadingType>((ref) {
  return LoadingType.none;
});
