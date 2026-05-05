import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final connectivityProvider = StreamProvider<List<ConnectivityResult>>((ref) {
  return Connectivity().onConnectivityChanged;
});

final connectivityHintProvider = Provider<bool>((ref) {
  final result = ref.watch(connectivityProvider).asData?.value;
  if (result == null) return true;
  return result.any((r) => r != ConnectivityResult.none);
});

class NetworkReachabilityState {
  const NetworkReachabilityState({
    this.lastReachableAt,
    this.lastConnectionFailureAt,
  });

  final DateTime? lastReachableAt;
  final DateTime? lastConnectionFailureAt;

  NetworkReachabilityState copyWith({
    DateTime? lastReachableAt,
    DateTime? lastConnectionFailureAt,
  }) {
    return NetworkReachabilityState(
      lastReachableAt: lastReachableAt ?? this.lastReachableAt,
      lastConnectionFailureAt:
          lastConnectionFailureAt ?? this.lastConnectionFailureAt,
    );
  }
}

class NetworkReachabilityNotifier
    extends Notifier<NetworkReachabilityState> {
  @override
  NetworkReachabilityState build() => const NetworkReachabilityState();

  void markReachable() {
    state = state.copyWith(lastReachableAt: DateTime.now());
  }

  void markConnectionFailure() {
    state = state.copyWith(lastConnectionFailureAt: DateTime.now());
  }
}

final networkReachabilityProvider =
    NotifierProvider<
      NetworkReachabilityNotifier,
      NetworkReachabilityState
    >(NetworkReachabilityNotifier.new);

final isOnlineProvider = Provider<bool>((ref) {
  final connectivityHint = ref.watch(connectivityHintProvider);
  final reachability = ref.watch(networkReachabilityProvider);
  final lastReachableAt = reachability.lastReachableAt;
  final lastConnectionFailureAt = reachability.lastConnectionFailureAt;

  if (lastReachableAt != null &&
      (lastConnectionFailureAt == null ||
          lastReachableAt.isAfter(lastConnectionFailureAt))) {
    return true;
  }

  return connectivityHint;
});
