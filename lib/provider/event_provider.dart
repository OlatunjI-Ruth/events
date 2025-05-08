import 'package:events/model/event_model.dart';
import 'package:events/model/success_response.dart';
import 'package:events/service/api_service.dart';
import 'package:flutter/material.dart';

class EventProvider extends ChangeNotifier {
  // final ApiService _apiService = ApiService();
  final ApiService apiService;

  EventProvider({required this.apiService});

  List<Datum> _events = [];
  bool _isLoading = false;
  bool _isPurchasingEvents = false;
  String? _errorMessage;

  List<Datum> get events => _events;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isPurchasingEvents => _isPurchasingEvents;

  Future<void> loadEvents() async {
    _isLoading = true;
    try {
      _events = await apiService.fetchEvents();
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future purchaseTicket(
    int eventId,
  ) async {
    _isPurchasingEvents = true;
    notifyListeners();
    return await apiService.buyTicket(eventId).then((value) {
      PurchaseResponseModel purchasedTicket = value;
      _isPurchasingEvents = false;
      notifyListeners();
      return purchasedTicket;
    }).catchError((onError) {
      _isPurchasingEvents = false;
      notifyListeners();
      throw onError;
    });
  }
}
