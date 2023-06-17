

import 'package:my_camp/data/models/campsite_event_model.dart';
import 'package:my_camp/data/services/campsite_event_service.dart';

class CampsiteEventRepository{
  final CampsiteEventService _campsiteEventService = CampsiteEventService();
  Future<List<CampsiteEventModel>> getCampsiteEvents(String campsiteId) async {
    return _campsiteEventService.fetchCampsiteEvents(campsiteId);
  }
  Future<CampsiteEventModel?> getSingleCampsiteEvent(String id) async {
    return _campsiteEventService.fetchSingleCampsiteEvent(id);
  }
  Future<void> add(CampsiteEventModel campsiteEvent) async {
    return _campsiteEventService.addCampsiteEvent(campsiteEvent);
  }
  Future<void> update(CampsiteEventModel campsiteEvent) async {
    return _campsiteEventService.updateCampsiteEvent(campsiteEvent);
  }
  Future<void> delete(String campsiteEventId) async {
    return _campsiteEventService.deleteCampsiteEvent(campsiteEventId);
  }

}