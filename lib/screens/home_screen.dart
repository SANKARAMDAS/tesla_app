import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tesla_app/constanins.dart';
import 'package:tesla_app/home_controller.dart';
import 'package:tesla_app/models/TyrePsi.dart';
import 'package:tesla_app/screens/components/temp_details.dart';
import 'package:tesla_app/screens/components/tyres.dart';

import 'components/battery_status.dart';
import 'components/door_lock.dart';
import 'components/tesla_bottom_navigationbar.dart';
import 'components/tmp_btn.dart';
import 'components/tyre_psi_card.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final HomeController _controller = HomeController();

  late AnimationController _batteryAnimationController;
  late Animation<double> _animationBattery;
  late Animation<double> _animationBatteryStatus;
  late AnimationController _tempAnimationController;
  late Animation<double> _animationCarShift;
  late Animation<double> _animationTempShowInfo;
  late Animation<double> _animationTempCoolGlow;
  late AnimationController _tyreAnimationController;
  late Animation<double> _animationController1Psi;
  late Animation<double> _animationController2Psi;
  late Animation<double> _animationController3Psi;
  late Animation<double> _animationController4Psi;
  late List <Animation<double>> _tyreAnimation;

  void setupTyreAnimation(){
    _tyreAnimationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1200),);

    _animationController1Psi = CurvedAnimation(parent: _tyreAnimationController, curve: Interval(0.34, 0.5),);
    _animationController2Psi = CurvedAnimation(parent: _tyreAnimationController, curve: Interval(0.5, 0.66),);
    _animationController3Psi = CurvedAnimation(parent: _tyreAnimationController, curve: Interval(0.66, 0.82),);
    _animationController4Psi = CurvedAnimation(parent: _tyreAnimationController, curve: Interval(0.82, 1),);

  }

  void setupBatteryAnimation() {
    _batteryAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(microseconds: 600),
    );

    _animationBattery = CurvedAnimation(
      parent: _batteryAnimationController,
      curve: const Interval(0.0, 0.5),
    );

    _animationBatteryStatus = CurvedAnimation(
      parent: _batteryAnimationController,
      curve: const Interval(0.6, 1),
    );
  }

  void setupTempAnimation() {
    _tempAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 1500),
    );

    _animationCarShift = CurvedAnimation(
      parent: _tempAnimationController,
      curve: Interval(0.2, 0.4),
    );

    _animationTempShowInfo = CurvedAnimation(
      parent: _tempAnimationController,
      curve: Interval(0.45, 0.65),
    );

    _animationTempCoolGlow = CurvedAnimation(
      parent: _tempAnimationController,
      curve: Interval(0.7, 1),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setupTempAnimation();
    setupBatteryAnimation();
    setupTyreAnimation();
    _tyreAnimation = [
      _animationController1Psi,
      _animationController2Psi,
      _animationController3Psi,
      _animationController4Psi,
    ];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tempAnimationController.dispose();
    _batteryAnimationController.dispose();
    _tyreAnimationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([
          _controller,
          _batteryAnimationController,
          _tempAnimationController,
          _tyreAnimationController,
        ]),
        builder: (context, _) {
          print(_animationBattery.value);
          return Scaffold(
            bottomNavigationBar: TeslaBottomNavigationBar(
              onTap: (index) {
                if (index == 1)
                  _batteryAnimationController.forward();
                else if (_controller.selectedBottomTab == 1 && index != 1)
                  _batteryAnimationController.reverse(from: 0.7);
                if (index == 2)
                  _tempAnimationController.forward();
                else if (_controller.selectedBottomTab == 2 && index != 2)
                  _tempAnimationController.reverse(from: 0.4);
                if(index == 3)
                  _tyreAnimationController.forward();
                else if(_controller.selectedBottomTab == 3 && index !=3)
                  _tyreAnimationController.reverse();
                _controller.showTyreController(index);
                _controller.tyreStatusController(index);
                _controller.onButtonNavigationTabChange(index);
              },
              selectedTab: _controller.selectedBottomTab,
            ),
            body: SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) => Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                    ),
                    Positioned(
                      left: constraints.maxWidth / 2 * _animationCarShift.value,
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            vertical: constraints.maxHeight * 0.1),
                        child: SvgPicture.asset(
                          "assets/icons/Car.svg",
                          width: double.infinity,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      right: _controller.selectedBottomTab == 0
                          ? constraints.maxWidth * 0.05
                          : constraints.maxWidth / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isRightDoorLock,
                          press: _controller.updateRightDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      left: _controller.selectedBottomTab == 0
                          ? constraints.maxWidth * 0.05
                          : constraints.maxWidth / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isLeftDoorLock,
                          press: _controller.updateLeftDoorLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      top: _controller.selectedBottomTab == 0
                          ? constraints.maxHeight * 0.12
                          : constraints.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isBonnetLock,
                          press: _controller.updateBonnetLock,
                        ),
                      ),
                    ),
                    AnimatedPositioned(
                      duration: defaultDuration,
                      bottom: _controller.selectedBottomTab == 0
                          ? constraints.maxHeight * 0.17
                          : constraints.maxHeight / 2,
                      child: AnimatedOpacity(
                        duration: defaultDuration,
                        opacity: _controller.selectedBottomTab == 0 ? 1 : 0,
                        child: DoorLock(
                          isLock: _controller.isTrunkLock,
                          press: _controller.updateTrunkLock,
                        ),
                      ),
                    ),
                    Opacity(
                      opacity: _animationBattery.value,
                      child: SvgPicture.asset(
                        "assets/icons/Battery.svg",
                        width: constraints.maxWidth * 0.45,
                      ),
                    ),
                    Positioned(
                      top: 50 * (1 - _animationBatteryStatus.value),
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Opacity(
                        opacity: _animationBatteryStatus.value,
                        child: BatteryStatus(
                          constraints: constraints,
                        ),
                      ),
                    ),
                    Positioned(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      top: 60 * (1 - _animationTempShowInfo.value),
                      child: Opacity(
                        opacity: _animationTempShowInfo.value,
                        child: TempDetails(controller: _controller),
                      ),
                    ),
                    Positioned(
                      right: -180 * (1 - _animationTempCoolGlow.value),
                      child: AnimatedSwitcher(
                          duration: defaultDuration,
                          child: _controller.isCoolSelected
                              ? Image.asset(
                                  "assets/images/Cool_glow_2.png",
                                  key: UniqueKey(),
                                  width: 200,
                                )
                              : Image.asset(
                                  "assets/images/Hot_glow_4.png",
                                  key: UniqueKey(),
                                  width: 200,
                                )),
                      width: 200,
                    ),
                    if (_controller.isShowTyres) ...tyres(constraints),
                    if (_controller.isShowTyreStatus)GridView.builder(
                      itemCount: 4,
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: defaultPadding,
                          crossAxisSpacing: defaultPadding,
                          childAspectRatio:
                              constraints.maxWidth / constraints.maxHeight),
                      itemBuilder: (context, index) => ScaleTransition(
                        scale: _tyreAnimation[index],
                        child: TyrePsiCard(
                          isBottomTwoTyre: index > 1,
                          tyrePsi: demoPsiList[index],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }
}


