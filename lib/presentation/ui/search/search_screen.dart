import 'dart:convert';
import 'package:flutter/material.dart';
import '../results/results_screen.dart';
import '../../../domain/models/part_search_query.dart';
import '../../../data/services/vin_service.dart';
import '../../../core/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends ConsumerWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final historyAsync = ref.watch(searchHistoryProvider);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recherche de pièces',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: TextField(
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        hintText: 'VIN, Code OEM ou texte libre...',
                        border: InputBorder.none,
                        icon: Icon(Icons.search, color: Colors.grey),
                        contentPadding: EdgeInsets.symmetric(vertical: 14),
                      ),
                      onSubmitted: (value) =>
                          _handleSearch(context, ref, value),
                    ),
                  ),
                  const SizedBox(height: 16),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        _buildFilterChip(context, 'Toutes', Icons.build, true),
                        _buildFilterChip(
                          context,
                          'Freinage',
                          Icons.stop_circle_outlined,
                          false,
                        ),
                        _buildFilterChip(
                          context,
                          'Moteur',
                          Icons.settings,
                          false,
                        ),
                        _buildFilterChip(
                          context,
                          'Suspension',
                          Icons.handyman,
                          false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            if (historyAsync.hasValue && historyAsync.value!.isNotEmpty) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.history, size: 20, color: Colors.grey),
                    const SizedBox(width: 8),
                    Text(
                      'Recherches récentes',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => _clearHistory(ref),
                      child: const Text('Effacer'),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: historyAsync.value!.length,
                  itemBuilder: (context, index) {
                    final query = historyAsync.value![index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ActionChip(
                        label: Text(
                          query,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        onPressed: () => _handleSearch(context, ref, query),
                        backgroundColor: Theme.of(context).primaryColor,
                        side: BorderSide.none,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16),
              const Divider(height: 1),
            ],
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.filter_list, size: 20),
                      SizedBox(width: 8),
                      Text('Filtres'),
                    ],
                  ),
                  Text(
                    '3 résultats',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildResultCard(
                    context,
                    'Plaquettes de frein avant',
                    'Bosch • BP1234',
                    'Compatible: VW Golf VI, Audi A3',
                    '45.99 €',
                    true,
                    '24-48h',
                  ),
                  _buildResultCard(
                    context,
                    'Disque de frein ventilé',
                    'Brembo • BR5678',
                    'Compatible: VW Golf VI',
                    '89.99 €',
                    true,
                    '24-48h',
                  ),
                  _buildResultCard(
                    context,
                    'Kit plaquettes + disques',
                    'Bosch • BK9012',
                    'Compatible: VW Golf VI, VII',
                    '125.99 €',
                    false,
                    '3-5 jours',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveToHistory(WidgetRef ref, String query) async {
    final storage = ref.read(secureStorageProvider);
    final history = await ref.read(searchHistoryProvider.future);

    final newHistory = [
      query,
      ...history.where((q) => q != query),
    ].take(5).toList();

    await storage.write(key: 'search_history', value: json.encode(newHistory));
    ref.invalidate(searchHistoryProvider);
  }

  Future<void> _clearHistory(WidgetRef ref) async {
    final storage = ref.read(secureStorageProvider);
    await storage.delete(key: 'search_history');
    ref.invalidate(searchHistoryProvider);
  }

  void _handleSearch(BuildContext context, WidgetRef ref, String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return;

    // Sauvegarder dans l'historique
    await _saveToHistory(ref, cleanQuery);

    if (!context.mounted) return;

    // Regex pour détecter les immatriculations (France)
    // SIV: AA-123-AA ou AA123AA
    final sivRegex = RegExp(r'^[A-Z]{2}-?\d{3}-?[A-Z]{2}$');
    // FNI: 1234 AB 56 ou 1234AB56
    final fniRegex = RegExp(r'^\d{1,4}\s?[A-Z]{2,3}\s?\d{2}$');

    if (sivRegex.hasMatch(cleanQuery.toUpperCase()) ||
        fniRegex.hasMatch(cleanQuery.toUpperCase())) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text(
            'La recherche par immatriculation n\'est pas autorisée. Veuillez utiliser le VIN.',
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    // Logique de redirection selon le type de saisie
    if (cleanQuery.length == 17 && !cleanQuery.contains(' ')) {
      // Afficher un indicateur de chargement
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final vehicle = await ref.read(vinDecoderProvider(cleanQuery).future);
        if (context.mounted) {
          Navigator.pop(context); // Fermer le loader
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsScreen(
                searchQuery: PartSearchQuery(
                  partName: 'Recherche par VIN',
                  oemNumber: cleanQuery,
                  confidence: 1.0,
                  manufacturer:
                      '${vehicle.make} ${vehicle.model} (${vehicle.year})',
                ),
              ),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erreur décodage VIN: $e')));
        }
      }
    } else if (cleanQuery.length >= 4 && cleanQuery.contains(' ')) {
      // Si la requête semble être du texte naturel (>= 4 car. et contient un espace)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      try {
        final gemini = ref.read(geminiServiceProvider);
        final analyzedQuery = await gemini.analyzeText(cleanQuery);

        if (context.mounted) {
          Navigator.pop(context); // Fermer le loader
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsScreen(searchQuery: analyzedQuery),
            ),
          );
        }
      } catch (e) {
        if (context.mounted) {
          Navigator.pop(context);
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Erreur analyse Gemini: $e')));
        }
      }
    } else {
      // Code OEM
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              searchQuery: PartSearchQuery(
                partName: 'Pièce identifiée par OEM',
                oemNumber: cleanQuery,
                confidence: 1.0,
              ),
            ),
          ),
        );
      }
    }
  }

  Widget _buildFilterChip(
    BuildContext context,
    String label,
    IconData icon,
    bool isSelected,
  ) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? Colors.white : Colors.black87,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ],
        ),
        selected: isSelected,
        onSelected: (bool selected) {},
        backgroundColor: Colors.grey.shade100,
        selectedColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        showCheckmark: false,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        side: BorderSide.none,
      ),
    );
  }

  Widget _buildResultCard(
    BuildContext context,
    String title,
    String subtitle,
    String compatibility,
    String price,
    bool inStock,
    String deliveryTime,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ResultsScreen(
              searchQuery: PartSearchQuery(
                partName: title,
                oemNumber: '123456', // Mock OEM for testing
                manufacturer: subtitle.split(' • ').first,
                confidence: 0.98,
              ),
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.image, color: Colors.white, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: inStock
                                  ? Colors.green.shade50
                                  : Colors.orange.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              inStock ? 'En stock' : 'Sur commande',
                              style: TextStyle(
                                color: inStock
                                    ? Colors.green.withValues(alpha: 0.5)
                                    : Colors.orange.withValues(alpha: 0.5),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        compatibility,
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.local_shipping_outlined,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          deliveryTime,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 12,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
