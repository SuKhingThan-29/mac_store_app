import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketmate_app/models/subcategory.dart';
import 'package:marketmate_app/provider/subcategory_product_provider.dart';
import 'package:marketmate_app/views/presentation/detail/screens/widgets/product_item_widget.dart';

import '../../../../controllers/product_controller.dart';
import '../../../../provider/product_provider.dart';

class SubcategoryProductScreen extends ConsumerStatefulWidget {
  final Subcategory subcategory;
  const SubcategoryProductScreen({super.key, required this.subcategory});

  @override
  ConsumerState<SubcategoryProductScreen> createState() =>
      _SubcategoryProductScreenState();
}

class _SubcategoryProductScreenState
    extends ConsumerState<SubcategoryProductScreen> {
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
    }
  }

  Future<void> _fetchProduct() async {
    final ProductController _productController = ProductController();
    try {
      final products = await ProductController()
          .loadProducteBySubCategory(widget.subcategory.subCategoryName);
      print("SubcategoryProducts: ${products.length}");
      ref.read(subcategoryProductProvider.notifier).setProduct(products);
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
    final products = ref.watch(subcategoryProductProvider);
    final screenWidth = MediaQuery.of(context).size.width;

    //set the number of column in grid base on the presentation width
    //if the presentation width is less than 600 pixels(e.g. a phone) use columns
    //if the presentation width is 600 pixels or more (e.g. a tablet) use 4 columns
    final crossAxisCount = screenWidth < 600 ? 2 : 4;
    //set the aspect ratio(width-to-height ratio)of each grid item base on the presentation width

    //for smaller presentation(<600 pixels) use a ratio of 3.4(taller items)

    //for larget presentation(>=600 pixels), use a ratio of 4.5(more square-shaped items)

    final childAspectRatio = screenWidth < 600 ? 3 / 4 : 4 / 5;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.subcategory.subCategoryName),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
                itemCount: products.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: childAspectRatio,
                    mainAxisSpacing: 8,
                    crossAxisSpacing: 8),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return ProductItemWidget(product: product);
                }),
          ),
    );
  }
}
