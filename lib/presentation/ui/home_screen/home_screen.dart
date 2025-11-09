import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_bottom_nav.dart';
import '../../widgets/custom_search_bar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_card.dart';
import '../../../core/providers/auth_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<void> _logout() async {
    final auth = ref.read(firebaseAuthProvider);
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authStateProvider);
    final user = userAsync.maybeWhen(
      data: (user) => user,
      orElse: () => null,
    );

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Accueil',
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchBar(
              controller: _searchController,
              onChanged: (value) {
                // Logique de recherche
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Bienvenue, ${user?.email ?? 'Utilisateur'} !',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Vous êtes connecté à votre compte.'),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomCard(
                    child: const Text('Carte personnalisée 2'),
                  ),
                  const SizedBox(height: 20),
                  CustomButton(
                    text: 'Action',
                    onPressed: () {
                      // Action
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
