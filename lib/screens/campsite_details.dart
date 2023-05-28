import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'review_page.dart';

class CampsiteDetails extends StatefulWidget {
  final String campsiteId;
  const CampsiteDetails({super.key, required this.campsiteId});

  @override
  State<CampsiteDetails> createState() => _CampsiteDetailsState();
}

class _CampsiteDetailsState extends State<CampsiteDetails> {
  final List<ExpansionPanelItem> _expansionPanelItems = [
    ExpansionPanelItem(
      question: 'Are there any walk-in sites?',
      answer: 'Yes, there are walk-in sites provided',
      isExpanded: false,
    ),
    ExpansionPanelItem(
      question: 'Question 2',
      answer: 'Answer 2',
      isExpanded: false,
    ),
    ExpansionPanelItem(
      question: 'Question 3',
      answer: 'Answer 3',
      isExpanded: false,
    ),
  ];

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
          tooltip: 'Back menu',
          onPressed: null,
        ),
        title: const Text('[CampsiteDetailss Name]'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 300.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  shape: BoxShape.rectangle,
                  image: const DecorationImage(
                    image: AssetImage('assets/images/campdetails.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '4.0',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5.0),
                  const Text(
                    'Rating',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 10.0),
                  Row(
                    children: [
                      RatingBar.builder(
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemSize: 24.0,
                        itemPadding: EdgeInsets.zero,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {},
                      ),
                      const Spacer(),
                      const Text(
                        '1 Review(s)',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 5.0),
                  ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const ReviewPage()),
                        );
                      },
                      icon: const Icon(Icons.star),
                      label: const Text("Add a Review"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0XFF3F3D56), // Set the background color of the button
                      ),
                    ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Descriptions',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'A public or private park area set aside for camping, often equipped with water, toilets, cooking grills, etc.',
                    style: TextStyle(fontSize: 14),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'FAQ',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10.0),
                  ExpansionPanelList(
                    elevation: 0,
                    expandedHeaderPadding: EdgeInsets.zero,
                    expansionCallback: (index, isExpanded) {
                      setState(() {
                        _expansionPanelItems[index].isExpanded = !isExpanded;
                      });
                    },
                    children: _expansionPanelItems.map<ExpansionPanel>((item) {
                      return ExpansionPanel(
                        headerBuilder: (context, isExpanded) {
                          return ListTile(
                            title: Text(
                              item.question,
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          );
                        },
                        body: Padding(
                          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 16.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              item.answer,
                              textAlign: TextAlign.start,
                            ),
                          ),
                        ),
                        isExpanded: item.isExpanded,
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    '1 Review(s) for [CampsiteDetailss Name]',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5.0),
                  const Divider(
                    color: Colors.black,
                  ),
                  const SizedBox(height: 5.0),
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 24.0,
                        backgroundImage: AssetImage('assets/images/profile_image.jpg'),
                      ),
                      const SizedBox(width: 10.0),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'John Doe',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          RatingBar.builder(
                            initialRating: 3,
                            minRating: 1,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 24.0,
                            itemPadding: EdgeInsets.zero,
                            itemBuilder: (context, _) => const Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            onRatingUpdate: (rating) {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 40.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align buttons at the opposite ends
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Add your button click logic here
                          },
                          icon: const Icon(Icons.star),
                          label: const Text("Set As Favourite"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF3F3D56), // Set the background color of the button
                          ),
                        ),
                      ),
                      const SizedBox(width: 10.0),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            // Add your button click logic here
                          },
                          icon: const Icon(Icons.add),
                          label: const Text("Book"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0XFF3F3D56), // Set the background color of the button
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ExpansionPanelItem {
  final String question;
  final String answer;
  bool isExpanded;

  ExpansionPanelItem({
    required this.question,
    required this.answer,
    this.isExpanded = false,
  });
}
