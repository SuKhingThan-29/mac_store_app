import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketmate_app/provider/home_provider.dart';

import '../data/provider/cart_provider.dart';
import '../data/provider/nav_provider.dart';
import 'nav_screen/account_screen.dart';
import 'nav_screen/cart_screen.dart';
import 'nav_screen/category_screen.dart';
import 'nav_screen/favorite_screen.dart';
import 'nav_screen/home_screen.dart';
import 'nav_screen/store_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  static const _pages = [
    HomeScreen(),
    CategoryScreen(),
    StoreScreen(),
    CartScreen(),
    AccountScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final index = ref.watch(navProvider).index;

    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: index,
        children: _pages,
      ),
      bottomNavigationBar: const _ModernBottomBar(),
      floatingActionButton: const _CartFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );

  }
}
class _ModernBottomBar extends ConsumerWidget {
  const _ModernBottomBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(navProvider);

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              blurRadius: 25,
              color: Colors.black.withOpacity(0.08),
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: _AnimatedNavItem(
                index: 0,
                icon: Icons.home_outlined,
                label: "Home",
              ),
            ),
            Expanded(
              child: _AnimatedNavItem(
                index: 1,
                icon: Icons.category_outlined,
                label: "Category",
              ),
            ),

            const SizedBox(width: 55),

            Expanded(
              child: _AnimatedNavItem(
                index: 2,
                icon: Icons.storefront_outlined,
                label: "Store",
              ),
            ),
            Expanded(
              child: _AnimatedNavItem(
                index: 4,
                icon: Icons.person_outline,
                label: "Account",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _AnimatedNavItem extends ConsumerStatefulWidget {
  final int index;
  final IconData icon;
  final String label;

  const _AnimatedNavItem({
    required this.index,
    required this.icon,
    required this.label,
  });

  @override
  ConsumerState<_AnimatedNavItem> createState() => _AnimatedNavItemState();
}

class _AnimatedNavItemState extends ConsumerState<_AnimatedNavItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> scaleAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    scaleAnim = Tween<double>(begin: 1.0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _AnimatedNavItem oldWidget) {
    super.didUpdateWidget(oldWidget);

    final navState = ref.read(navProvider);

    if (navState.isAnimating && navState.index == widget.index) {
      _controller.forward().then((_) => _controller.reverse());
    }
  }

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(navProvider);
    final isSelected = navState.index == widget.index;

    return GestureDetector(
      onTap: () {
        ref.read(navProvider.notifier).changeTab(widget.index);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔥 top indicator
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 3,
            width: isSelected ? 20 : 0,
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),

          // 🔥 icon animation
          ScaleTransition(
            scale: scaleAnim,
            child: Icon(
              widget.icon,
              size: 24,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
          ),

          const SizedBox(height: 4),

          // 🔥 text animation
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 200),
            style: TextStyle(
              fontSize: isSelected ? 11 : 10,
              fontWeight:
              isSelected ? FontWeight.w600 : FontWeight.normal,
              color: isSelected ? Colors.blue : Colors.grey,
            ),
            child: Text(widget.label),
          ),
        ],
      ),
    );
  }
}
class _CartFAB extends ConsumerStatefulWidget {
  const _CartFAB();

  @override
  ConsumerState<_CartFAB> createState() => _CartFABState();
}

class _CartFABState extends ConsumerState<_CartFAB>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = ref.watch(cartProvider).count;

    return GestureDetector(
      onTap: () {
        _controller.forward().then((_) => _controller.reverse());
        ref.read(navProvider.notifier).changeTab(3);
      },
      child: ScaleTransition(
        scale: Tween(begin: 1.0, end: 1.1).animate(
          CurvedAnimation(parent: _controller, curve: Curves.easeOutBack),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            FloatingActionButton(
              onPressed: () {
                ref.read(navProvider.notifier).changeTab(3);
              },
              backgroundColor: Colors.blueAccent,
              child: const Icon(Icons.shopping_cart),
            ),

            if (cartCount > 0)
              Positioned(
                right: -2,
                top: -2,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(5),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    cartCount.toString(),
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}