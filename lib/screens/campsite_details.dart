import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/logic/blocs/campsite/campsite_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';
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
  bool? isFavourite = false;
  int count = 0;
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
            print(_campsite.name);
            print(_campsite.id);
            print(widget.campsiteId);
            print(_campsite.favourites);
            print(1);
            count = count + 1;
            if (count == 2) {
              print('x');
              isFavourite = _campsite.favourites!
                  .contains(context.read<SessionCubit>().state.id);
              print(isFavourite);
            }

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
                        const Text(
                          '5.0',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 5.0),
                        Row(
                          children: [
                            const Text(
                              'Rating',
                              style: TextStyle(fontSize: 16),
                            ),
                            const Spacer(),
                            BlocBuilder<CampsiteBloc, CampsiteState>(
                              builder: (context, state) {
                                if (state is CampsiteLoaded &&
                                    !state.isCampsiteOwner) {
                                  return IconButton(
                                    onPressed: () async {
                                      // print(state.campsite.favourites);
                                      // print(isFavourite);
                                      if (isFavourite!) {
                                        print('a');
                                        await FirebaseFirestore.instance
                                            .collectionGroup('campsites')
                                            .where('id',
                                                isEqualTo: _campsite.id)
                                            .get()
                                            .then((val) => val.docs.forEach(
                                                (doc) => doc.reference.update({
                                                      'favourites': FieldValue
                                                          .arrayRemove([
                                                        context
                                                            .read<
                                                                SessionCubit>()
                                                            .state
                                                            .id
                                                      ])
                                                    })));

                                        setState(() {
                                          print('a');
                                          isFavourite = !isFavourite!;
                                        });
                                        print('aa');
                                      } else {
                                        print('b');
                                        await FirebaseFirestore.instance
                                            .collectionGroup('campsites')
                                            .where('id',
                                                isEqualTo: _campsite.id)
                                            .get()
                                            .then((val) => val.docs.forEach(
                                                (doc) => doc.reference.update({
                                                      'favourites': FieldValue
                                                          .arrayUnion([
                                                        context
                                                            .read<
                                                                SessionCubit>()
                                                            .state
                                                            .id
                                                      ])
                                                    })));
                                        setState(() {
                                          print('b');
                                          isFavourite = !isFavourite!;
                                        });
                                        print('bb');
                                      }
                                    },
                                    icon: Icon(isFavourite!
                                        ? CupertinoIcons.heart_fill
                                        : CupertinoIcons.heart),
                                    color: Colors.red,
                                  );
                                }
                                return Container();
                              },
                            ),
                          ],
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
                              MaterialPageRoute(
                                  builder: (context) => const ReviewPage()),
                            );
                          },
                          icon: const Icon(Icons.star),
                          label: const Text("Add a Review"),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context)
                                .primaryColor, // Set the background color of the button
                          ),
                        ),
                        const SizedBox(height: 20.0),
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
                        Text(
                          '1 Review(s) for ${_campsite.name}',
                          style: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
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
                              backgroundImage:
                                  AssetImage('assets/images/profile_image.jpg'),
                            ),
                            const SizedBox(width: 10.0),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'John Doe',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
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
