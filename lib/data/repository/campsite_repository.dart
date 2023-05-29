import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_camp/data/models/campsite.dart';
import 'package:my_camp/data/services/campsite_service.dart';

class CampsiteRepository{
  CampsiteService campsiteService = CampsiteService();
  Future<List<Campsite>> getCampsiteList(List<Campsite> campsitesList, String? keyword,List? selectedStates, String? userId) async {
    return campsiteService.fetchCampsiteData(campsitesList: campsitesList, keyword: keyword,selectedStates:selectedStates, userId: userId,limit: 10);
  }

  Future<Campsite?> fetchSingleCampsiteData(String campsiteId){
    return campsiteService.fetchSingleCampsiteData(campsiteId);
  }

  Future<void> updateCampsite(Campsite campsite, String userId) async {
    await campsiteService.updateCampsiteData(campsite, userId);
  }
  // add campsite
  Future<void> addCampsite(Campsite campsite, String userId) async {
    await campsiteService.addCampsiteData(campsite, userId);
  }
  // delete campsite
  Future<void> deleteCampsite(Campsite campsite, String userId) async {
    await campsiteService.deleteCampsiteData(campsite, userId);
  }
}