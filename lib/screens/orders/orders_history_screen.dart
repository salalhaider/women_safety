import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:women_safety_app/models/order.dart';
import 'package:women_safety_app/screens/dashboard/custom_text_field.dart';
import 'package:women_safety_app/screens/orders/customModal.dart';
import 'package:women_safety_app/utils/globals.dart';
import 'package:women_safety_app/screens/orders/manage_orders.dart';

class OrdersHistoryScreen extends StatefulWidget {
  OrdersHistoryScreen({Key? key}) : super(key: key);

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {

 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders History'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          padding: const EdgeInsets.all(20),
          color: AppColors.baseBackgroundColor,
          child: StreamBuilder(
            stream: orderRepo.getUserOrdersStream(currentUserGlobal!.id!),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                QuerySnapshot qs = snapshot.data as QuerySnapshot;
                // print(snapshot);
                if (qs.docs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: qs.docs.length,
                    itemBuilder: (context, index) {
                    print('------ index $index');
                    Order order = Order.fromJson(
                        qs.docs[index].data() as Map<String, dynamic>);
                    return InkWell(
                        onTap: () => showOrderDetailsModal(context,order),
                        child: Card(
                      color: order.status == 'completed'
                          ? Colors.lightGreen.shade300
                          : order.status == 'cancelled'
                              ? Colors.red.shade300
                              : Colors.orange.shade300,
                      elevation: 6,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text(
                                  'Order Number:',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  order.orderNumber!.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text(
                                  'Delivery:',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  order.deliveryAddress!,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text(
                                  'Customer Phone:',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  order.orderBy!['phoneNumber'],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text(
                                  'Payment:',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  order.isCOD!?'CoD':'NA'.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text(
                                  'Status:',
                                  style: TextStyle(color: Colors.white),
                                ),
                                Text(
                                  order.status! == 'completed'
                                      ? 'Completed'
                                      : order.status! == 'cancelled'
                                          ? 'Cancelled'
                                          : 'In process',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ));
                  });
                } else {
                  print('emtyyyyyy');
                  return Container();
                }
              } else if (snapshot.hasError) {
                print(snapshot.error);
                return const Center(
                  child: Text('Error'),
                );
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
        );
      }),
    );
  }
}
