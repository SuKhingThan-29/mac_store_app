import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marketmate_app/provider/vendor_product_provider.dart';
import 'package:marketmate_app/views/presentation/detail/screens/widgets/product_item_widget.dart';

import '../../../../controllers/product_controller.dart';
import '../../../../models/vendor_model.dart';
import '../../../../provider/product_provider.dart';

class VendorProductScreen extends ConsumerStatefulWidget {
  final Vendor vendor;
  const VendorProductScreen({super.key,required this.vendor});

  @override
  ConsumerState<VendorProductScreen> createState() => _VendorProductScreenState();
}

class _VendorProductScreenState extends ConsumerState<VendorProductScreen> {
  bool isLoading=true;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_){
      _fetchProductIfNeeded();
    });

  }
  Future<void> _fetchProductIfNeeded()async{
    final products = ref.read(vendorProductProvider);
    if (products.isEmpty || products.first.vendorId !=widget.vendor.id) {
      ref.read(vendorProductProvider.notifier).setVendor([]);
      _fetchProduct();
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _fetchProduct() async {
    final ProductController productController = ProductController();
    try {
      final products = await productController
          .loadVendorProduct(widget.vendor.id);
      print("SubcategoryProducts: ${products.length}");
      ref.read(vendorProductProvider.notifier).setVendor(products);
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
    final products=ref.watch(vendorProductProvider);
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
      appBar: PreferredSize(
        preferredSize:
        Size.fromHeight(MediaQuery.of(context).size.height * 0.20),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 118,
          clipBehavior: Clip.hardEdge,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/icons/cartb.png',
              ),
              fit: BoxFit.cover,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                left: 322,
                top: 52,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/icons/not.png',
                      width: 25,
                      height: 25,
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Container(
                        width: 20,
                        height: 20,
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade800,
                          borderRadius: BorderRadius.circular(
                            12,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            products.length.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Positioned(
                left: 61,
                top: 51,
                child: Text(
                  widget.vendor.fullName.toUpperCase(),
                  style: GoogleFonts.lato(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding:  EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 20,),
              widget.vendor.storeImage!.isEmpty?CircleAvatar(
                radius: 50,
                child: Text(
                  widget.vendor.fullName[0].toUpperCase(),
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                  )
                ),
              ):CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(widget.vendor.storeImage!),
              ),
              widget.vendor.storeDescription!.isEmpty?const Text(''):Text(widget.vendor.storeDescription!,
              style: GoogleFonts.montserrat(
                letterSpacing: 1.7,
                color: Colors.grey
              ),),
              SizedBox(height: 10,),
              const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
              isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : products.isEmpty?Text("No Products Found",style: GoogleFonts.montserrat(),):Padding(
                padding:  EdgeInsets.all(8.0),
                child: GridView.builder(
                  shrinkWrap: true,
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
            ],
          ),
        ),
      ),
    );
  }
}
