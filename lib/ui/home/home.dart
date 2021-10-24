import 'package:ali_poster/ui/widgets/order_card.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Image.asset("assets/images/logo.png"),
          const Align(
            alignment: Alignment.center,
            child: Text(
              "Anthony Gordon",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18.0,
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 18.0,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.fill,
            image: Image.asset("assets/images/background.jpg").image,
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Доска заказов",
                  style: TextStyle(color: Colors.white, fontSize: 24),
                ),
                Text(
                  "01.02.2021",
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            FractionallySizedBox(
              heightFactor: 1,
              widthFactor: 1,
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return const OrderCard(
                    orderId: 0,
                    cost: 500,
                    destination: "Vokzal",
                    orderedTime: 30,
                    clientContact: "+998979001234",
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
