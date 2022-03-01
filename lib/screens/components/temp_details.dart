import 'package:flutter/material.dart';
import 'package:tesla_app/constanins.dart';
import 'package:tesla_app/home_controller.dart';
import 'package:tesla_app/screens/components/tmp_btn.dart';

class TempDetails extends StatelessWidget {
  const TempDetails({
    Key? key,
    required HomeController controller,
  }) : _controller = controller, super(key: key);

  final HomeController _controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 120,
            child: Row(
              children: [
                TempBtn(
                    title: 'Cool',
                    press: _controller.updateCoolSelectedTab,
                    svgSrc: 'assets/icons/coolShape.svg',
                    isActive: _controller.isCoolSelected),
                SizedBox(width: defaultPadding,),
                TempBtn(
                    activeColor: redColor,
                    title: 'Heat',
                    press: _controller.updateCoolSelectedTab,
                    svgSrc: 'assets/icons/heatShape.svg',
                    isActive: !_controller.isCoolSelected),
              ],
            ),
          ),
          Spacer(),
          Column(
            children: [
              IconButton(onPressed: (){}, padding: EdgeInsets.zero,icon: Icon(Icons.arrow_drop_up, size: 48,),),
              Text("29" + "\u2103", style: TextStyle(fontSize: 86),),
              IconButton(onPressed: (){}, padding: EdgeInsets.zero,icon: Icon(Icons.arrow_drop_down, size: 48,),),
            ],
          ),

          Spacer(),
          Text("current temperature".toUpperCase()),
          const SizedBox(height: defaultPadding,),
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Inside".toUpperCase(),),
                  Text("20"+"\u2103", style: Theme.of(context).textTheme.headline5,)
                ],
              ),
              const SizedBox(width: defaultPadding,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Inside".toUpperCase(),style: TextStyle(color: Colors.white54),),
                  Text("35"+"\u2103", style: Theme.of(context).textTheme.headline5!.copyWith(color: Colors.white54),)
                ],
              ),
            ],
          )
        ],
      ),
    );
  }
}