import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketmate_app/provider/banner_provider.dart';

import '../../../../controllers/banner_controller.dart';
import '../../../../models/banner_model.dart';

// class BannerWidget extends ConsumerStatefulWidget {
//   const BannerWidget({super.key});
//
//   @override
//   _BannerWidgetState createState() => _BannerWidgetState();
// }
//
// class _BannerWidgetState extends ConsumerState<BannerWidget> {
//   @override
//   void initState() {
//     super.initState();
//     _fetchBanner();
//   }
//
//   Future<void> _fetchBanner() async {
//     final BannerController bannerController = BannerController();
//     try {
//       final banners = await bannerController.loadBanners();
//       ref.read(bannerProvider.notifier).setBanners(banners);
//     } catch (e) {
//       print('$e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final banners = ref.watch(bannerProvider);
//     return Container(
//         width: MediaQuery.of(context).size.width,
//         height: 170,
//         decoration: BoxDecoration(
//             color: Color(0xFFF7F7F7), borderRadius: BorderRadius.circular(4)),
//         child: PageView.builder(
//           itemCount:
//               banners.length, // Use itemCount to avoid index out of range
//           itemBuilder: (context, index) {
//             if (index >= banners.length) {
//               return const SizedBox(); // Safeguard against out-of-bounds access
//             }
//             final banner = banners[index];
//             return Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: ClipRRect(
//                 borderRadius: BorderRadius.circular(10),
//                 child: CachedNetworkImage(
//                   fit: BoxFit.cover,
//                   progressIndicatorBuilder: (context, url, progress) => Center(
//                     child: CircularProgressIndicator(
//                       value: progress.progress,
//                     ),
//                   ),
//                   imageUrl: banner.image,
//                 ),
//               ),
//             );
//           },
//         ));
//   }
// }

class BannerWidget extends ConsumerWidget {
  const BannerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerAsync = ref.watch(bannerProvider);

    return SizedBox(
      height: 160,
      child: bannerAsync.when(
        data: (banners) => PageView.builder(
          itemCount: banners.length,
          controller: PageController(viewportFraction: 0.9),
          itemBuilder: (_, i) {
            final banner = banners[i];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: CachedNetworkImage(
                  imageUrl: banner.image,
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => const Center(child: Text("Error")),
      ),
    );
  }
}
