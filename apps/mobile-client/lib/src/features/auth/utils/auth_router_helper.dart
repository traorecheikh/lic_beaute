import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../router/app_router.dart';
import '../providers/auth_provider.dart';

Future<void> navigateAfterAuth(BuildContext context, WidgetRef ref) async {
  final user = await ref.read(currentUserProvider.future);
  if (!context.mounted) return;
  final needsBootstrap = (user?.fullName ?? '').trim().isEmpty;
  context.go(needsBootstrap ? AppRoutes.profileBootstrap : AppRoutes.home);
}
