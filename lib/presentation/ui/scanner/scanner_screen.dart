import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../data/services/gemini_service.dart';
import '../../../domain/models/normalization_layer.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final _geminiService = GeminiService();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Scanner une pièce',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                'Identifiez instantanément vos pièces auto',
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const SizedBox(height: 32),

              if (_isLoading)
                const Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text("Analyse intelligente via Gemini Flash..."),
                    ],
                  ),
                )
              else ...[
                // Camera Button (Large Card)
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          Theme.of(context).primaryColor,
                          Theme.of(context).primaryColor.withValues(alpha: 0.8),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(
                            context,
                          ).primaryColor.withValues(alpha: 0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _handleCameraScan(context),
                        borderRadius: BorderRadius.circular(32),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 48,
                              ),
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Prendre une photo',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Touchez pour scanner',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.8),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text('ou', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 24),

                // Import Button
                OutlinedButton(
                  onPressed: () => _handleGalleryImport(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    side: BorderSide(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.upload_file,
                        color: Colors.grey.shade600,
                        size: 32,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Importer une photo',
                        style: TextStyle(
                          color: Colors.grey.shade800,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'depuis votre galerie',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 32),

              // Tips
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info_outline, color: Colors.blue.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Conseils pour un scan optimal',
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildTipItem('Nettoyez la pièce si possible'),
                    _buildTipItem('Éclairage suffisant recommandé'),
                    _buildTipItem('Photographiez l\'étiquette ou le code'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _processImage(BuildContext context, XFile image) async {
    setState(() => _isLoading = true);

    try {
      final bytes = await image.readAsBytes();
      final rawResult = await _geminiService.analyzeImage(bytes);
      final normalizedResult = NormalizationLayer.normalize(rawResult);

      if (!mounted) return;

      // Affichage du résultat (simulation de la navigation vers la recherche)
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (ctx) => Container(
          padding: const EdgeInsets.all(24),
          height: MediaQuery.of(context).size.height * 0.6,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Pièce Identifiée", style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text(normalizedResult.partName),
                subtitle: Text("Confiance: ${(normalizedResult.confidence * 100).toStringAsFixed(1)}%"),
              ),
              if (normalizedResult.oemNumber != null)
                ListTile(
                  leading: const Icon(Icons.qr_code),
                  title: Text("OEM: ${normalizedResult.oemNumber}"),
                ),
              if (normalizedResult.carMake != null)
                ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text("Compatible: ${normalizedResult.carMake} ${normalizedResult.carModel ?? ''}"),
                ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Recherche fournisseurs lancée... (Mock)")),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text("Rechercher cette pièce"),
              )
            ],
          ),
        ),
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur IA : $e'), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _handleCameraScan(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (!context.mounted) return;

      if (image != null) {
        await _processImage(context, image);
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _handleGalleryImport(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);

      if (!context.mounted) return;

      if (image != null) {
        await _processImage(context, image);
      }
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : $e'), backgroundColor: Colors.red),
      );
    }
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4, left: 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(text, style: TextStyle(color: Colors.blue.shade900)),
          ),
        ],
      ),
    );
  }
}
