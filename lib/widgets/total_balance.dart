import 'package:ewallet/models/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TotalBalance extends StatefulWidget {
  const TotalBalance({super.key});

  @override
  State<TotalBalance> createState() => _TotalBalanceState();
}

class _TotalBalanceState extends State<TotalBalance> {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    userProvider.fetchUserData();
    final currentUserData = userProvider.userData;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 100.0, horizontal: 25.0),
      width: 2000,
      child: Column(
        children: [
          Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 25.0, vertical: 12.0),
              child: Column(
                children: [
                  const Text("Total balance:"),
                  Text(
                    (currentUserData != null
                        ? '\$${userProvider.userData?["balance"]}'
                        : "Loading..."),
                    style: const TextStyle(fontSize: 30),
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25.0, vertical: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 40),
                                    backgroundColor: Colors.teal),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/topup');
                                },
                                child: const Text("Top up",
                                    style: TextStyle(color: Colors.white))),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    minimumSize: const Size(100, 40),
                                    backgroundColor: Colors.teal),
                                onPressed: () {
                                  Navigator.pushNamed(context, '/pay');
                                },
                                child: const Text("Pay",
                                    style: TextStyle(color: Colors.white))),
                          )
                        ],
                      ))
                ],
              )),
        ],
      ),
    );
  }
}
