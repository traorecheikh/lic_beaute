import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/session/session_store.dart';

class SessionListenable extends ChangeNotifier {
  SessionListenable(this._ref) {
    _ref.listen<SessionState>(sessionProvider, (_, _) => notifyListeners());
  }
  final Ref _ref;
}
