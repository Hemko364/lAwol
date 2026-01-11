import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/providers/providers.dart';
import 'home/home_screen.dart';
import 'search/search_screen.dart';
import 'scanner/scanner_screen.dart';
import 'garage/garage_screen.dart';
import 'profile/profile_screen.dart';

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  final List<Widget> _screens = const [
    HomeScreen(),
    SearchScreen(),
    ScannerScreen(),
    GarageScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentIndex = ref.watch(navigationProvider);

    return Scaffold(
      body: IndexedStack(index: currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: (index) => ref.read(navigationProvider.notifier).state = index,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: Theme.of(context).primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Accueil',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.search),
              activeIcon: Icon(Icons.search_rounded),
              label: 'Recherche',
            ),
            BottomNavigationBarItem(
              icon: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Theme.of(context).primaryColor,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.camera_alt_outlined,
                  color: Colors.white,
                ),
              ),
              label: '',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.directions_car_outlined),
              activeIcon: Icon(Icons.directions_car),
              label: 'Garage',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'Profil',
            ),
          ],
        ),
      ),
    );
  }
}
