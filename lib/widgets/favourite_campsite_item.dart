import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FavouriteCampsiteItem extends StatelessWidget {
  final String id;
  final String title;
  final String description;
  final String imagePath;
  final double starRating;
  const FavouriteCampsiteItem(
      {super.key,
      required this.id,
      required this.title,
      required this.description,
      required this.starRating,
      required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context
            .goNamed('favourite-campsite-details', params: {"campsiteId": id});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.grey[600]!,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SizedBox(
          height: 130.0, // Adjust the desired height of the ListTile
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(
                    8.0), // Add desired padding around the image
                width: 150.0, // Adjust the width of the image container
                child: Image.network(
                  imagePath,
                  fit: BoxFit.cover,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0), // Add desired padding
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(
                        8.0), // Set the same padding value for the text content
                    title: Text(
                      title,
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight:
                              FontWeight.bold // Replace with your desired color
                          ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 5.0),
                        Text(description),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow),
                            const SizedBox(
                                width:
                                    4.0), // Add spacing between the icon and the rating text
                            Text(
                              starRating.toStringAsFixed(1),
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight
                                      .w500 // Replace with your desired color
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
