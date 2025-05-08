import 'package:events/model/event_model.dart';
import 'package:events/model/success_response.dart';
import 'package:events/provider/event_provider.dart';
import 'package:events/service/api_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'event_provider_unit_test.mocks.dart';

@GenerateMocks([ApiService])
void main() {
  late EventProvider eventProvider;
  late MockApiService mockApiService;

  final mockEvents = [
    Datum(
      id: 1,
      name: 'Mock Event',
      location: 'Mock Location',
      date: DateTime(2024, 1, 1),
      imagePath: 'mock.png',
      price: 50.0,
    ),
    Datum(
      id: 2,
      name: 'Mock Event',
      location: 'Mock Location',
      date: DateTime(2024, 1, 1),
      imagePath: 'mock.png',
      price: 50.0,
    ),
    Datum(
      id: 3,
      name: 'Mock Event',
      location: 'Mock Location',
      date: DateTime(2024, 1, 1),
      imagePath: 'mock.png',
      price: 50.0,
    ),
  ];

  setUp(() {
    mockApiService = MockApiService();
    eventProvider = EventProvider(apiService: mockApiService);
  });

  test('loadEvents loads data successfully', () async {
    // Arrange
    when(mockApiService.fetchEvents()).thenAnswer((_) async => mockEvents);

    // Act
    await eventProvider.loadEvents();

    // Assert
    expect(eventProvider.isLoading, false);
    expect(eventProvider.events, mockEvents);
    expect(eventProvider.errorMessage, isNull);
    verify(mockApiService.fetchEvents()).called(1);
  });

  test('loadEvents handles failure', () async {
    // Arrange
    when(mockApiService.fetchEvents()).thenThrow(Exception('Network error'));

    // Act
    await eventProvider.loadEvents();

    // Assert
    expect(eventProvider.isLoading, false);
    expect(eventProvider.events, isEmpty);
    expect(eventProvider.errorMessage, contains('Network error'));
    verify(mockApiService.fetchEvents()).called(1);
  });

  test('purchaseTicket - success', () async {
    const eventId = 1;
    const successMessage = 'Ticket purchased successfully.';

    // Arrange
    when(mockApiService.buyTicket(eventId))
        .thenAnswer((_) async => successMessage);

    // Act
    final result = await eventProvider.purchaseTicket(eventId);

    // Assert
    expect(result, successMessage);
    expect(eventProvider.isPurchasingEvents, false);
    verify(mockApiService.buyTicket(eventId)).called(1);
  });
  testWidgets('purchaseTicket shows an alert dialog with success message',
      (WidgetTester tester) async {
    const eventId = 1;
    const successMessage = 'Ticket purchased successfully.';

    final mockApiService = MockApiService();
    final eventProvider = EventProvider(apiService: mockApiService);

    when(mockApiService.buyTicket(eventId)).thenAnswer(
      (_) async => PurchaseResponseModel(message: successMessage),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  final result = await eventProvider.purchaseTicket(eventId);
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: const Text('Success'),
                      content: Text(result.message), // ✅ access .message here
                    ),
                  );
                },
                child: const Text('Test'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // Wait for dialog animation

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text(successMessage), findsOneWidget);
  });

  testWidgets('purchase Ticket shows a snackbar on error',
      (WidgetTester tester) async {
    const eventId = 1;
    const errorMessage = 'Something went wrong';

    final mockApiService = MockApiService();
    final eventProvider = EventProvider(apiService: mockApiService);

    // Mock the error response
    when(mockApiService.buyTicket(eventId)).thenThrow(errorMessage);

    final scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

    await tester.pumpWidget(
      MaterialApp(
        scaffoldMessengerKey:
            scaffoldMessengerKey, // ✅ this is key to showing SnackBar
        home: Builder(
          builder: (BuildContext context) {
            return Scaffold(
              body: ElevatedButton(
                onPressed: () async {
                  try {
                    await eventProvider.purchaseTicket(eventId);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                  }
                },
                child: const Text('Trigger Error'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle(); // Wait for snackbar to appear

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text(errorMessage), findsOneWidget);
  });
}
