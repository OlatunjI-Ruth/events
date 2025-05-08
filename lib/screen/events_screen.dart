import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:events/provider/event_provider.dart';
import 'package:events/screen/widgets/alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventScreen extends StatefulWidget {
  const EventScreen({super.key});

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  void initState() {
    super.initState();
    context.read<EventProvider>().loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Consumer<EventProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.errorMessage != null) {
            return Center(child: Text(provider.errorMessage!));
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Buy tickets to this event',
                    style: TextStyle(
                        color: Color(0xff000000),
                        fontSize: 24,
                        fontWeight: FontWeight.w700)),
                const SizedBox(
                  height: 24,
                ),
                CarouselSlider(
                  options: CarouselOptions(
                    height: 346,
                    autoPlay: false,
                    enlargeCenterPage: true,
                    viewportFraction: 0.95,
                    aspectRatio: 2.0,
                    initialPage: 0,
                    enableInfiniteScroll: false,
                    onPageChanged: (index, reason) {
                      setState(() => _current = index);
                    },
                  ),
                  items: provider.events.asMap().entries.map((entry) {
                    final index = entry.key;
                    final event = entry.value;
                    return Builder(
                      builder: (BuildContext context) {
                        final dateFormatted =
                            DateFormat('dd/MM/yyyy').format(event.date!);
                        final clipper =
                            index.isEven ? CurvedClipper2() : CurvedClipper();

                        return ClipPath(
                          clipper: clipper,
                          child: Container(
                            width: 400,
                            margin: const EdgeInsets.symmetric(vertical: 5.0),
                            decoration: const BoxDecoration(
                              color: Color(0xff353535),
                            ),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    Container(
                                      height: 206,
                                      width: 400,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: AssetImage(event.imagePath!),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      top: 50,
                                      left: 10,
                                      child: Container(
                                        width: 73,
                                        height: 32,
                                        decoration: BoxDecoration(
                                            color:
                                                Colors.white.withOpacity(0.3),
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        padding: const EdgeInsets.all(6),
                                        child: const Text(
                                          '\$150.00',
                                          style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w400,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      event.name!,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      event.location!,
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xffFAFAFA)),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(Icons.calendar_month,
                                                color: Colors.white, size: 15),
                                            const SizedBox(width: 4),
                                            Text(dateFormatted,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xffFAFAFA))),
                                          ],
                                        ),
                                        const SizedBox(width: 10),
                                        Row(
                                          children: [
                                            const Icon(Icons.alarm,
                                                color: Colors.white, size: 15),
                                            const SizedBox(width: 4),
                                            Text(dateFormatted,
                                                style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xffFAFAFA)))
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: provider.events.asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _controller.animateToPage(entry.key),
                      child: Container(
                        width: 7.0,
                        height: 7.0,
                        margin: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 4.0,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: (Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white
                                    : Colors.black)
                                .withOpacity(0.9), // Consistent outline color
                            width: 1.0,
                          ),
                          color: _current == entry.key
                              ? Colors.black
                              : const Color(0xffEEEEEE),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Consumer<EventProvider>(
                  builder: (context, provider, _) {
                    return GestureDetector(
                      onTap: !provider.isPurchasingEvents
                          ? () async {
                              final currentEvent = provider.events[_current];
                              await provider
                                  .purchaseTicket(currentEvent.id!)
                                  .then((value) {
                                showAlertDialog(
                                    () {}, value.message.toString(), context);
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    duration: const Duration(seconds: 1),
                                    content: Text(error.toString()),
                                  ),
                                );
                              });
                            }
                          : null,
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 20.0),
                        height: 52,
                        width: 276,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14.0),
                          color: provider.isPurchasingEvents
                              ? Colors.grey
                              : const Color(0xff1BA95E),
                        ),
                        child: Center(
                          child: provider.isPurchasingEvents
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text(
                                  'Buy Now',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

class CurvedClipper2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.moveTo(0, 0);
    path.quadraticBezierTo(size.width / 2, 50, size.width, 0);

    path.lineTo(size.width, size.height);
    path.quadraticBezierTo(size.width / 2, size.height - 50, 0, size.height);

    path.lineTo(0, 50);

    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class CurvedClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    // Top concave curve
    path.moveTo(0, 50);
    path.quadraticBezierTo(size.width / 2, 0, size.width, 50);

    path.lineTo(size.width, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height, 0, size.height - 50);

    path.close();

    path.lineTo(0, 0);

    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
