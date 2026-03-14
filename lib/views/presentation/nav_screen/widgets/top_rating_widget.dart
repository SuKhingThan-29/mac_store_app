import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketmate_app/provider/top_rated_provider.dart';

import '../../../../controllers/product_controller.dart';
import '../../../../provider/product_provider.dart';
import '../../detail/screens/widgets/product_item_widget.dart';

class TopRatingWidget extends ConsumerStatefulWidget {
  const TopRatingWidget({super.key});

  @override
  _TopRatingWidgetState createState() => _TopRatingWidgetState();
}

class _TopRatingWidgetState extends ConsumerState<TopRatingWidget> {
  bool isLoading = true;
  @override
  void initState() {
    super.initState();
final products = ref.read(productProvider);
    if (products.isEmpty) {
      _fetchProduct();
    } else {
      setState(() {
        isLoading = false;
      });
    }  }

  Future<void> _fetchProduct() async {
    final ProductController _productController = ProductController();
    try {
      final products = await ProductController().loadTopRatedProduct();
      print("Products: ${products.length}");
      ref.read(topRatedProductProvider.notifier).setProduct(products);
    } catch (e) {
      print('$e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(topRatedProductProvider);
    return SizedBox(
      height: 250,
      child:isLoading?const Center(child: CircularProgressIndicator(color: Colors.blue,)): ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: products!.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            final product = products[index];
            return ProductItemWidget(product: product);
          }),
    );
  }
}
