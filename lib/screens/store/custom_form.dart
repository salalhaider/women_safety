import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:women_safety_app/models/product.dart';
import 'package:women_safety_app/screens/dashboard/custom_text_field.dart';
import 'package:women_safety_app/utils/globals.dart';
import 'package:women_safety_app/utils/utils.dart';

class NewProductForm extends StatefulWidget {
  StoreProduct? product;
  bool isEditForm;
  NewProductForm({Key? key, this.product, this.isEditForm = false})
      : super(key: key);

  @override
  State<NewProductForm> createState() => _NewProductFormState();
}

class _NewProductFormState extends State<NewProductForm> {
  StoreProduct? product;
  StoreProduct? newProduct;
  String? articleId, category, title, photo;
  int? quantity, price;
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  @override
  void initState() {
    product = widget.product;
    newProduct = widget.product;
    photo = widget.product?.productPhoto;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 700,
      child: Form(
        key: formKey,
        child: ListView(
          children: [
            StatefulBuilder(builder: (context, setBodyState) {
              return Container(
                height: 150,
                width: 150,
                alignment: Alignment.center,
                child: photo != null && photo != ''
                    ? isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.blueGrey,
                          )
                        : InkWell(
                            onTap: () async {
                              setBodyState(() {
                                isLoading = true;
                              });
                              String? url = await loadAssetsWeb();
                              print('-------- url -------->>> $url');
                              print('-------- url  2 -------->>> $url');
                              if (url != null && url.isNotEmpty) {
                                print('---- url ----- not null -->$url');
                                setBodyState(() {
                                  newProduct!.productPhoto = url;
                                  photo = url;
                                  isLoading = false;
                                });
                              } else {
                                setBodyState(() {
                                  isLoading = false;
                                });
                              }
                            },
                            child: ClipOval(
                              child: SizedBox(
                                height: 100,
                                width: 100,
                                child: CachedNetworkImage(
                                  imageUrl: photo!,//newProduct!.productPhoto!,
                                ),
                              ),
                            ),
                          )
                    : InkWell(
                        onTap: () async {
                          // loadAssets();
                          setBodyState(() {
                            isLoading = true;
                          });
                          String? url = await loadAssetsWeb();
                          print('-------- url -------->>> $url');
                          if (url != null && url.isNotEmpty) {
                            print('---- url ----- not null -->$url');
                            setBodyState(() {
                              // newProduct!.productPhoto = url;
                              photo = url;
                              isLoading = false;
                            });
                          } else {
                            setBodyState(() {
                              isLoading = false;
                            });
                          }
                        },
                        child: ClipOval(
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: const BoxDecoration(
                              // borderRadius: BorderRadius.all(Radius.circular(50)),
                              color: AppColors.boxHighlight,
                            ),
                            child: Center(
                              child: Stack(
                                children: [
                                  const Align(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.shopping_bag_outlined,
                                      size: 80,
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.bottomCenter,
                                    child: Container(
                                      // margin: EdgeInsets.only(bottom: 9),
                                      decoration: const BoxDecoration(
                                        // borderRadius: BorderRadius.only(
                                        //   bottomLeft: Radius.circular(40),
                                        //   bottomRight: Radius.circular(40),
                                        // ),
                                        color: AppColors.primaryColor,
                                      ),
                                      // alignment: Alignment.bottomCenter,
                                      child: const Icon(
                                        Icons.edit,
                                        size: 20,
                                        color: Colors.white,
                                      ),

                                      height: 30,
                                      width: 100,
                                    ),
                                  ),
                                  // Align(
                                  //     alignment: Alignment.bottomCenter,
                                  //     child: Container(
                                  //       height: 20,
                                  //       color: Colors.white,
                                  //       alignment: Alignment.bottomCenter,
                                  //       child: Text('ADD'),
                                  //     ))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
              );
            }),
            // CustomTextField(
            //   label: 'Article Id',
            //   hint: 'Enter article id',
            //   initialValue: product?.articleId ?? '',
            //   onSaved: (v) {
            //     if (v != null) {
            //       articleId = v.trim();
            //     }
            //   },
            //   onValitdate: (v) {
            //     if (v == null || v.isEmpty) {
            //       return 'Field cannot be null';
            //     } else {
            //       return null;
            //     }
            //   },
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            CustomTextField(
              label: 'Title',
              hint: 'Enter title',
              initialValue: product?.title ?? '',
              onSaved: (v) {
                if (v != null) {
                  title = v.trim();
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
            const SizedBox(
              height: 10,
            ),
            // CustomTextField(
            //   label: 'Category',
            //   hint: 'Enter category',
            //   initialValue: product?.category ?? '',
            //   onSaved: (v) {
            //     if (v != null) {
            //       category = v.trim();
            //     }
            //   },
            //   onValitdate: (v) {
            //     if (v == null || v.isEmpty) {
            //       return 'Field cannot be null';
            //     } else {
            //       return null;
            //     }
            //   },
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            CustomTextField(
              label: 'Price',
              hint: 'Enter Price',
              initialValue: product?.price?.toString() ?? '',
              keyboardType: TextInputType.number,
              onSaved: (v) {
                if (v != null) {
                  price = int.parse(v.trim());
                }
              },
              onValitdate: (v) {
                if (v == null || v.isEmpty) {
                  return 'Field cannot be null';
                } else if (v.contains(RegExp(r'[a-z]'))) {
                  return 'Field must contains number only';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 10,
            ),
            CustomTextField(
              label: 'Quantity',
              hint: 'Enter quantity',
              initialValue: product?.quantity?.toString() ?? '',
              keyboardType: TextInputType.number,
              onSaved: (v) {
                if (v != null) {
                  quantity = int.parse(v.trim());
                }
              },
              onValitdate: (v) {
                if (v == null || v.isEmpty) {
                  return 'Field cannot be null';
                } else if (v.contains(RegExp(r'[a-z]'))) {
                  return 'Field must contains number only';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      // loginUser();
                      if (formKey.currentState!.validate()) {
                        formKey.currentState!.save();
                        if (widget.isEditForm && product != null) {
                          StoreProduct tempProduct = StoreProduct(
                              title,
                              articleId,
                              photo,
                              quantity,
                              true,
                              price,
                              product!.isDisable,
                              product!.reviews ?? []);
                          tempProduct.id = product!.id;
                          productRepo.editProduct(tempProduct).then((value) {
                            if (value) {
                              showSnackBar(context, 'Product Updated');
                              Navigator.pop(context);
                            }
                          });
                        } else {
                          productRepo
                              .addNewProduct(StoreProduct(title, articleId,
                                  photo, quantity, true, price, false, []))
                              .then((value) {
                            if (value) {
                              showSnackBar(context, 'Product Updated');
                              Navigator.pop(context);
                            }
                          });
                        }
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        width: 100,
                        child: Center(
                            child: Text(widget.isEditForm ? 'Update' : 'Add')),
                      ),
                    )),
                if (widget.isEditForm)
                  const SizedBox(
                    width: 10,
                  ),
                if (widget.isEditForm)
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red)),
                      onPressed: () {
                        productRepo.deleteProduct(product!).then((value) {
                          if (value) {
                            showSnackBar(context, 'Product Deleted');
                            Navigator.pop(context);
                          }
                        });
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: SizedBox(
                          width: 100,
                          child: Center(child: Text('Delete')),
                        ),
                      )),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
