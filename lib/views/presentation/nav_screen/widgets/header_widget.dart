import 'package:flutter/material.dart';
import 'package:marketmate_app/views/presentation/detail/screens/search_product_screen.dart';

// class HeaderWidget extends StatelessWidget {
//   const HeaderWidget({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       child: Stack(
//         children: [
//           Image.asset(
//             'assets/icons/searchBanner.jpeg',
//             width: MediaQuery.of(context).size.width,
//             fit: BoxFit.cover,
//           ),
//           Positioned(
//               left: 48,
//               top: 68,
//               child: SizedBox(
//                 width: 250,
//                 height: 50,
//                 child: TextField(
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) {
//                       return SearchProductScreen();
//                     }));
//                   },
//                   decoration: InputDecoration(
//                       hintText: 'Enter text',
//                       hintStyle: const TextStyle(
//                           fontSize: 14, color: Color(0xFF7F7F7F)),
//                       contentPadding: const EdgeInsets.symmetric(
//                           horizontal: 12, vertical: 16),
//                       prefixIcon: Image.asset('assets/icons/searc1.png'),
//                       suffixIcon: Image.asset('assets/icons/cam.png'),
//                       fillColor: Colors.grey.shade200,
//                       filled: true),
//                 ),
//               )),
//           Positioned(
//               left: 311,
//               top: 78,
//               child: Material(
//                 type: MaterialType.transparency,
//                 child: InkWell(
//                   onTap: () {},
//                   overlayColor:
//                       WidgetStateProperty.all(const Color(0x000c7f7f)),
//                   child: Ink(
//                     width: 31,
//                     height: 31,
//                     decoration: const BoxDecoration(
//                         image: DecorationImage(
//                       image: AssetImage('assets/icons/bell.png'),
//                     )),
//                   ),
//                 ),
//               )),
//           Positioned(
//               left: 354,
//               top: 78,
//               child: Material(
//                 type: MaterialType.transparency,
//                 child: InkWell(
//                   onTap: () {},
//                   child: Ink(
//                     width: 31,
//                     height: 31,
//                     decoration: BoxDecoration(
//                         image: DecorationImage(
//                             image: AssetImage('assets/icons/message.png'))),
//                   ),
//                 ),
//               ))
//         ],
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 120,
      pinned: true,
      backgroundColor: Colors.white,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              'assets/icons/searchBanner.jpeg',
              fit: BoxFit.cover,
            ),

            /// overlay
            Container(
              color: Colors.black.withOpacity(0.2),
            ),

            /// search bar
            Positioned(
              left: 16,
              right: 16,
              bottom: 20,
              child: _SearchBar(),
            ),
          ],
        ),
      ),
    );
  }
}

  Widget _iconBtn(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: Colors.white),
    );
  }

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(30),
      elevation: 3,
      child: TextField(
        readOnly: true,
        onTap: () {
          // go search presentation
        },
        decoration: InputDecoration(
          hintText: "Search products...",
          prefixIcon: const Icon(Icons.search),
          suffixIcon: const Icon(Icons.camera_alt_outlined),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15),
        ),
      ),
    );
  }
}
