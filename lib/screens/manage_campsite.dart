import 'package:flutter/material.dart';

class ManageCamspite extends StatelessWidget {
  const ManageCamspite({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: 'Search for campsites',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0,
                          horizontal: 16.0,
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: () {
                            // Perform search action
                          },
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      // Perform add action
                    },
                  ),
                ],
              ),
            ),
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
        height: 130.0,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8.0),
              width: 150.0,
              child: Image.asset(
                'assets/images/camp.jpg',
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(description),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.yellow),
                            const SizedBox(width: 4.0),
                            Text(
                              starRating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          // Perform edit action
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
