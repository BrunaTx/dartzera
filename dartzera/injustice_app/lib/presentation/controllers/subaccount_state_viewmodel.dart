import 'package:signals_flutter/signals_flutter.dart';

import '../../domain/models/subaccount_entity.dart';

class SubAccountStateViewModel {
  final state = signal<List<SubAccount>>([]);
  final message = signal<String?>(null);

  void clearMessage() => message.value = null;
  void setMessage(String msg) => message.value = msg;

  void clear() {
    state.value = [];
    message.value = null;
  }
}
