import 'package:flutter/material.dart';

class ViewFavouriteCampsite extends StatelessWidget {
  const ViewFavouriteCampsite({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0XFF3F3D56),
        leading: const IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            ),
          tooltip: 'Navigation menu',
          onPressed: null,
        ),
        title: const Text('[Favourite Page]'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  _buildCampsiteListView('Campsite 1', 'Skudai, Johor', 4),
                  _buildCampsiteListView('Campsite 2', 'Bangi, Selangor', 3),
                  _buildCampsiteListView('Campsite 3', 'Bukit Gajah, Melaka', 5),
                  _buildCampsiteListView('Campsite 4', 'Genting Highlands', 2),
                  _buildCampsiteListView('Campsite 5', 'Georgetown, Penang', 5),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCampsiteListView(String title, String description, double starRating) {
  return Container(
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
            padding: const EdgeInsets.all(8.0), // Add desired padding around the image
            width: 150.0, // Adjust the width of the image container
            child: Image.asset(
              'assets/images/camp.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Add desired padding
              child: ListTile(
                contentPadding: const EdgeInsets.all(8.0), // Set the same padding value for the text content
                title: Text(
                        title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold // Replace with your desired color
                          ),
                      ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height:5.0),
                    Text(description),
                    const SizedBox(height:5.0),
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.yellow),
                        const SizedBox(width: 4.0), // Add spacing between the icon and the rating text
                        Text(
                          starRating.toStringAsFixed(1),
                          style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w500 // Replace with your desired color
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
  );
}
}