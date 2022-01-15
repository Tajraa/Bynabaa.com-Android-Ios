import 'package:flutter/material.dart';
import 'package:progiom_cms/auth.dart';
import 'package:progiom_cms/core.dart';
import 'package:progiom_cms/ecommerce.dart';
import 'package:tajra/App/Widgets/LoginDialoge.dart';
import '/App/Widgets/MainButton.dart';
import '/Utils/AppSnackBar.dart';
import '/Utils/SizeConfig.dart';
import '/Utils/Style.dart';
import '/generated/l10n.dart';
import '/injections.dart';

import '../../constants.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final bool forPointSale;
  ProductCard({required this.product, Key? key, this.forPointSale: false})
      : super(key: key);

  @override
  _ProductCardState createState() => _ProductCardState(product);
}

class _ProductCardState extends State<ProductCard> {
  _ProductCardState(this.product);
  final Product product;
  bool loadingCart = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/productDetails",
          arguments: {"id": product.id.toString(), "goToOptions": false},
        );
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(5),
            margin: EdgeInsets.symmetric(horizontal: SizeConfig.h(6.5)),
            width: SizeConfig.h(157),
            height: SizeConfig.h(239),
            decoration: BoxDecoration(
                color: AppStyle.whiteColor,
                borderRadius: BorderRadius.circular(SizeConfig.h(10)),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0, 10),
                      blurRadius: 10,
                      color: Colors.black12)
                ]),
            child: Stack(
              children: [
                Column(
                  children: [
                    SizedBox(
                        width: SizeConfig.h(147),
                        height: SizeConfig.h(123),
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.circular(SizeConfig.h(10)),
                            child: Image.network(
                              product.coverImage ?? PlacholderImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, o, s) {
                                return Icon(Icons.warning);
                              },
                            ))),
                    SizedBox(
                      height: SizeConfig.h(8),
                    ),
                    Container(
                      height: SizeConfig.h(97),
                      padding: EdgeInsets.all(SizeConfig.h(10)),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                  child: Text(
                                product.title,
                                style: AppStyle.vexa13.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppStyle.secondaryColor,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ))
                            ],
                          ),
                          Spacer(),
                          if (widget.forPointSale)
                            Row(
                              children: [
                                Text(
                                  (product.pointsPrice ?? "").toString(),
                                  style: AppStyle.yaroCut14.copyWith(),
                                  maxLines: 1,
                                ),
                                Text(
                                  " " + S.of(context).point,
                                  style: AppStyle.yaroCut14.copyWith(),
                                  maxLines: 1,
                                ),
                                Spacer(),
                                Text(
                                  product.presalePriceText ?? "",
                                  style: AppStyle.yaroCut14.copyWith(
                                      color: AppStyle.redColor,
                                      fontFamily: AppStyle.priceFontFamily(
                                          product.presalePriceText ?? ""),
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.lineThrough),
                                  maxLines: 1,
                                )
                              ],
                            )
                          else
                            Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  product.priceText,
                                  style: AppStyle.yaroCut14.copyWith(
                                      fontFamily: AppStyle.priceFontFamily(
                                          product.priceText)),
                                  maxLines: 1,
                                )),
                                Text(
                                  product.presalePriceText ?? "",
                                  style: AppStyle.yaroCut14.copyWith(
                                      color: AppStyle.redColor,
                                      fontFamily: AppStyle.priceFontFamily(
                                          product.presalePriceText ?? ""),
                                      fontWeight: FontWeight.normal,
                                      decoration: TextDecoration.lineThrough),
                                  maxLines: 1,
                                )
                              ],
                            ),
                          Spacer(),
                          MainButton(
                              height: SizeConfig.h(30),
                              onTap: loadingCart
                                  ? () {} // not null so incoming taps will not open productDetails
                                  : () {
                                      if (product.optionsData != null &&
                                          product.optionsData!.isNotEmpty) {
                                        Navigator.pushNamed(
                                          context,
                                          "/productDetails",
                                          arguments: {
                                            "id": product.id.toString(),
                                            "goToOptions": true,
                                            "forPointsSale": widget.forPointSale
                                          },
                                        );
                                      } else {
                                        if (widget.forPointSale) {
                                          Navigator.pushNamed(
                                              context, "/checkout_points",
                                              arguments: {
                                                "total": product.pointsPrice,
                                                "product_id": product.id
                                              });
                                        } else
                                          addToCart();
                                      }
                                    },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.shopping_cart_outlined,
                                    color: AppStyle.whiteColor,
                                    size: SizeConfig.h(12),
                                  ),
                                  SizedBox(
                                    width: SizeConfig.h(5),
                                  ),
                                  Text(
                                    (widget.forPointSale)
                                        ? S.of(context).buyNow
                                        : S.of(context).addToCart,
                                    style: AppStyle.vexa11
                                        .copyWith(color: AppStyle.whiteColor),
                                  ),
                                  if (loadingCart)
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: SizeConfig.h(5),
                                        ),
                                        SizedBox(
                                          width: SizeConfig.h(10),
                                          height: SizeConfig.h(10),
                                          child: CircularProgressIndicator(
                                            strokeWidth: 1,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                    Colors.white),
                                          ),
                                        ),
                                      ],
                                    )
                                ],
                              ),
                              isOutlined: false)
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  top: SizeConfig.h(111),
                  right: AppStyle.isArabic(context) ? SizeConfig.h(4) : null,
                  left: AppStyle.isArabic(context) ? null : SizeConfig.h(110),
                  child: GestureDetector(
                    onTap: () {
                      if (sl<AuthBloc>().isGuest) {
                        showLoginDialoge(context);
                      }else
                      setIsFavorite();
                    },
                    child: Container(
                      decoration: BoxDecoration(boxShadow: [
                        BoxShadow(
                            offset: Offset(0.0, 3),
                            blurRadius: 6,
                            color: Colors.black12)
                      ], shape: BoxShape.circle, color: Colors.white),
                      width: SizeConfig.h(24),
                      height: SizeConfig.h(24),
                      child: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: Colors.red,
                          size: SizeConfig.h(16)),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  final debouncer = Debouncer(milliseconds: 1000);
  void setIsFavorite() {
    setState(() {
      product.isFavorite = !product.isFavorite;
    });

    debouncer.run(() {
      SetIsFavorite(sl()).call(SetIsFavoriteParams(
          isFavorite: product.isFavorite, itemId: product.id.toString()));
    });
  }

  void addToCart() async {
    setState(() {
      loadingCart = true;
    });

    final result = await AddToCart(sl())
        .call(AddToCartParams(productId: product.id, qty: 1));
    setState(() {
      loadingCart = false;
    });
    result.fold((l) {
      AppSnackBar.show(context, l.errorMessage, ToastType.Error);
    }, (r) {
      AppSnackBar.show(context, S.of(context).addedToCart, ToastType.Success);
    });
  }
}
