import 'package:flutter/material.dart';
import '../../../domain/models/part_search_query.dart';

class ResultsScreen extends StatelessWidget {
  final PartSearchQuery searchQuery;

  const ResultsScreen({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Résultat Identification'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Confidence Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      'Identification IA',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(searchQuery.confidence * 100).toStringAsFixed(1)}% de confiance',
                      style: TextStyle(
                        color: searchQuery.confidence > 0.8 ? Colors.green : Colors.orange,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Main Info
            Text(
              'Pièce détectée',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Theme.of(context).primaryColor.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    searchQuery.partName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  if (searchQuery.category != null) ...[
                    const SizedBox(height: 8),
                    Chip(
                      label: Text(searchQuery.category!),
                      backgroundColor: Colors.white,
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Technical Details
            Text(
              'Détails techniques',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    _buildDetailRow('Fabricant', searchQuery.manufacturer),
                    const Divider(),
                    _buildDetailRow('Référence OEM', searchQuery.oemNumber),
                    const Divider(),
                    _buildDetailRow('Véhicule', searchQuery.carMake),
                    const Divider(),
                    _buildDetailRow('Modèle', searchQuery.carModel),
                    const Divider(),
                    _buildDetailRow('Année', searchQuery.year?.toString()),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(
            value ?? 'Non détecté',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: value != null ? Colors.black : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
