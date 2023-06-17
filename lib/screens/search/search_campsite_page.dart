import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/logic/blocs/search/search_bloc.dart';
import 'package:my_camp/widgets/campsite_item.dart';

class SearchCampsitePage extends StatefulWidget {
  const SearchCampsitePage({Key? key}) : super(key: key);

  @override
  State<SearchCampsitePage> createState() => _SearchCampsitePageState();
}

class _SearchCampsitePageState extends State<SearchCampsitePage> {
  List<Campsite> _campsitesList = [];
  final TextEditingController _searchController = TextEditingController();
  bool _validationMsg = false;
  bool _dataFetched = false;
  Timer? _debounce;
  late SearchBloc _searchBloc;
  List<Map<String, dynamic>> tempCheckBoxes = [
        {"state": "Selangor", "isChecked": false},
        {"state": "Kuala Lumpur", "isChecked": false},
        {"state": "Sarawak", "isChecked": false},
        {"state": "Johor", "isChecked": false},
        {"state": "Sabah", "isChecked": false},
        {"state": "Penang", "isChecked": false},
        {"state": "Perak", "isChecked": false},
        {"state": "Pahang", "isChecked": false},
        {"state": "Negeri Sembilan", "isChecked": false},
        {"state": "Kedah", "isChecked": false},
        {"state": "Melaka", "isChecked": false},
        {"state": "Kelantan", "isChecked": false},
        {"state": "Perlis", "isChecked": false},
        {"state": "Labuan", "isChecked": false},
      ],
      savedCheckBoxes = [
        {"state": "Selangor", "isChecked": false},
        {"state": "Kuala Lumpur", "isChecked": false},
        {"state": "Sarawak", "isChecked": false},
        {"state": "Johor", "isChecked": false},
        {"state": "Sabah", "isChecked": false},
        {"state": "Penang", "isChecked": false},
        {"state": "Perak", "isChecked": false},
        {"state": "Pahang", "isChecked": false},
        {"state": "Negeri Sembilan", "isChecked": false},
        {"state": "Kedah", "isChecked": false},
        {"state": "Melaka", "isChecked": false},
        {"state": "Kelantan", "isChecked": false},
        {"state": "Perlis", "isChecked": false},
        {"state": "Labuan", "isChecked": false},
      ];
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _searchBloc = context.read<SearchBloc>();
    if (!_dataFetched) {
      _searchBloc.add(CampsitesRequested(
          campsitesList: _campsitesList,
          keyword: _searchController.text,
          selectedStates: savedCheckBoxes,
          firstLoad: true));
      _dataFetched = true;
    }
    _scrollController.addListener(() {
      _onScroll(context);
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(() {
      _onScroll(context);
    });
    _scrollController.dispose();
    _debounce?.cancel();
    _campsitesList.clear();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll(BuildContext context) {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      _searchBloc.add(CampsitesRequested(
          campsitesList: _campsitesList,
          keyword: _searchController.text,
          selectedStates: savedCheckBoxes));
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _campsitesList = [];
      _searchBloc.add(CampsitesRequested(
          campsitesList: _campsitesList,
          keyword: query,
          selectedStates: savedCheckBoxes,
          firstLoad: true));
    });
  }

  void _applyFilters() {
    _validationMsg = false;
    // Save the selected checkboxes to the savedCheckBoxes list
    savedCheckBoxes =
        List<Map<String, dynamic>>.from(tempCheckBoxes.map((checkbox) => {
              "state": checkbox["state"],
              "isChecked": checkbox["isChecked"],
            }));
    _campsitesList = [];
    // Trigger the search query
    _searchBloc.add(CampsitesRequested(
        campsitesList: _campsitesList,
        keyword: _searchController.text,
        selectedStates: savedCheckBoxes,
        firstLoad: true));

    // Close the bottom sheet
    Navigator.pop(context, true);
  }

  void _resetCheckBoxes() {
    // Reset the checkbox states to the saved states
    tempCheckBoxes =
        List<Map<String, dynamic>>.from(savedCheckBoxes.map((checkbox) => {
              "state": checkbox["state"],
              "isChecked": checkbox["isChecked"],
            }));
    _validationMsg = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SearchBloc, SearchState>(
        listener: (context, state) {
          if (state is SearchError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              children: [
                Row(children: [
                  BackButton(
                    color: Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              onChanged: _onSearchChanged,
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.search,
                                  color: Colors.grey,
                                ),
                                hintText: 'Search',
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ]),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      label: const Text('Filter'),
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return Column(
                                  children: [
                                    ListTile(
                                      trailing: _validationMsg
                                          ? const Text(
                                              'More than 10 States Selected',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            )
                                          : const Text(
                                              'Select Up to 10 States'),
                                      title: const Text(
                                        'States',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: tempCheckBoxes.length,
                                        itemBuilder: (context, index) {
                                          return CheckboxListTile(
                                            title: Text(
                                                tempCheckBoxes[index]['state']),
                                            value: tempCheckBoxes[index]
                                                ['isChecked'],
                                            onChanged: (value) {
                                              setState(() {
                                                tempCheckBoxes[index]
                                                    ['isChecked'] = value;
                                              });
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          .9,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                          onPressed: tempCheckBoxes
                                                      .where((element) =>
                                                          element[
                                                              'isChecked'] ==
                                                          true)
                                                      .length <=
                                                  10
                                              ? _applyFilters
                                              : () {
                                                  setState(() {
                                                    _validationMsg = true;
                                                  });
                                                },
                                          child: const Text('Apply Filters'),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ).then((value) {
                          // Reset the checkbox values if bottom sheet is dismissed
                          if (value == null) {
                            _resetCheckBoxes();
                          }
                        });
                      },
                      icon: const Icon(Icons.filter_list),
                    ),
                  ],
                ),
                Expanded(
                  child: BlocBuilder<SearchBloc, SearchState>(
                    builder: (_, state) {
                      if (state is SearchLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (state is SearchResultLoaded) {
                        const firstLoadItemLength = 10;
                        if ((state.searchResults.isNotEmpty &&
                                _campsitesList.isEmpty) ||
                            (state.searchAction &&
                                _campsitesList.isEmpty &&
                                state.searchResults.isNotEmpty)) {
                          _campsitesList = state.searchResults;
                        } else {
                            _campsitesList = [
                              ..._campsitesList,
                              ...state.searchResults
                            ];
                          
                        }

                        if (_campsitesList.isEmpty) {
                          return Center(
                            child: Text('No results found'),
                          );
                        }
                        return ListView.builder(
                          controller: _scrollController,
                          itemCount: (state.hasReachedMax ||
                                  _campsitesList.length < firstLoadItemLength)
                              ? _campsitesList.length
                              : _campsitesList.length + 1,
                          itemBuilder: (context, index) {
                            return index >= _campsitesList.length
                                ? const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(4.0),
                                      child: SizedBox(
                                        height: 30,
                                        width: 30,
                                        child: CircularProgressIndicator(),
                                      ),
                                    ),
                                  )
                                : CampsiteItem(
                                    id: _campsitesList[index].id,
                                    imagePath: _campsitesList[index].imagePath,
                                    description: _campsitesList[index].state,
                                    starRating: 5,
                                    title: _campsitesList[index].name,
                                  );
                          },
                        );
                      } else {
                        return const Center(
                          child: Text('Something went wrong'),
                        );
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
