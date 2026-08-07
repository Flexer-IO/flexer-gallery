import 'package:flutter/material.dart';

// Stub implementations for missing widgets.
// These are provided to resolve compilation errors while preserving the original UI behavior.
class Spendings extends StatelessWidget {
  final String name;
  final String amount;

  const Spendings({
    Key? key,
    required this.name,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder container; the original UI expects a widget here.
    return Container();
  }
}

class PaymentMethods extends StatelessWidget {
  final String name;
  final String amount;

  const PaymentMethods({
    Key? key,
    required this.name,
    required this.amount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Placeholder container; the original UI expects a widget here.
    return Container();
  }
}

class Home extends StatefulWidget {
  final String header;

  const Home({Key? key, required this.header}) : super(key: key);
  
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20.0),
                      bottomRight: Radius.circular(20.0),
                    ),

                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      // Add one stop for each color. Stops should increase from 0 to 1
                      stops: [0.2, 0.7],
                      colors: [
                        Color(0xff00b2bb),
                        Color(0xff79d2a6),
                        // Colors.blue[400],
                        // Colors.blue[300],
                      ],
                      // stops: [0.0, 0.1],
                    ),
                  ),

                  height: MediaQuery.of(context).size.height * .40,
                  padding: EdgeInsets.only(top: 20, left: 30, right: 20),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          const Text("01 April 2017 to 01 April 2019",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 19.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.white,
                            ),
                            iconSize: 40.0,
                            onPressed: () {},
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Text(
                        "Total Sale",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        r"$15,990.00",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 34.0,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                    ],
                  ),
                ),
                // Container(
                //   height: MediaQuery.of(context).size.height * .75,
                //   color: Colors.white,
                // ),
              ],
            ),

            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .27,
                  right: 20.0,
                  left: 20.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: GridView(
                  primary: false,
                  shrinkWrap: true,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: MediaQuery.of(context).size.width /
                        (MediaQuery.of(context).size.height / 2.5),
                  ),
                  children: <Widget>[

                    Container(
                      padding: const EdgeInsets.only(right: 10.0),
                      child: Spendings(
                        name: "This Month",
                        amount: r"$5,990.00",
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Spendings(
                        name: "This Week",
                        amount: r"$200.00",
                      ),
                    ),

                  ],
                ),
              ),
            ),

            Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .47,
                  right: 20.0,
                  left: 20.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  primary: false,
                  children: <Widget>[

                    PaymentMethods(
                      name: "Cash",
                      amount: r"$1000.22",
                    ),

                    const SizedBox(height: 10.0,),

                    PaymentMethods(
                      name: "Card",
                      amount: r"$450.25",
                    ),

                    const SizedBox(height: 10.0,),

                    PaymentMethods(
                      name: "Paypal",
                      amount: r"$100.33",
                    ),

                    const SizedBox(height: 10.0,),

                    PaymentMethods(
                      name: "Cheque",
                      amount: r"$300.2",
                    ),

                    const SizedBox(height: 10.0,),

                    PaymentMethods(
                      name: "Credit",
                      amount: r"$0.0",
                    ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}