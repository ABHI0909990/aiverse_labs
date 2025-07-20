import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../constant/font_family.dart';

class AIExpertCard extends StatelessWidget {
  final String name;
  final String expertise;
  final String rating;
  final String imageUrl;
  final bool proOnly;
  final String description;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onNavigateToChatSection;

  const AIExpertCard({
    Key? key,
    required this.name,
    required this.expertise,
    required this.rating,
    required this.imageUrl,
    required this.proOnly,
    required this.description,
    required this.isFavorite,
    required this.onFavoriteToggle,
    required this.onNavigateToChatSection,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 4,
      shadowColor: theme.shadowColor.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: InkWell(
        onTap: onNavigateToChatSection,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.cardColor,
                theme.cardColor.withOpacity(0.8),
              ],
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expert Image
                  Hero(
                    tag: 'expert-$name',
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary.withOpacity(0.2),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: _buildExpertImage(),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Expert Info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                name,
                                style: TextStyle(
                                  fontFamily: AppFonts.family2Bold,
                                  fontSize: 18.sp,
                                  color: theme.colorScheme.onSurface,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            if (proOnly)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 14,
                                      color: theme.colorScheme.primary,
                                    ),
                                    SizedBox(width: 4),
                                    Text(
                                      'PRO',
                                      style: TextStyle(
                                        fontFamily: AppFonts.family2SemiBold,
                                        fontSize: 12,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(
                          expertise,
                          style: TextStyle(
                            fontFamily: AppFonts.family2Medium,
                            fontSize: 14.sp,
                            color: theme.colorScheme.onSurface.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            SizedBox(width: 4),
                            Text(
                              rating,
                              style: TextStyle(
                                fontFamily: AppFonts.family2SemiBold,
                                fontSize: 14.sp,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Favorite Button
                  IconButton(
                    onPressed: onFavoriteToggle,
                    icon: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        return ScaleTransition(
                          scale: animation,
                          child: child,
                        );
                      },
                      child: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        key: ValueKey<bool>(isFavorite),
                        color: isFavorite
                            ? Colors.red
                            : theme.colorScheme.onSurface.withOpacity(0.5),
                      ),
                    ),
                    tooltip: isFavorite
                        ? 'Remove from favorites'
                        : 'Add to favorites',
                  ),
                ],
              ),
              SizedBox(height: 16),
              // Description
              Text(
                description,
                style: TextStyle(
                  fontFamily: AppFonts.family2Regular,
                  fontSize: 14.sp,
                  color: theme.colorScheme.onSurface.withOpacity(0.8),
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(height: 16),
              // Chat Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onNavigateToChatSection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.chat_bubble_outline, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Chat Now',
                        style: TextStyle(
                          fontFamily: AppFonts.family2SemiBold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExpertImage() {
    // Check if the image URL is a local asset
    if (imageUrl.startsWith('resources/assets/')) {
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: 30,
              color: Colors.grey[600],
            ),
          );
        },
      );
    } else {
      // Handle network images
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            color: Colors.grey[300],
            child: Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            color: Colors.grey[300],
            child: Icon(
              Icons.person,
              size: 30,
              color: Colors.grey[600],
            ),
          );
        },
      );
    }
  }
}
