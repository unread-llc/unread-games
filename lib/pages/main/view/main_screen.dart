import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:unread_games/pages/wallet/view/wallet_screen.dart';
import '../../home/view/home_screen.dart';
import '../logic/main_controller.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../grid/view/grid_screen.dart';
import '../../chess/view/chess_screen.dart';
class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MainController(),
      builder: (MainController controller) {
        return Scaffold(
          body: PageView(
            onPageChanged: controller.onPageChanged,
            controller: controller.state.pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: const [
              HomeScreen(),
              WalletScreen(),
              GridScreen(),
              ChessScreen(),
            ],
          ),
          bottomNavigationBar: ObxValue(
            (currentPage) {
              return BottomNavigationBar(
              onTap: (index) {
                controller.state.pageController.jumpToPage(index);
                controller.onPageChanged(index);
              },
              showSelectedLabels: false,
              showUnselectedLabels: false,
              currentIndex: currentPage.value,
              selectedItemColor: Colors.black,       // Set your desired color
              unselectedItemColor: Colors.grey,  
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(
                      PhosphorIcons.house(
                        currentPage.value == 0
                            ? PhosphorIconsStyle.fill
                            : PhosphorIconsStyle.regular,
                      ),
                    ),
                    label: 'Home',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      PhosphorIcons.timer(
                        currentPage.value == 1
                            ? PhosphorIconsStyle.fill
                            : PhosphorIconsStyle.regular,
                      ),
                    ),
                    label: 'Wallet',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      PhosphorIcons.gameController(
                        currentPage.value == 2
                            ? PhosphorIconsStyle.fill
                            : PhosphorIconsStyle.regular,
                      ),
                    ),
                    label: 'Grid',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(
                      PhosphorIcons.book(
                        currentPage.value == 3
                            ? PhosphorIconsStyle.fill
                            : PhosphorIconsStyle.regular,
                      ),
                    ),
                    label: 'Chess',
                  ),
                ],
              );
            },
            controller.state.currentPage,
          ),
        );
      },
    );
  }
}
