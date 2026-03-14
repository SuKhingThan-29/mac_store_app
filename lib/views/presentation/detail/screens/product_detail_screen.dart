import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketmate_app/provider/favorite_provider.dart';
import 'package:marketmate_app/provider/related_product_provider.dart';

import '../../../../controllers/product_controller.dart';
import '../../../../models/product.dart';
import '../../../../provider/cart_provider.dart';
import '../../../../services/manage_http_response.dart';
import '../../nav_screen/widgets/reuseable_text_widget.dart';
import 'widgets/product_item_widget.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  ProductDetailScreen({super.key, required this.product});
  final Product product;

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen> {
  @override
  void initState() {
    super.initState();
    _fetchProduct();
  }

  Future<void> _fetchProduct() async {
    final ProductController _productController = ProductController();
    try {
      final products = await ProductController()
          .loadRelatedProducteBySubCategory(widget.product.id);
      print("RelatedProducts: ${products.length}");
      ref.read(relatedProductProvider.notifier).setProduct(products);
    } catch (e) {
      print('$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final relatedProducts = ref.watch(relatedProductProvider);
    final _cartProvider = ref.read(cartProvider.notifier);
    final favoriteProviderData = ref.read(favoriteProvider.notifier);
    ref.watch(favoriteProvider);
    final cardData = ref.watch(cartProvider);
    final isInCard = cardData.containsKey(widget.product.id);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Product Detail',
          style:
              GoogleFonts.quicksand(fontSize: 18, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                favoriteProviderData.addProductToFavorite(
                    productName: widget.product.productName,
                    productPrice: widget.product.productPrice,
                    category: widget.product.category,
                    image: widget.product.images,
                    vendorId: widget.product.vendorId,
                    productQuantity: widget.product.quality,
                    quantity: 1,
                    productId: widget.product.id,
                    description: widget.product.description,
                    fullName: widget.product.fullName);
                showSnackBar(context, "added ${widget.product.productName}");
              },
              icon: favoriteProviderData.getFavoriteItems
                      .containsKey(widget.product.id)
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(Icons.favorite_border))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 260,
                height: 275,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                        left: 0,
                        top: 50,
                        child: Container(
                          width: 260,
                          height: 260,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: const Color(0xFFD8DDF),
                              borderRadius: BorderRadius.circular(130)),
                        )),
                    Positioned(
                        left: 22,
                        top: 0,
                        child: Container(
                          width: 216,
                          height: 274,
                          clipBehavior: Clip.hardEdge,
                          decoration: BoxDecoration(
                              color: Color(0xFF0CA8FF),
                              borderRadius: BorderRadius.circular(14)),
                          child: SizedBox(
                            height: 300,
                            child: PageView.builder(
                                itemCount: widget.product.images!.length,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return Image.network(
                                    widget.product.images![index],
                                    width: 198,
                                    height: 225,
                                    fit: BoxFit.cover,
                                  );
                                }),
                          ),
                        ))
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.product.productName!,
                    style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Color(0xFF3C55Ef)),
                  ),
                  Text(
                    "\$${widget.product.productPrice}",
                    style: GoogleFonts.roboto(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF3C55Ef)),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.product.category!,
                style: GoogleFonts.roboto(
                    color: Colors.grey,
                    fontSize: 16,
                    fontWeight: FontWeight.w700),
              ),
            ),
            widget.product.totalRating == 0
                ? const Text('')
                : Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        Text(
                          widget.product.averageRating.toString(),
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.bold),
                        ),
                        Text("(${widget.product.totalRating})")
                      ],
                    ),
                  ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About',
                    style: GoogleFonts.lato(
                        fontSize: 17,
                        letterSpacing: 1.7,
                        color: Color(0xFF363330)),
                  ),
                  Text(
                    widget.product.description!,
                    style: GoogleFonts.mochiyPopOne(
                        letterSpacing: 1.7, fontSize: 15),
                  ),
                  ReuseableTextWidget(title: 'Related Product', subtitle: ''),
                  SizedBox(
                    height: 250,
                    child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: relatedProducts.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final relatedProduct = relatedProducts[index];
                          return ProductItemWidget(product: relatedProduct);
                        }),
                  ),
                  SizedBox(height: 60,)
                ],
              ),
            )
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8),
        child: InkWell(
          onTap: isInCard
              ? null
              : () {
                  _cartProvider.addProductToCart(
                    productName: widget.product.productName,
                    productPrice: widget.product.productPrice,
                    category: widget.product.category,
                    image: widget.product.images,
                    vendorId: widget.product.vendorId,
                    productQuantity: widget.product.quality,
                    quantity: 1,
                    productId: widget.product.id,
                    description: widget.product.description,
                    fullName: widget.product.fullName,
                  );
                  showSnackBar(context, "${widget.product.productName}");
                },
          child: Container(
            width: 386,
            height: 46,
            clipBehavior: Clip.hardEdge,
            decoration: BoxDecoration(
                color: isInCard ? Colors.grey : Color(0xFF3B54EE),
                borderRadius: BorderRadius.circular(15)),
            child: Center(
              child: Text(
                "ADD TO CART",
                style: GoogleFonts.mochiyPopOne(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
