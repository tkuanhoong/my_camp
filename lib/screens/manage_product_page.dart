import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_camp/logic/blocs/campsite_event/campsite_event_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ManageProductPage extends StatefulWidget {
  final String campsiteId;
  const ManageProductPage({super.key, required this.campsiteId});

  @override
  State<ManageProductPage> createState() => _ManageProductPageState();
}

class _ManageProductPageState extends State<ManageProductPage> {
  late CampsiteEventBloc _campsiteEventBloc;
  @override
  void initState() {
    _campsiteEventBloc = context.read<CampsiteEventBloc>();
    _campsiteEventBloc
        .add(CampsiteEventsRequested(campsiteId: widget.campsiteId));
    super.initState();
  }

  String _formatDate(DateTime date) {
    DateFormat formatter = DateFormat('dd/MM/yyyy');
    return formatter.format(date);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<CampsiteEventBloc, CampsiteEventState>(
      listener: (context, state) {
        if (state is CampsiteEventsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.error),
              backgroundColor: Colors.red,
            ),
          );
        }
        if (state is CampsiteEventAdded) {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                      title: const Text("Campsite Event Added"),
                      content: const Text("Campsite Event Added Successfully"),
                      actions: [
                        TextButton(
                            onPressed: () => context.pop(),
                            child: const Text("OK"))
                      ]));
          _campsiteEventBloc
              .add(CampsiteEventsRequested(campsiteId: widget.campsiteId));
        }
        if (state is CampsiteEventDeleted) {
          _campsiteEventBloc
              .add(CampsiteEventsRequested(campsiteId: widget.campsiteId));
        }
      },
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Manage Event'),
            actions: [
              IconButton(
                onPressed: () {
                  context.goNamed('campsite-add-product',
                      params: {"campsiteId": widget.campsiteId},
                      extra: _campsiteEventBloc);
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: SafeArea(
            child: BlocBuilder<CampsiteEventBloc, CampsiteEventState>(
              builder: (context, state) {
                if (state is CampsiteEventsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is CampsiteEventsLoaded) {
                  final campsiteEvents = state.campsiteEvents;
                  if (campsiteEvents.isEmpty) {
                    return const Center(
                      child: Text('No Event found'),
                    );
                  }
                  return ListView.separated(
                      itemCount: campsiteEvents.length,
                      separatorBuilder: (context, index) => const Divider(),
                      itemBuilder: ((context, index) {
                        return ListTile(
                            isThreeLine: true,
                            title: Text(campsiteEvents[index].name),
                            subtitle: Text(
                              'RM ${campsiteEvents[index].price / 100}\n${_formatDate(campsiteEvents[index].startDate)} - ${_formatDate(state.campsiteEvents[index].endDate)}',
                              maxLines: 2,
                            ),
                            trailing: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // IconButton(
                                  //   icon: Icon(Icons.edit,
                                  //       color: Theme.of(context)
                                  //           .primaryColor
                                  //           .withOpacity(0.8)),
                                  //   onPressed: () {
                                  //     context.goNamed('campsite-edit-product',
                                  //         params: {
                                  //           "campsiteId": widget.campsiteId,
                                  //           "campsiteEvent":
                                  //               jsonEncode(campsiteEvents[index])
                                  //         },
                                  //         extra: _campsiteEventBloc);
                                  //   },
                                  // ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Theme.of(context)
                                          .primaryColor
                                          .withOpacity(0.8),
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text(
                                              "Are you sure to delete ${campsiteEvents[index].name}?"),
                                          content: const Text(
                                              "The action is irreversible."),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                context.pop();
                                              },
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                _campsiteEventBloc.add(
                                                    CampsiteEventDelete(state
                                                        .campsiteEvents[index]
                                                        .id!));
                                                context.pop();
                                              },
                                              child: const Text("Delete"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ));
                      }));
                }
                return const SizedBox();
              },
            ),
          ),
          floatingActionButton: FloatingActionButton(
            tooltip: 'Download report as pdf',
            onPressed: () {
              context.goNamed('pdfPreview',
                  params: {"campsiteId": widget.campsiteId});
            },
            child: const Icon(Icons.download),
          )),
    );
  }
}
