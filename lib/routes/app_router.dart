import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/presentation/screens/login_screen.dart';
import '../features/chat/presentation/screens/chat_list_screen.dart';
import '../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../features/marketplace/domain/entities/product_model.dart';
import '../features/marketplace/presentation/screens/marketplace_screen.dart';
import '../features/marketplace/presentation/screens/product_detail_screen.dart';
import '../features/merchant/presentation/screens/merchant_panel_screen.dart';
import '../features/orders/presentation/screens/orders_screen.dart';
import '../features/profile/presentation/screens/profile_screen.dart';

final goRouterProvider = Provider<GoRouter>((ProviderRef<GoRouter> ref) {
  return GoRouter(
    initialLocation: '/auth',
    routes: <GoRoute>[
      GoRoute(
        path: '/auth',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        builder: (BuildContext context, GoRouterState state) =>
            const DashboardScreen(),
      ),
      GoRoute(
        path: '/marketplace',
        builder: (BuildContext context, GoRouterState state) =>
            const MarketplaceScreen(),
      ),
      GoRoute(
        path: '/product',
        builder: (BuildContext context, GoRouterState state) {
          final ProductModel product = state.extra as ProductModel;
          return ProductDetailScreen(product: product);
        },
      ),
      GoRoute(
        path: '/merchant',
        builder: (BuildContext context, GoRouterState state) =>
            const MerchantPanelScreen(),
      ),
      GoRoute(
        path: '/orders',
        builder: (BuildContext context, GoRouterState state) =>
            const OrdersScreen(),
      ),
      GoRoute(
        path: '/chat',
        builder: (BuildContext context, GoRouterState state) =>
            const ChatListScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (BuildContext context, GoRouterState state) =>
            const ProfileScreen(),
      ),
    ],
  );
});
