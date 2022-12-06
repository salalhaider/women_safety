import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:women_safety_app/models/order.dart';
import 'package:women_safety_app/screens/dashboard/custom_text_field.dart';
import 'package:women_safety_app/utils/globals.dart';

Widget getRow(String title, value, Color color) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    // ignore: prefer_const_literals_to_create_immutables
    children: [
      Text(
        title,
        style: TextStyle(color: color),
      ),
      Text(
        value,
        style: TextStyle(color: color),
      ),
    ],
  );
}

showOrderDetailsModal(BuildContext context, Order order) {
  showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppBar(
                title: const Text('Order Details'),
                centerTitle: true,
                actions: [
                  if (kIsWeb && order.status == 'inProcess')
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.green)),
                          onPressed: () {
                            orderRepo.updateStatus(order, 'completed');
                            Navigator.pop(context);
                          },
                          child: const Center(
                            child: Text('Complete'),
                          )),
                    ),
                  if (kIsWeb && order.status == 'inProcess')
                    const SizedBox(
                      width: 5,
                    ),
                  if (kIsWeb && order.status == 'inProcess')
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          onPressed: () {
                            orderRepo.updateStatus(order, 'cancelled');
                            Navigator.pop(context);
                          },
                          child: const Center(
                            child: Text('Cancel'),
                          )),
                    ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: kIsWeb ? 200 : 10, vertical: kIsWeb ? 50 : 10),
                color: AppColors.baseBackgroundColor,
                // width: 300,
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        getRow(
                            'Delivery:', order.deliveryAddress!, Colors.black),
                        const SizedBox(
                          height: 10,
                        ),
                        getRow('Customer Name:', order.orderBy!['name'],
                            Colors.black),
                        const SizedBox(
                          height: 10,
                        ),
                        getRow('Customer Phone:', order.orderBy!['phoneNumber'],
                            Colors.black),
                        const SizedBox(
                          height: 10,
                        ),
                        getRow(
                            'Status',
                            order.status! == 'completed'
                                ? 'Completed'
                                : order.status! == 'cancelled'
                                    ? 'Cancelled'
                                    : 'In process',
                            Colors.black),
                        const SizedBox(
                          height: 10,
                        ),
                        getRow('Total Price:', 'Rs ' + order.total!.toString(),
                            Colors.black),
                        const SizedBox(
                          height: 10,
                        ),
                        getRow('CoD:', order.isCOD!.toString(), Colors.black),
                        const SizedBox(
                          height: 10,
                        ),
                        getRow('Total Products:',
                            order.products.length.toString(), Colors.black),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          'Products:',
                          style: TextStyle(
                              color: Colors.black, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: order.products.length,
                            itemBuilder: (context, index) {
                              Map product = order.products[index];
                              bool showReviewButton = false;
                              return Card(
                                color: Colors.green.shade50,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      getRow('Article ID:',
                                          product['articleId'], Colors.black),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      getRow('Article Name:', product['title'],
                                          Colors.black),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      getRow(
                                          'Price:',
                                          product['price'].toString(),
                                          Colors.black),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      if(!(currentUserGlobal!.reviewedProducts!=null && currentUserGlobal!.reviewedProducts!.contains(product['productId'])))
                                      TextButton(
                                          onPressed: () {
                                            showFeedbackAlert(
                                                context, product['productId']);
                                          },
                                          child: Text('Give Review'))
                                    ],
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

showFeedbackAlert(BuildContext context, String productId) {
  final formKey = GlobalKey<FormState>();
  String body = '';
  int? rating;
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  Alert(
      context: context,
      title: "Rating",
      content: Column(
        children: <Widget>[
          const SizedBox(
            height: 10,
          ),
          Form(
            key: formKey,
            child: Column(
              children: [
                CustomTextField(
                  label: 'Rating',
                  hint: 'Enter between 1 to 10',
                  keyboardType: TextInputType.number,
                  onSaved: (v) {
                    rating = int.tryParse(v!);
                  },
                  onValitdate: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Title cannot be null';
                    } else {
                      return null;
                    }
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: 'Review',
                  hint: 'Enter Review',
                  maxLines: 4,
                  onSaved: (v) {
                    body = v!;
                  },
                  onValitdate: (v) {
                    // if (v == null || v.isEmpty) {
                    //   return 'Title cannot be null';
                    // } else {
                    return null;
                    // }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () async {
            if (formKey.currentState!.validate()) {
              formKey.currentState!.save();
              productRepo.addProductReview(productId, {
                'rating': rating,
                'review': body,
                'reviewerId': currentUserGlobal!.id!,
                'reviewerName': currentUserGlobal!.firstName! +
                    ' ' +
                    currentUserGlobal!.lastName!
              });
              Navigator.pop(context);
            }
          },
          child: ValueListenableBuilder(
              valueListenable: isLoadingNotifier,
              builder: (context, isLoading, _) {
                return isLoading == false
                    ? const Text(
                        'post',
                        style: TextStyle(color: Colors.white),
                      )
                    : const SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ));
              }),
        ),
      ]).show();
}
