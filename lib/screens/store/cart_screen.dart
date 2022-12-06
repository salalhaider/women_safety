import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pay/pay.dart';
import 'package:women_safety_app/models/order.dart';
import 'package:women_safety_app/models/product.dart';
import 'package:women_safety_app/screens/dashboard/custom_text_field.dart';
import 'package:women_safety_app/utils/globals.dart';
import 'package:women_safety_app/utils/utils.dart';

class CartScreen extends StatefulWidget {
  CartScreen({Key? key}) : super(key: key);

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  bool isCOD = true;
  String? address, phoneNumber;
  int total = 0;
  final formKey = GlobalKey<FormState>();
  removeFromCart(StoreProduct product) {
    cart.value.remove(product);
    cart.notifyListeners();
  }

  showModal() {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        )),
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              topRight: Radius.circular(25),
            )),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CustomTextField(
                      label: 'Address',
                      hint: 'Enter address',
                      onSaved: (v) {
                        if (v != null) {
                          address = v.trim();
                        }
                      },
                      onValitdate: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Field cannot be null';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    CustomTextField(
                      label: 'Phone Number',
                      hint: 'Enter phone number',
                      onSaved: (v) {
                        if (v != null) {
                          phoneNumber = v.trim();
                        }
                      },
                      onValitdate: (v) {
                        if (v == null || v.isEmpty) {
                          return 'Field cannot be null';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              cart.value.isNotEmpty
                                  ? Colors.blueGrey
                                  : Colors.grey)),
                      onPressed: () async {
                        if (cart.value.isNotEmpty) {
                          if (formKey.currentState!.validate()) {
                            formKey.currentState!.save();
                            List<Map> tempProducts = [];
                            for (var element in cart.value) {
                              tempProducts.add({
                                'productId': element.id,
                                'title': element.title,
                                'price': element.price,
                                'articleId': element.articleId
                              });
                            }
                            Order order = Order(
                                phoneNumber,
                                address,
                                isCOD,
                                {
                                  'id': currentUserGlobal!.id!,
                                  'name': currentUserGlobal!.firstName! +
                                      ' ' +
                                      currentUserGlobal!.lastName!,
                                  'phoneNumber': currentUserGlobal!.phoneNumber
                                },'inProcess',
                                tempProducts,
                                total,);
                            await orderRepo.addNewOrder(order).then((value) {
                              if (value) {
                                showSnackBar(
                                    context, 'Hurray! Order is placed');
                                cart.value = [];
                                Navigator.pop(context);
                                Navigator.pop(context);
                              } else {
                                showSnackBar(context, 'Failed :(');
                                // Navigator.pop(context);
                              }
                            });
                          }
                        }
                      },
                      child: Center(child: Text('Place order')),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      bottomNavigationBar: ValueListenableBuilder(
          valueListenable: cart,
          builder: (context, _cart, _) {
            return Container(
              height: 60,
              padding: const EdgeInsets.all(8),
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        cart.value.isNotEmpty ? Colors.blueGrey : Colors.grey)),
                onPressed: () {
                  if (cart.value.isNotEmpty) {
                    showModal();
                  }
                },
                child: Center(child: Text('Check out')),
              ),
            );
          }),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            height: constraints.maxHeight,
            color: AppColors.baseBackgroundColor,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Items',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(height: 10),
                ValueListenableBuilder(
                    valueListenable: cart,
                    builder: (context, _cart, _) {
                      return cart.value.isEmpty
                          ? Text(
                              'Cart is Empty',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blueGrey),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: cart.value.length,
                              itemBuilder: (context, index) {
                                StoreProduct product = cart.value[index];
                                return Card(
                                  child: ListTile(
                                    leading: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: product.productPhoto != null &&
                                                product.productPhoto!.isNotEmpty
                                            ? CachedNetworkImage(
                                                imageUrl: product.productPhoto!)
                                            : Icon(
                                                Icons.shopping_bag_outlined)),
                                    title: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(product.title!),
                                        Text(
                                            'Rs. ' + product.price!.toString()),
                                      ],
                                    ),
                                    trailing: IconButton(
                                      onPressed: () {
                                        removeFromCart(product);
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                    }),
                if (cart.value.isNotEmpty) const SizedBox(height: 10),
                if (cart.value.isNotEmpty)
                  ValueListenableBuilder(
                      valueListenable: cart,
                      builder: (context, _cart, _) {
                        total = 0;
                        for (var element in cart.value) {
                          total += element.price!;
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (cart.value.isNotEmpty)
                              Text(
                                'Total:',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueGrey),
                              ),
                            if (cart.value.isNotEmpty)
                              Text(
                                'Rs. ' + total.toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blueGrey),
                              ),
                          ],
                        );
                      }),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Payment Method',
                    style: Theme.of(context).textTheme.bodyText1!.copyWith(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.blueGrey),
                  ),
                ),
                const SizedBox(height: 10),
                Card(
                  child: ListTile(
                    leading: Radio(
                      onChanged: (v) {},
                      groupValue: isCOD,
                      value: isCOD,
                    ),
                    title: Text('Cash on Delivery'),
                  ),
                ),
                const SizedBox(height: 10),
                // GooglePayButton(
                //   paymentConfigurationAsset: 'default_payment_profile_google_pay.json',
                //   paymentItems: [PaymentItem(amount: total.toString())],
                //   style: GooglePayButtonStyle.black,
                //   type: GooglePayButtonType.pay,
                //   margin: const EdgeInsets.only(top: 15.0),
                //   onPaymentResult: onGooglePayResult,
                //   loadingIndicator: const Center(
                //     child: CircularProgressIndicator(),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
void onGooglePayResult(paymentResult) {
  // Send the resulting Google Pay token to your server / PSP
}
