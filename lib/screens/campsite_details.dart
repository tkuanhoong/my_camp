import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/logic/blocs/campsite/campsite_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';
import 'package:my_camp/screens/reviews/avg_rating&qty_review.dart';
import 'package:my_camp/screens/reviews/get_avg_rating_text.dart';
import 'package:my_camp/screens/reviews/qty_review_text.dart';
import 'package:my_camp/screens/reviews/reviews_widget.dart';
import '../data/models/reviews.dart';
import 'review_page.dart';
import 'package:my_camp/data/models/faq.dart';

class CampsiteDetails extends StatefulWidget {
  final String campsiteId;
  const CampsiteDetails({super.key, required this.campsiteId});

  @override
  State<CampsiteDetails> createState() => _CampsiteDetailsState();
}

class _CampsiteDetailsState extends State<CampsiteDetails> {
  late Campsite _campsite;
  @override
  initState() {
    context.read<CampsiteBloc>().add(SingleCampsiteRequested(
        campsiteId: widget.campsiteId,
        userId: context.read<SessionCubit>().state.id));
    super.initState();
  }

  List<ExpansionPanelItem> _expansionPanelItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).primaryColor,
          leading: const BackButton(),
          title: BlocBuilder<CampsiteBloc, CampsiteState>(
            builder: (context, state) {
              if (state is CampsiteLoaded) {
                return Text(state.campsite.name);
              } else {
                return const Text('Loading...');
              }
            },
          ),
          actions: [
            BlocBuilder<CampsiteBloc, CampsiteState>(
              builder: (context, state) {
                if (state is CampsiteLoaded && state.isCampsiteOwner) {
                  return IconButton(
                      onPressed: () {
                        context.goNamed('campsite-edit',
                            params: {"campsiteId": state.campsite.id});
                      },
                      icon: const Icon(Icons.edit));
                }
                return Container();
              },
            ),
          ]),
      body: BlocConsumer<CampsiteBloc, CampsiteState>(
        listener: (context, state) {
          if (state is CampsiteError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is CampsiteLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is CampsiteLoaded) {
            _campsite = state.campsite;

            _expansionPanelItems = [
              ...state.campsite.faq!
                  .asMap()
                  .entries
                  .map((entry) => ExpansionPanelItem(
                        faq: Faq.fromMap(entry.value),
                        isExpanded: _expansionPanelItems.isNotEmpty
                            ? _expansionPanelItems[entry.key].isExpanded
                            : false,
                      ))
                  .toList()
            ];

            return Padding(
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
                        image: DecorationImage(
                          image: NetworkImage(
                            state.campsite.imagePath,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // const SizedBox(height: 5.0),
                        // const Text(
                        //   'Rating',
                        //   style: TextStyle(fontSize: 16),
                        // ),
                        const SizedBox(height: 10.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            AverageRatingText(campsiteid: state.campsite.id),
                            const SizedBox(
                              width: 5.0,
                            ),
                            AverageRatingAndQtyReviews(
                                campsiteId: state.campsite.id),
                          ],
                        ),

                        const SizedBox(height: 5.0),
                        ElevatedButton.icon(
                          onPressed: () {
                            String campsiteid = state.campsite.id.toString();
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ReviewPage(campsiteId: campsiteid)),
                            );
                            // print(state.campsite.id);
                            // print(state.campsite.name);
                            // print(userId);
                          },
                          icon: const Icon(Icons.star),
                          label: const Text("Add a Review"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .primaryColor, // Set the background color of the button
                          ),
                        ),
                        Divider(),
                        const Text(
                          'Descriptions',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          _campsite.description,
                          style: TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 20.0),
                        const Text(
                          'FAQ',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 10.0),
                        ExpansionPanelList(
                          elevation: 0,
                          expandedHeaderPadding: EdgeInsets.zero,
                          expansionCallback: (index, isExpanded) {
                            setState(() {
                              _expansionPanelItems[index].isExpanded =
                                  !isExpanded;
                            });
                          },
                          children:
                              _expansionPanelItems.map<ExpansionPanel>((item) {
                            return ExpansionPanel(
                              headerBuilder: (context, isExpanded) {
                                return ListTile(
                                  title: Text(
                                    item.faq.question!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                );
                              },
                              body: Padding(
                                padding: const EdgeInsets.fromLTRB(
                                    16.0, 8.0, 16.0, 16.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    item.faq.answer!,
                                    textAlign: TextAlign.start,
                                  ),
                                ),
                              ),
                              isExpanded: item.isExpanded,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 20.0),
                        QtyReviewsText(
                            campsiteid: state.campsite.id, campsite: _campsite),
                        const SizedBox(height: 5.0),
                        const Divider(
                          color: Colors.black,
                        ),
                        const SizedBox(height: 5.0),
                        ReviewsWidget(campsiteId: widget.campsiteId),
                        const SizedBox(height: 40.0),
                        BlocBuilder<CampsiteBloc, CampsiteState>(
                          builder: (context, state) {
                            if (state is CampsiteLoaded &&
                                state.isCampsiteOwner) {
                              return SizedBox(
                                width: double.infinity,
                                height: 40.0,
                                child: ElevatedButton.icon(
                                    onPressed: () {
                                      context.goNamed('campsite-manage-product',
                                          params: {
                                            "campsiteId": state.campsite.id
                                          });
                                    },
                                    label: const Text("Manage Product"),
                                    icon:
                                        const Icon(Icons.inventory_2_outlined)),
                              );
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment
                                  .spaceBetween, // Align buttons at the opposite ends
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      // Add your button click logic here
                                    },
                                    icon: const Icon(Icons.star),
                                    label: const Text("Set As Favourite"),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context)
                                          .primaryColor, // Set the background color of the button
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
                                      backgroundColor: Theme.of(context)
                                          .primaryColor, // Set the background color of the button
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(
              child: Text("Something went wrong"),
            );
          }
        },
      ),
    );
  }
}

class ExpansionPanelItem {
  final Faq faq;
  bool isExpanded;

  ExpansionPanelItem({
    required this.faq,
    this.isExpanded = false,
  });
}
