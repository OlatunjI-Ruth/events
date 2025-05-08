import 'package:flutter/material.dart';

void showAlertDialog(
    VoidCallback onTapFunction, String message, BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: const Color(0xff030000),
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: 297,
          height: 283,
          decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(16))),
          // padding: const EdgeInsets.only(
          //     left: 16.0, right: 16.0, top: 20, bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Ticket Purchased",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xff2C2C2C)),
              ),
              const SizedBox(height: 16),
              Text(
                message,
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff465059)),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  onTapFunction(); // Call your callback
                },
                child: Container(
                  // margin: const EdgeInsets.symmetric(vertical: 20.0),
                  height: 52,
                  width: 164,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    color: const Color(0xff1BA95E),
                  ),
                  child: const Center(
                    child: Text(
                      'Done',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}
