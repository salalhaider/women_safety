import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:women_safety_app/models/product.dart';
import 'package:women_safety_app/screens/orders/customModal.dart';

class ProductDetails extends StatelessWidget {
  final StoreProduct? product;
  const ProductDetails({Key? key, this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int average = 0;
    if (product!.reviews != null) {
      int totalValue = 0;
      for (var element in product!.reviews!) {
        totalValue += element['rating'] as int;
      }
      double averageReview =
          totalValue / product!.reviews!.length;
      average = averageReview>0? averageReview.floor():0;
    }
    return Container(
      height: MediaQuery. of(context).size.height - 40,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppBar(
            title: Text(product!.title!),
          ),
          Card(
            child: Container(
              height: MediaQuery. of(context).size.height - 110,
              padding: const EdgeInsets.all(20.0),
              alignment: Alignment.center,
              width: kIsWeb? 700:MediaQuery. of(context).size.width,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    getRow('Article Id', product!.articleId!, Colors.black),
                    const SizedBox(
                      height: 10,
                    ),
                    getRow('Title', product!.title, Colors.black),
                    const SizedBox(
                      height: 10,
                    ),
                    getRow('Total Sold', product!.totalOrders!.length.toString(), Colors.black),
                    const SizedBox(
                      height: 10,
                    ),
                    getRow('Remaining', product!.quantity!.toString(), Colors.black),
                    const SizedBox(
                      height: 10,
                    ),
                    // if()
                    getRow('Price', product!.price.toString(), Colors.black),
                    const SizedBox(
                      height: 10,
                    ),
                    getRow('Total Reviews', product!.reviews!.length.toString(), Colors.black),
                    const SizedBox(
                      height: 10,
                    ),
                    getRow('Average Review', '$average/10', Colors.black),
                    const SizedBox(
                      height: 10,
                    ),
                    const Text(
                      'Reviews',
                      style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: product!.reviews!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: Colors.blueGrey.shade100,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  getRow('Rating', product!.reviews![index]['rating'].toString(), Colors.black),
                                  const SizedBox(height:10),
                                  const Text(
                                    'Comments:',
                                    style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height:10),
                                  Text(
                                    product!.reviews![index]['review'].isEmpty?'No Comment Added':product!.reviews![index]['review'],
                                    style: const TextStyle(color: Colors.black,)
                                  ),
                                ],  
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
