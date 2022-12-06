// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/models/order.dart';
import 'package:women_safety_app/screens/orders/customModal.dart';
import 'package:women_safety_app/utils/globals.dart';

class ManageOrdersScreen extends StatefulWidget {
  ManageOrdersScreen({Key? key}) : super(key: key);

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  bool isLoading = false;

  getRowCard(String total,String completed,String cancelled,String inProcess) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: GridView(
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 40,
          mainAxisExtent: 150,
        ),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Orders',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurple.shade400,
                  )),
              const SizedBox(
                height: 5,
              ),
              Card(
                elevation: 6,
                color: Colors.deepPurple.shade300,
                child: Container(
                  // height: 100,
                  // width: 220,
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 38),
                  child: Center(
                    child: Text(total,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Completed Orders',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.green.shade400,
                  )),
              const SizedBox(
                height: 5,
              ),
              Card(
                elevation: 6,
                color: Colors.green.shade400,
                child: Container(
                  // height: 100,
                  // width: 220,
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 38),
                  child: Center(
                    child:Text(completed,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white))
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total Cancelled Orders',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.red.shade300)),
              const SizedBox(
                height: 5,
              ),
              Card(
                elevation: 6,
                color: Colors.red.shade300,
                child: Container(
                  // height: 100,
                  // width: 220,
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 38),
                  child: Center(
                    child: Text(cancelled,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white))
                  ),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Total In Process Orders',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.orange.shade300)),
              const SizedBox(
                height: 5,
              ),
              Card(
                elevation: 6,
                color: Colors.orange.shade300,
                child: Container(
                  // height: 100,
                  // width: 220,
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 38),
                  child: Center(
                    child: Text(inProcess,
                      style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: Colors.white))),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Container(
          height: constraints.maxHeight,
          padding: const EdgeInsets.all(20),
          color: AppColors.baseBackgroundColor,
          child: StreamBuilder(
            stream: orderRepo.getAllOrdersStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                QuerySnapshot qs = snapshot.data as QuerySnapshot;
                // print(snapshot);
                Map completedOrders = {};
                Map inProcessOrders = {};
                Map cancelledOrders = {};
                if (qs.docs.isNotEmpty) {
                  for (var element in qs.docs) {
                    Map order = element.data() as Map;
                    if (order['status'] == 'completed') {
                      completedOrders[order['_id']] = order;
                    } else if (order['status'] == 'cancelled') {
                      cancelledOrders[order['_id']] = order;
                    } else {
                      inProcessOrders[order['_id']] = order;
                    }
                  }
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        getRowCard(qs.docs.length.toString(), completedOrders.length.toString(), cancelledOrders.length.toString(), inProcessOrders.length.toString()),
                        const SizedBox(height: 30,),
                        const Text('Orders',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.blueGrey,
                          )),
                        const SizedBox(height: 10,),
                        GridView.builder(
                          physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 4,
                              mainAxisExtent: 140,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            shrinkWrap: true,
                            itemCount: qs.docs.length,
                            itemBuilder: (context, index) {
                              print(qs.docs[index].data());
                              Order _order = Order.fromJson(
                                  qs.docs[index].data() as Map<String, dynamic>);
                  
                              return InkWell(
                                onTap: () =>
                                    showOrderDetailsModal(context, _order),
                                child: Card(
                                  color: _order.status == 'completed'
                                      ? Colors.lightGreen.shade300
                                      : _order.status == 'cancelled'
                                          ? Colors.red.shade300
                                          : Colors.orange.shade300,
                                  elevation: 6,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            const Text(
                                              'Delivery:',
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              _order.deliveryAddress!,
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            const Text(
                                              'Customer Phone:',
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              _order.orderBy!['phoneNumber'],
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            const Text(
                                              'CoD:',
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              _order.isCOD!.toString(),
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          // ignore: prefer_const_literals_to_create_immutables
                                          children: [
                                            const Text(
                                              'Status:',
                                              style:
                                                  TextStyle(color: Colors.white),
                                            ),
                                            Text(
                                              _order.status! == 'completed'
                                                  ? 'Completed'
                                                  : _order.status! == 'cancelled'
                                                      ? 'Cancelled'
                                                      : 'In process',
                                              style: const TextStyle(
                                                  color: Colors.white),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ],
                    ),
                  );
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
