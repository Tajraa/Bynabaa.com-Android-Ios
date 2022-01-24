import 'package:flutter/material.dart';
import 'package:progiom_cms/auth.dart';
import 'package:progiom_cms/homeSettings.dart';
import 'package:tajra/Ui/BasePage/BasePage.dart';
import '../../Utils/SizeConfig.dart';
import '../../Utils/Style.dart';
import 'package:badges/badges.dart';

import '../../injections.dart';
import 'LoginDialoge.dart';

final GlobalKey searchNavKey = GlobalKey();

class CustomAppBar extends StatelessWidget {
  const CustomAppBar({Key? key, required this.isCustom, this.child})
      : assert(isCustom ? child != null : true,
            "child is null while isCustom is true!");

  final bool isCustom;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    var topPadding = MediaQuery.of(context).padding.top;
    var unreadNotifications =
        sl<HomesettingsBloc>().settings?.unreadNotifications ?? 0;
    return Container(
      padding: EdgeInsets.only(top: topPadding),
      width: double.infinity,
      height: SizeConfig.h(70 + topPadding),
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [AppStyle.secondaryDark, AppStyle.secondaryLight],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight)),
      child: !isCustom
          ? Row(
              children: [
                unreadNotifications == 0
                    ? IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color: AppStyle.secondaryColor,
                          size: SizeConfig.h(24),
                        ),
                        onPressed: () {
                          if (sl<AuthBloc>().isGuest) {
                            showLoginDialoge(context);
                          } else {
                            unreadNotifications = 0;
                            sl<HomesettingsBloc>()
                                .settings
                                ?.unreadNotifications = 0;

                            Navigator.pushNamed(context, "/notifications");
                          }
                        })
                    : Badge(
                        position: BadgePosition.topStart(
                          start: SizeConfig.h(5),
                          top: SizeConfig.h(1),
                        ),
                        badgeContent: Text(
                          unreadNotifications.toString(),
                          style: TextStyle(
                              color: Colors.white, fontSize: SizeConfig.h(11)),
                        ),
                        child: IconButton(
                            icon: Icon(
                              Icons.notifications,
                              color: AppStyle.secondaryColor,
                              size: SizeConfig.h(24),
                            ),
                            onPressed: () {
                              if (sl<AuthBloc>().isGuest) {
                                showLoginDialoge(context);
                              } else {
                                unreadNotifications = 0;
                                sl<HomesettingsBloc>()
                                    .settings
                                    ?.unreadNotifications = 0;

                                Navigator.pushNamed(context, "/notifications");
                              }
                            })),
                Spacer(),
                Image.asset(
                  "assets/logo.png",
                  width: SizeConfig.h(150),
                  height: SizeConfig.h(150),
                ),
                Spacer(),
                IconButton(
                    
                    icon: Icon(
                      Icons.search,
                      color: AppStyle.secondaryColor,
                      size: SizeConfig.h(24),
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/search");
                    }),
              ],
            )
          : child,
    );
  }
}
