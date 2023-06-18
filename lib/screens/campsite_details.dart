import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/data/models/campsite_event_model.dart';
import 'package:my_camp/logic/blocs/booking/booking_bloc.dart';
import 'package:my_camp/logic/blocs/campsite/campsite_bloc.dart';
import 'package:my_camp/logic/blocs/campsite_event/campsite_event_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';
import 'package:my_camp/screens/reviews/avg_rating&qty_review.dart';
import 'package:my_camp/screens/reviews/get_avg_rating_text.dart';
import 'package:my_camp/screens/reviews/qty_review_text.dart';
import 'package:my_camp/screens/reviews/reviews_widget.dart';
import 'review_page.dart';
import 'package:my_camp/data/models/faq.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

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
  late CampsiteBloc _campsiteBloc;
  late CampsiteEventBloc _campsiteEventBloc;
  late BookingBloc _bookingBloc;
  Map<String, dynamic>? paymentIntent;
  List<CampsiteEventModel>? campsiteEvents;
  int selectedIndex = 0;
  @override
  initState() {
    _campsiteBloc = context.read<CampsiteBloc>();
    _campsiteEventBloc = context.read<CampsiteEventBloc>();
    _bookingBloc = context.read<BookingBloc>();
    _campsiteBloc.add(SingleCampsiteRequested(
        campsiteId: widget.campsiteId,
        userId: context.read<SessionCubit>().state.id));
    _campsiteEventBloc
        .add(CampsiteEventsRequested(campsiteId: widget.campsiteId));
    super.initState();
  }

  List<ExpansionPanelItem> _expansionPanelItems = [];

  @override
  void dispose() {
    super.dispose();
  }

  String _formatDate(DateTime date) {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  Future<Map<String, dynamic>> createPaymentIntent(
      int amount, String currency) async {
    try {
      //Request body
      Map<String, dynamic> body = {
        'amount': amount.toString(),
        'currency': currency,
      };

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer ${dotenv.env['STRIPE_SECRET']}',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      return jsonDecode(response.body);
    } catch (err) {
      throw Exception(err.toString());
    }
  }

  Future<void> makePayment() async {
    try {
      paymentIntent = await createPaymentIntent(
          campsiteEvents![selectedIndex].price, 'MYR');

      //STEP 2: Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
          paymentSheetParameters: SetupPaymentSheetParameters(
              billingDetailsCollectionConfiguration:
                  const BillingDetailsCollectionConfiguration(
                      address: AddressCollectionMode.never),
              paymentIntentClientSecret:
                  paymentIntent!['client_secret'], //Gotten from payment intent
              style: ThemeMode.light,
              merchantDisplayName: 'MyCamp'));

      //STEP 3: Display Payment sheet
      _displayPaymentSheet();
    } catch (err) {
      throw Exception(err);
    }
  }

  void _displayPaymentSheet() async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) {
        //Clear paymentIntent variable after successful payment
        paymentIntent = null;
        //Go to booking success page
        _bookingBloc.add(PaymentBookingSuccess(campsiteEvents![selectedIndex]));
        // context.goNamed('booking_success');
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
    } catch (e) {
      print('$e');
    }
  }

  Widget _buildChips(
      {required List<CampsiteEventModel> campsiteEvents, int? selectedIndex}) {
    this.campsiteEvents = campsiteEvents;
    this.selectedIndex = selectedIndex ?? 0;
    List<Widget> chips = [];

    for (int i = 0; i < campsiteEvents.length; i++) {
      ChoiceChip choiceChip = ChoiceChip(
        selected: this.selectedIndex == i,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(this.selectedIndex == i ? 20 : 5),
        ),
        side: BorderSide(
            color: this.selectedIndex == i
                ? Colors.transparent
                : Theme.of(context).primaryColor),
        label: Text(campsiteEvents[i].name,
            style: TextStyle(
                color: this.selectedIndex == i
                    ? Colors.white
                    : Theme.of(context).primaryColor)),
        avatar: this.selectedIndex == i
            ? const CircleAvatar(
                backgroundColor: Colors.transparent,
                child: Icon(
                  Icons.check,
                  color: Colors.white,
                ),
              )
            : null,
        backgroundColor: Colors.transparent,
        selectedColor: Theme.of(context).primaryColor,
        onSelected: (bool selected) {
          _campsiteEventBloc.add(CampsiteEventSelected(
              campsiteEvents: campsiteEvents, selectedIndex: i));
        },
      );

      chips.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: choiceChip,
      ));
    }

    return SizedBox(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Event name",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  campsiteEvents[this.selectedIndex!].name,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Start date",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  _formatDate(campsiteEvents[this.selectedIndex].startDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "End date",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  _formatDate(campsiteEvents[this.selectedIndex].endDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Total Price",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  'RM ${campsiteEvents[this.selectedIndex].price / 100}',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          const Divider(
            thickness: 1.0,
          ),
          Wrap(
            children: chips,
          ),
          const Divider(
            thickness: 1.0,
          ),
          TextButton.icon(
              label: const Text("Proceed to payment"),
              onPressed: () async {
                await makePayment();
                // context.goNamed('payment', params: {"campsiteId": widget.campsiteId, "campsiteEventId": campsiteEvents[selectedIndex].id});
              },
              icon: const Icon(Icons.payment))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<BookingBloc, BookingState>(
      listener: (context, state) {
        if (state is BookingSuccess) {
          context.goNamed('booking_success');
        }
      },
      child: Scaffold(
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
              count = count + 1;
              if (count == 2) {
                print('x');
                isFavourite = _campsite.favourites!
                    .contains(context.read<SessionCubit>().state.id);
                print(isFavourite);
              }
              _expansionPanelItems = [
                ...state.campsite.faq!.asMap().entries.map((entry) {
                  if (entry.key < _expansionPanelItems.length) {
                    return ExpansionPanelItem(
                      faq: Faq.fromMap(entry.value),
                      isExpanded: _expansionPanelItems[entry.key].isExpanded,
                    );
                  } else {
                    return ExpansionPanelItem(
                      faq: Faq.fromMap(entry.value),
                    );
                  }
                }).toList()
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
                              BlocBuilder<CampsiteBloc, CampsiteState>(
                                builder: (context, state) {
                                  if (state is CampsiteLoaded &&
                                      !state.isCampsiteOwner) {
                                    return IconButton(
                                      onPressed: () async {
                                        if (isFavourite!) {
                                          await FirebaseFirestore.instance
                                              .collectionGroup('campsites')
                                              .where('id',
                                                  isEqualTo: _campsite.id)
                                              .get()
                                              .then((val) => val.docs.forEach(
                                                  (doc) =>
                                                      doc.reference.update({
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
                                                  (doc) =>
                                                      doc.reference.update({
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
                            },
                            icon: const Icon(Icons.star),
                            label: const Text("Add a Review"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context)
                                  .primaryColor, // Set the background color of the button
                            ),
                          ),
                          const SizedBox(height: 5.0),
                          const Divider(),
                          const SizedBox(height: 20.0),
                          const Text(
                            'Address',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            _campsite.address,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20.0),
                          const SizedBox(height: 20.0),
                          const Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20.0),
                          Text(
                            _campsite.description,
                            style: const TextStyle(fontSize: 14),
                          ),
                          const SizedBox(height: 20.0),
                          const Divider(),
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
                            children: _expansionPanelItems
                                .map<ExpansionPanel>((item) {
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
                              campsiteid: state.campsite.id,
                              campsite: _campsite),
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
                                        context.goNamed(
                                            'campsite-manage-product',
                                            params: {
                                              "campsiteId": state.campsite.id
                                            });
                                      },
                                      label: const Text("Manage Event"),
                                      icon: const Icon(Icons.edit_calendar)),
                                );
                              }
                              return Row(
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceBetween, // Align buttons at the opposite ends
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        showModalBottomSheet(
                                            useSafeArea: true,
                                            context: context,
                                            builder: (context) {
                                              return Column(
                                                children: [
                                                  Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.end,
                                                      children: [
                                                        IconButton(
                                                          icon: const Icon(
                                                              Icons.close),
                                                          onPressed: () =>
                                                              context.pop(),
                                                        ),
                                                      ]),
                                                  BlocProvider.value(
                                                    value: _campsiteEventBloc,
                                                    child: BlocBuilder<
                                                            CampsiteEventBloc,
                                                            CampsiteEventState>(
                                                        builder:
                                                            (context, state) {
                                                      if (state
                                                          is CampsiteEventsLoaded) {
                                                        if (state.campsiteEvents
                                                            .isEmpty) {
                                                          return Expanded(
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .event_busy,
                                                                  size: MediaQuery.of(
                                                                              context)
                                                                          .size
                                                                          .width /
                                                                      4,
                                                                  color: Theme.of(
                                                                          context)
                                                                      .primaryColor,
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                const Text(
                                                                  "No event found",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                ),
                                                                const SizedBox(
                                                                  height: 10,
                                                                ),
                                                                const Text(
                                                                  "Seem like this campsite haven't add any events yet...",
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        }
                                                        return _buildChips(
                                                            campsiteEvents: state
                                                                .campsiteEvents);
                                                      }
                                                      if (state
                                                          is SelectedCampsiteEvent) {
                                                        return _buildChips(
                                                            campsiteEvents: state
                                                                .campsiteEvents,
                                                            selectedIndex: state
                                                                .selectedIndex);
                                                      }
                                                      return const SizedBox();
                                                    }),
                                                  )
                                                ],
                                              );
                                            });
                                      },
                                      icon: const Icon(Icons.book_online),
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
                      )
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
