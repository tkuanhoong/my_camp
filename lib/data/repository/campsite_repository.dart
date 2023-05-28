import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/data/services/campsite_service.dart';

class CampsiteRepository{
  CampsiteService campsiteService = CampsiteService();
  Future<List<Campsite>> getCampsiteList(List<Campsite> campsitesList, String? keyword,List? selectedStates, String? userId) async {
    return campsiteService.fetchCampsiteData(campsitesList: campsitesList, keyword: keyword,selectedStates:selectedStates, userId: userId,limit: 10);
  }

  Future<List<Campsite>> searchCampsiteList(List<Campsite> campsitesList) async {
    return campsiteService.fetchCampsiteData(campsitesList: campsitesList,limit: 10);
  }
}