import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketmate_app/controllers/product_controller.dart';
import 'package:marketmate_app/views/presentation/detail/screens/widgets/inner_banner_widget.dart';
import 'package:marketmate_app/views/presentation/detail/screens/widgets/inner_header_widget.dart';

import '../../../../../controllers/subcategory_controller.dart';
import '../../../../../models/category.dart';
import '../../../../../models/product.dart';
import '../../../../../models/subcategory.dart';
import '../../../nav_screen/widgets/reuseable_text_widget.dart';
import '../subcategory_product_screen.dart';
import 'product_item_widget.dart';
import 'subcategory_tile_widget.dart';

class InnerCategoryContentWidget extends StatefulWidget {
  final Category category;
  const InnerCategoryContentWidget({super.key, required this.category});

  @override
  State<InnerCategoryContentWidget> createState() =>
      _InnerCategoryContentWidgetState();
}

class _InnerCategoryContentWidgetState
    extends State<InnerCategoryContentWidget> {
  late Future<List<Subcategory>> _subcategories;
  final SubcategoryController _subcategoryController = SubcategoryController();
  late Future<List<Product>> featureProducts;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _subcategories = _subcategoryController
        .getSubCategoryByCategoryName(widget.category.name);
    featureProducts =
        ProductController().loadProductByCategory(widget.category.name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize:
              Size.fromHeight(MediaQuery.of(context).size.height * 20),
          child: const InnerHeaderWidget()),
      body: SingleChildScrollView(
        child: Column(
          children: [
            InnerBannerWidget(image: widget.category.banner),
            Center(
              child: Text(
                'Shop By Category',
                style: GoogleFonts.quicksand(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FutureBuilder(
                future: _subcategories,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text('Error'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No Categories'),
                    );
                  } else {
                    final subcategories = snapshot.data!;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Column(
                        children: List.generate(
                            (subcategories.length / 7).ceil(), (setIndex) {
                          //for each row, calculate the starting and ending indices
                          final start = setIndex * 7;
                          final end = (setIndex + 1) * 7;
                          return Row(
                            children: subcategories
                                .sublist(
                                    start,
                                    end > subcategories.length
                                        ? subcategories.length
                                        : end)
                                .map((subcategory) => GestureDetector(
                                  onTap: (){
                                     Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return SubcategoryProductScreen(
                                              subcategory: subcategory);
                                        }));

                                  },
                                  child: SubcategoryTileWidget(
                                      image: subcategory.image,
                                      title: subcategory.subCategoryName),
                                ))
                                .toList(),
                          );
                        }),
                      ),
                    );
                  }
                }),
            ReuseableTextWidget(title: 'Popular Product', subtitle: 'View All'),
            FutureBuilder(
                future: featureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error ${snapshot.hasError}'),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No Product under this category'),
                    );
                  } else {
                    final products = snapshot.data;
                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: products!.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            final product = products[index];
                            return ProductItemWidget(product: product);
                          }),
                    );
                  }
                })
          ],
        ),
      ),
    );
  }
}
