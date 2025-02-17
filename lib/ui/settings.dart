import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_svg_provider/flutter_svg_provider.dart';
import 'package:get/get.dart';

import 'package:have_you_heard/constants/colors.dart';
import 'package:have_you_heard/constants/styles.dart';
import 'package:have_you_heard/controller/game_controller.dart';
import 'package:have_you_heard/controller/setting_controller.dart';
import 'package:have_you_heard/widgets/close_game_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  static const routeName = '/settings';
  static const route = '/settings';

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool hasFocus = false;

  @override
  Widget build(BuildContext context) {
    final GameController gc = Get.find();

    final myController = TextEditingController();
    if(hasFocus==false){
      myController.text = gc.myPlayer.name;
    }

    @override
    void initState() {
      super.initState();
    }

    @override
    void dispose() {
      myController.dispose();
      super.dispose();
    }

    final appBar = AppBar(
      backgroundColor: kGrayScaleDarkest,
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text(
        'settings'.tr,
        style: HyhTextStyle.heading18Bold
      ),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.close_rounded))
      ],
    );

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final appBarHeight = AppBar().preferredSize.height;
    final statusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      appBar: appBar,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 1),
              Container(
                height: 36,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'name'.tr,
                      style: HyhTextStyle.body16Bold
                    ),
                    Expanded(
                      child: Focus(
                        onFocusChange: (focus){
                          hasFocus = focus;
                          if(hasFocus==true){
                            myController.clear();
                          } else {
                            myController.text=gc.myPlayer.name;
                          }},
                        child: TextField(
                          style: HyhTextStyle.body16,
                          textAlign: TextAlign.right,
                          controller: myController,
                          cursorColor: kGrayScaleLightest,
                          textInputAction: TextInputAction.done,
                          onTap: (){
                            myController.clear();
                          },
                          onSubmitted: (playerName) async {
                            gc.setPlayerName(playerName);
                            showSnackBar(context, 'updatedName'.tr);
                          },
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.only(bottom: 12),
                            border: InputBorder.none,
                            hintStyle: HyhTextStyle.body16
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
                color: kGrayScaleDark,
              ),
              Container(
                height: 36,
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('sound'.tr, style: HyhTextStyle.body16Bold),
                    GestureDetector(
                      onTap: (){}, //TODO: implement onTap
                      child: SvgPicture.asset('assets/images/sound.svg'),
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
                color: kGrayScaleDark,
              ),
              Container(
                height: 36,
                padding: EdgeInsets.symmetric(
                    vertical: 0.0, horizontal: screenWidth * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'country'.tr,
                      style: HyhTextStyle.body16Bold,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            gc.setLanguage('es');
                          },
                          child: SvgPicture.asset(
                            'assets/images/flagArgentina.svg',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            gc.setLanguage('pt');
                          },
                          child: SvgPicture.asset(
                            'assets/images/flagBrazil.svg',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
                color: kGrayScaleDark,
              ),
              Container(
                height: 36,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(
                    vertical: 0.0, horizontal: screenWidth * 0.05),
                child: GestureDetector(
                  onTap: (){}, //TODO: implement onTap
                  child: Text(
                    'rules'.tr,
                    style: HyhTextStyle.body16,
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
                color: kGrayScaleDark,
              ),
              Container(
                height: 36,
                alignment: Alignment.centerRight,
                padding: EdgeInsets.symmetric(
                    vertical: 0.0, horizontal: screenWidth * 0.05),
                child: GestureDetector(
                  onTap: (){
                    showDialog(
                        context: context,
                        builder: (_) => CloseGameDialog());
                  },
                  child: Text(
                    'exitGame'.tr,
                    style: HyhTextStyle.body16BoldOrange,
                  ),
                ),
              ),
              const Divider(
                thickness: 2,
                color: kGrayScaleDark,
              ),
              //TODO: Remove ElevatedButton after tests
              ElevatedButton(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('username');
                    await prefs.remove('locale');
                    showSnackBar(context, 'Configurações excluídas');
                    /*const snackBar =
                        SnackBar(content: Text());
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);*/
                  },
                  child: const Text('Limpar configurações')),
              const Spacer(flex: 4)
            ],
          ),
        ),
      ),
    );
  }
}
void showSnackBar(BuildContext context,String text) {
  final scaffold = ScaffoldMessenger.of(context);
  scaffold.showSnackBar(
    SnackBar(
      backgroundColor: kGrayScaleMediumDark,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10),
              topRight: Radius.circular(10))),
      content: Text(text,
        textAlign: TextAlign.center,
        style: HyhTextStyle.body16Bold,),
    ),
  );
}