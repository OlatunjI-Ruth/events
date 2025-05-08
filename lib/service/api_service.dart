import 'dart:convert';
import 'package:events/model/event_model.dart';
import 'package:events/model/success_response.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String eventUrl =
      'https://mocki.io/v1/2ab8f00e-1fe7-4dfa-a569-55803acc6074';
  final String successfulPurchaseUrl =
      'https://mocki.io/v1/8376daf6-8f0d-4485-8641-4fc38a06970';

  Future<List<Datum>> fetchEvents() async {
    final response = await http.get(Uri.parse(eventUrl));
    if (response.statusCode == 200) {
      final res = json.decode(response.body);

      final List<dynamic> dataList = res['data'];
      List<Datum> eventsList =
          dataList.map((item) => Datum.fromJson(item)).toList();
      return eventsList;
    } else {
      throw Exception('Failed to load events');
    }
  }

  Future buyTicket(int eventId) async {
    final response = await http.get(Uri.parse(successfulPurchaseUrl));

    if (response.statusCode == 200) {
      final decodedResponse =
          json.decode(utf8.decode(response.bodyBytes)) as Map<String, dynamic>;
      PurchaseResponseModel purchaseResponseModel =
          PurchaseResponseModel.fromJson(decodedResponse);
      return purchaseResponseModel;
    } else {
      throw Exception('Failed to load data');
    }
  }
}
