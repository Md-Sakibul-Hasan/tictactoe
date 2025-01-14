import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../ebs/post_repository/ebs_post_repo.dart';
import '../ads/ads_controller.dart';
import '../ads/banner_ad_widget.dart';
import '../games_services/score.dart';
import '../in_app_purchase/in_app_purchase.dart';
import '../style/palette.dart';
import '../style/responsive_screen.dart';
import '../style/rough/button.dart';

class WinGameScreen extends StatefulWidget {
  final Score score;
  final String userId;
   const WinGameScreen({
    super.key,
    required this.score, required this.userId,
  });

  @override
  State<WinGameScreen> createState() => _WinGameScreenState();
}

class _WinGameScreenState extends State<WinGameScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    postScoreData();
  }
  postScoreData()async{
    print("post score from initstate");
    await EbsPostRepo.postScoreData(gameScore: widget.score.score, userId: widget.userId);
  }
  @override
  Widget build(BuildContext context) {
    // final adsControllerAvailable = context.watch<AdsController?>() != null;
    final adsRemoved =
        context.watch<InAppPurchaseController?>()?.adRemoval.active ?? false;
    final palette = context.watch<Palette>();

    const gap = SizedBox(height: 10);

    return Scaffold(
      backgroundColor: palette.backgroundPlaySession,
      body: ResponsiveScreen(
        squarishMainArea: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // if (adsControllerAvailable && !adsRemoved) ...[
            //   const Expanded(
            //     child: Center(
            //       child: BannerAdWidget(),
            //     ),
            //   ),
            // ],
            gap,
            const Center(
              child: Text(
                'You won!',
                style: TextStyle(fontFamily: 'Permanent Marker', fontSize: 50),
              ),
            ),
            gap,
            Center(
              child: Text(
                'Score: ${widget.score.score}\n'
                'Time: ${widget.score.formattedTime}',
                style: const TextStyle(
                    fontFamily: 'Permanent Marker', fontSize: 20),
              ),
            ),
          ],
        ),
        rectangularMenuArea: RoughButton(
          onTap: () {
            GoRouter.of(context).pop();
          // await EbsPostRepo.postScoreData(gameScore: widget.score.score, userId: widget.userId);
          },
          textColor: palette.ink,
          child: const Text('Continue'),
        ),
      ),
    );
  }
}
