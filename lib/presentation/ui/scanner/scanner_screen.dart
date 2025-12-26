import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScannerScreen extends StatelessWidget {
  const ScannerScreen({super.key});

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
                  ), // Dashed border is hard in standard widget, using solid for now
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

  Future<void> _handleCameraScan(BuildContext context) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.camera);

      if (!context.mounted) return;

      if (image != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image capturée : ${image.path}'),
            backgroundColor: Colors.green,
          ),
        );
        // TODO: Implémenter la logique OCR ici
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Image sélectionnée : ${image.path}'),
            backgroundColor: Colors.green,
          ),
        );
        // TODO: Implémenter la logique OCR ici
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
