// ignore_for_file: avoid_print

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/models/product.dart';
import 'package:women_safety_app/screens/orders/orders_history_screen.dart';
import 'package:women_safety_app/screens/store/cart_screen.dart';
import 'package:women_safety_app/screens/store/custom_form.dart';
import 'package:women_safety_app/screens/store/product_details.dart';
import 'package:women_safety_app/utils/globals.dart';

class StoreScreen extends StatefulWidget {
  StoreScreen({Key? key}) : super(key: key);

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  bool showDisabledNotifier = false;

  addNewProduct(StoreProduct? product, bool isEditForm) {
    showModalBottomSheet(
        isScrollControlled: true,
        enableDrag: true,
        context: context,
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text(kIsWeb ? 'Edit product' : 'Add new product'),
            ),
            body: LayoutBuilder(builder: (context, constraints) {
              return Container(
                  width: constraints.maxWidth,
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.center,
                  child: NewProductForm(
                    product: product,
                    isEditForm: isEditForm,
                  ));
            }),
          );
        });
  }

  addToCart(StoreProduct product) {
    cart.value.add(product);
  }

  removeFromCart(StoreProduct product) {
    cart.value.remove(product);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Store'),
        actions: [
          if (!kIsWeb)
            IconButton(
              onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(),
                  )),
              icon: Icon(Icons.shopping_cart),
            )
        ],
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (kIsWeb)
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // Container(
                    //   alignment: Alignment.centerRight,
                    //   child: ElevatedButton(
                    //       onPressed: () {}, child: const Text('Filters')),
                    // ),
                    // const SizedBox(
                    //   width: 10,
                    // ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                  showDisabledNotifier
                                      ? Colors.green
                                      : Colors.blueGrey)),
                          onPressed: () {
                            setState(() {
                              if (showDisabledNotifier) {
                                showDisabledNotifier = false;
                              } else {
                                showDisabledNotifier = true;
                              }
                            });
                          },
                          child: const Text('Show Disabled Products')),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                          onPressed: () {
                            addNewProduct(null, false);
                          },
                          child: const Text('Add Product')),
                    ),
                  ],
                ),
              if (!kIsWeb)
                Container(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => OrdersHistoryScreen(),
                          )),
                      child: const Text(
                        'View History',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.blueGrey),
                      )),
                ),
              // if (kIsWeb)
              const SizedBox(
                height: 10,
              ),
              Text(
                showDisabledNotifier
                    ? 'Disabled Products'
                    : 'Available Products',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.blueGrey),
              ),
              const SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 1,
                child: StreamBuilder(
                    stream: showDisabledNotifier
                        ? productRepo.getAllDisableProductsStream()
                        : productRepo.getAllProductsStream(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        QuerySnapshot qs = snapshot.data as QuerySnapshot;
                        // print(snapshot);
                        if (qs.docs.isNotEmpty) {
                          return GridView.builder(
                              shrinkWrap: true,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: kIsWeb ? 6 : 2,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      mainAxisExtent: kIsWeb ? 300 : 240),
                              itemCount: qs.docs.length,
                              itemBuilder: (context, index) {
                                print(qs.docs[index].data());
                                StoreProduct _product = StoreProduct.fromJson(
                                    qs.docs[index].data()
                                        as Map<String, dynamic>);
                                int average = 0;
                                if (_product.reviews != null) {
                                  int totalValue = 0;
                                  for (var element in _product.reviews!) {
                                    totalValue += element['rating'] as int;
                                  }
                                  double averageReview =
                                      totalValue / _product.reviews!.length;
                                  average = averageReview>0? averageReview.floor():0;
                                }
                                return InkWell(
                                  onTap: () => showModalBottomSheet(context: context,isScrollControlled: true, builder: (context) => ProductDetails(product: _product,)),
                                  child: Card(
                                    color: _product.isDisable?Colors.blueGrey.shade50:Colors.white,
                                    elevation: 6,
                                    child: GridTile(
                                        child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          ClipOval(
                                            child: Container(
                                                height: 100,
                                                width: 100,
                                                color: Colors.blueGrey.shade100,
                                                child: _product.productPhoto !=
                                                            null &&
                                                        _product.productPhoto!
                                                            .isNotEmpty
                                                    ? CachedNetworkImage(
                                                        imageUrl: _product
                                                            .productPhoto!,
                                                      )
                                                    : const Icon(
                                                        Icons
                                                            .shopping_bag_outlined,
                                                      )),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(_product.title!.toUpperCase(),
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey
                                              ), 
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          // if (kIsWeb) Text(_product.articleId!,
                                          //   style: const TextStyle(
                                          //       fontWeight: FontWeight.bold
                                          //     ), 
                                          // ),
                                          // if (kIsWeb)
                                          //   const SizedBox(
                                          //     height: 5,
                                          //   ),
                                          Text('Rs. ${_product.price!}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey
                                              ), 
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          if (kIsWeb)
                                            Text(
                                                'Total Sold ${_product.totalOrders!.length}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey
                                              ),    
                                            ),
                                          if (kIsWeb)
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          Text(
                                              'Reviews(${_product.reviews?.length ?? 0}): $average/10',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.blueGrey
                                              ), ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          ElevatedButton(
                                              onPressed: () {
                                                if (kIsWeb) {
                                                  addNewProduct(_product, true);
                                                } else {
                                                  if (_product.quantity! > 0) {
                                                    addToCart(_product);
                                                    print(cart);
                                                  }
                                                }
                                              },
                                              child: Center(
                                                child: Text(kIsWeb
                                                    ? 'Edit'
                                                    : _product.quantity! < 1
                                                        ? 'Out of stock'
                                                        : 'Add to cart'),
                                              )),
                                          if (kIsWeb)
                                            const SizedBox(
                                              height: 5,
                                            ),
                                          if (kIsWeb)
                                            ElevatedButton(
                                                onPressed: () {
                                                  if (_product.isDisable) {
                                                    productRepo
                                                        .upadateDisablityProduct(
                                                            _product, false);
                                                  } else {
                                                    productRepo
                                                        .upadateDisablityProduct(
                                                            _product, true);
                                                  }
                                                },
                                                child: Center(
                                                  child: Text(_product.isDisable
                                                      ? 'Enable'
                                                      : 'Disable'),
                                                ))
                                        ],
                                      ),
                                    )),
                                  ),
                                );
                              });
                        } else {
                          print('emtyyyyyy');
                          return const Center(
                            child: Text('Sorry! No product availabe right now'),
                          );
                        }
                      } else if (snapshot.hasError) {
                        print(snapshot.error);
                        return const Center(
                          child: Text('Sorry! Error occured'),
                        );
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ),
            ],
          ),
        );
      }),
    );
  }
}
