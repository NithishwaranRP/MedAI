import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

/// Plant card widget showing detailed plant information
class PlantCard extends StatelessWidget {
  final String plantName;
  final String uses;
  final String preparation;
  final String? imagePath;
  final String? scientificName;
  final String? benefits;
  final String? precautions;
  final String? duration;

  const PlantCard({
    Key? key,
    required this.plantName,
    required this.uses,
    required this.preparation,
    this.imagePath,
    this.scientificName,
    this.benefits,
    this.precautions,
    this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth > 600;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: isTablet ? 600 : double.infinity,
        ),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryGreen,
            width: 2,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: EdgeInsets.all(isTablet ? 24 : 20),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withOpacity(0.2),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.eco, // Keep eco icon in plant card as it's contextually appropriate
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          plantName,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 24 : 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (scientificName != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            scientificName!,
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: isTablet ? 14 : 12,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),

            // Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(isTablet ? 24 : 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Uses
                    _buildSection(
                      icon: Icons.medical_services,
                      title: 'Uses',
                      content: uses,
                      isTablet: isTablet,
                    ),
                    const SizedBox(height: 20),

                    // Benefits
                    if (benefits != null) ...[
                      _buildSection(
                        icon: Icons.favorite,
                        title: 'Benefits',
                        content: benefits!,
                        isTablet: isTablet,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Preparation
                    _buildSection(
                      icon: Icons.science,
                      title: 'Preparation Method',
                      content: preparation,
                      isTablet: isTablet,
                    ),
                    const SizedBox(height: 20),

                    // Precautions
                    if (precautions != null) ...[
                      _buildSection(
                        icon: Icons.warning,
                        title: 'Precautions',
                        content: precautions!,
                        isTablet: isTablet,
                        color: Colors.orange,
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Duration
                    if (duration != null) ...[
                      _buildSection(
                        icon: Icons.access_time,
                        title: 'Duration',
                        content: duration!,
                        isTablet: isTablet,
                      ),
                    ],
                  ],
                ),
              ),
            ),

            // Footer
            Container(
              padding: EdgeInsets.all(isTablet ? 20 : 16),
              decoration: BoxDecoration(
                color: AppColors.scaffoldBackground,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(18),
                  bottomRight: Radius.circular(18),
                ),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: EdgeInsets.symmetric(
                      vertical: isTablet ? 16 : 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 18 : 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required IconData icon,
    required String title,
    required String content,
    required bool isTablet,
    Color? color,
  }) {
    final sectionColor = color ?? AppColors.primaryGreen;

    return Container(
      padding: EdgeInsets.all(isTablet ? 16 : 14),
      decoration: BoxDecoration(
        color: sectionColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: sectionColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: sectionColor, size: isTablet ? 24 : 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: sectionColor,
                  fontSize: isTablet ? 18 : 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 15 : 14,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

