import 'package:flutter/material.dart';

class AIExpertCard extends StatelessWidget {
  final String name;
  final String expertise;
  final String rating;
  final String imageUrl;
  final bool proOnly;
  final String description;
  final bool isFavorite;
  final Function()? onFavoriteToggle;
  final Function()? onNavigateToChatSection;

  AIExpertCard({
    required this.name,
    required this.expertise,
    required this.rating,
    required this.imageUrl,
    this.proOnly = false,
    this.description = '',
    this.isFavorite = false,
    this.onFavoriteToggle,
    required this.onNavigateToChatSection,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black87,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(imageUrl),
                    ),
                  ],
                ),
                SizedBox(width: 16),
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
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        expertise,
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          SizedBox(width: 4),
                          Text(rating, style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: Icon(
                    isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: isFavorite ? Colors.red : Colors.grey,
                  ),
                  onPressed: onFavoriteToggle,
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios, color: Colors.orange),
                  onPressed: onNavigateToChatSection,
                ),
              ],
            ),
          ),
          if (description.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Text(
                description,
                style: TextStyle(color: Colors.white70, fontSize: 12),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
        ],
      ),
    );
  }
}
