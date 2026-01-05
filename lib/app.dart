import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'routes/app_router.dart';

class CampusXchangeApp extends ConsumerWidget {
  const CampusXchangeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(goRouterProvider);
    return MaterialApp.router(
      title: 'CampusXchange',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
