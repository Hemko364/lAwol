import 'package:flutter/material.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {
        'name': 'Freinage',
        'icon': Icons.settings_input_component,
        'color': Colors.red,
      },
      {'name': 'Moteur', 'icon': Icons.settings_suggest, 'color': Colors.blue},
      {'name': 'Suspension', 'icon': Icons.swap_calls, 'color': Colors.orange},
      {'name': 'Électricité', 'icon': Icons.bolt, 'color': Colors.amber},
      {
        'name': 'Éclairage',
        'icon': Icons.lightbulb_outline,
        'color': Colors.yellow.shade700,
      },
      {
        'name': 'Filtration',
        'icon': Icons.filter_alt_outlined,
        'color': Colors.green,
      },
      {
        'name': 'Transmission',
        'icon': Icons.settings_input_hdmi,
        'color': Colors.purple,
      },
      {
        'name': 'Carrosserie',
        'icon': Icons.directions_car_filled,
        'color': Colors.blueGrey,
      },
      {'name': 'Échappement', 'icon': Icons.air, 'color': Colors.grey},
      {'name': 'Climatisation', 'icon': Icons.ac_unit, 'color': Colors.cyan},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catégories de pièces'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return _buildCategoryCard(
            context,
            category['name'] as String,
            category['icon'] as IconData,
            category['color'] as Color,
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    String name,
    IconData icon,
    Color color,
  ) {
    return InkWell(
      onTap: () {
        // Pour l'instant on affiche un message, plus tard on filtrera les résultats
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Filtrer par : $name')));
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: color.withValues(alpha: 0.1), width: 1),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(height: 12),
            Text(
              name,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
