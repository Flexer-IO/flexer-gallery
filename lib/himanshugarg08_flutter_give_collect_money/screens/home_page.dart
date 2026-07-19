import 'package:flutter/material.dart';
import '../models/user.dart';
import '../utils/utils.dart';
import '../widgets/app_tile.dart' hide verticalSpace;
import '../widgets/revolving_user_widget.dart';
import '../widgets/user_avatar.dart';
import '../widgets/user_info_card.dart' hide verticalSpace;

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      //bottom: Platform.isAndroid ? true : false,
      top: false,
      bottom: false,
      left: false,
      right: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: [
                verticalSpace(60),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          horizontalSpace(4),
                          UserAvatar(user: UserList.users.first),
                        ],
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.notifications_none_rounded,
                            size: 28,
                          ),
                          horizontalSpace(16),
                          const Icon(
                            Icons.more_vert_rounded,
                            size: 28,
                          ),
                          horizontalSpace(16),
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 20.0),
                  child: UserInfoCard(size: size),
                ),
                verticalSpace(8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    AppTile(
                      label: "Payment",
                      message: "Transfer to ",
                      lottieAssetPath:
                          "packages/showcase_library/assets/himanshugarg08_flutter_give_collect_money/payment.json",
                    ),
                    AppTile(
                      label: "Collect money",
                      message: "Request from ",
                      lottieAssetPath:
                          "packages/showcase_library/assets/himanshugarg08_flutter_give_collect_money/collect_money.json",
                    ),
                  ],
                ),
                verticalSpace(16),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    children: const [
                      Text(
                        "Recently traded:",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const Expanded(child: SizedBox()),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Transform.translate(
                offset: Offset(0, size.height / 4),
                child: const RevolvingUserWidget(),
              ),
            )
          ],
        ),
      ),
    );
  }
}