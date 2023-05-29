import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/logic/blocs/search/search_bloc.dart';
import 'package:my_camp/logic/cubits/session/session_cubit.dart';
import 'package:my_camp/widgets/campsite_item.dart';
import 'package:go_router/go_router.dart';

class ManageCampsite extends StatefulWidget {
  const ManageCampsite({Key? key}) : super(key: key);

  @override
  State<ManageCampsite> createState() => _ManageCampsiteState();
}

class _ManageCampsiteState extends State<ManageCampsite> {
  List<Campsite> _campsitesList = [];
  String? _userId;
  Timer? _debounce;
  bool _dataFetched = false;
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    _userId = context.read<SessionCubit>().state.id;
    if (!_dataFetched) {
      context.read<SearchBloc>().add(CampsitesRequested(
          campsitesList: _campsitesList,
          keyword: _searchController.text,
          userId: _userId,
          firstLoad: true));
      _dataFetched = true;
    }
    _scrollController.addListener(() {
      _onScroll(context);
    });
    super.initState();
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

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _campsitesList = [];
      context.read<SearchBloc>().add(CampsitesRequested(
          campsitesList: _campsitesList,
          keyword: query,
          userId: _userId,
          firstLoad: true));
    });
  }

  void _onScroll(BuildContext context) {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    if (currentScroll >= (maxScroll * 0.9)) {
      context.read<SearchBloc>().add(CampsitesRequested(
          campsitesList: _campsitesList,
          keyword: _searchController.text,
          userId: _userId));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  BackButton(
                    color: Theme.of(context).primaryColor,
                  ),
                  Expanded(
                    child: TextFormField(
                      onChanged: _onSearchChanged,
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search for campsites',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, // Adjust the vertical padding here
                          horizontal: 16.0,
                        ),
                        suffixIcon: const Icon(Icons.search),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add),
                    onPressed: () {
                      context.replaceNamed('campsites-create');
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) {
                if (state is SearchLoading) {
                  return Center(child: CircularProgressIndicator());
                }
                if (state is SearchResultLoaded) {
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
                              description: _campsitesList[index].state,
                              starRating: 5,
                              title: _campsitesList[index].name,
                            );
                    },
                  );
                }
                return Center(
                  child: Text('Something went wrong'),
                );
              }),
            )
          ],
        ),
      ),
    );
  }

  void _fetchCampsites() {
    context.read<SearchBloc>().add(CampsitesRequested(
        campsitesList: _campsitesList,
        keyword: _searchController.text,
        firstLoad: true,
        userId: _userId));
  }
}
