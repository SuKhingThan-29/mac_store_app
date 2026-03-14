import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:marketmate_app/views/presentation/nav_screen/widgets/banner_widget.dart';
import 'package:marketmate_app/views/presentation/nav_screen/widgets/header_widget.dart';
import 'package:marketmate_app/views/presentation/nav_screen/widgets/popular_product_widget.dart';

import '../detail/screens/widgets/category_section.dart';
import '../detail/screens/widgets/section_title.dart';
import 'widgets/top_rating_widget.dart';

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(preferredSize: Size.fromHeight(
//         MediaQuery.of(context).size.height * 0.20
//       ), child:const HeaderWidget(),
// ),
//         body: SingleChildScrollView(
//       child: Column(
//         children: [
//           const BannerWidget(),
//           const CategoryItemWidget(),
//             ReuseableTextWidget(
//             title: 'Top Rated Products',
//             subtitle: "view all",
//           ),
//           TopRatingWidget(),
//           ReuseableTextWidget(
//             title: 'Popular Products',
//             subtitle: "view all",
//           ),
//           const PopularProductWidget(),
//
//         ],
//       ),
//     ));
//   }
// }
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: CustomScrollView(
        slivers: [
          const HomeHeader(),

          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                SizedBox(height: 16),

                BannerWidget(),

                SizedBox(height: 20),

                CategorySection(),

                SizedBox(height: 20),

                SectionTitle(
                  title: 'Top Rated',
                  subtitle: 'See all',
                ),

                TopRatingWidget(),

                SizedBox(height: 20),

                SectionTitle(
                  title: 'Popular',
                  subtitle: 'See all',
                ),

                PopularProductWidget(),

                SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
