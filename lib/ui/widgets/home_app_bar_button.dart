import 'package:flutter/material.dart';
import 'package:laozi_ai/res/constants.dart' as constants;
import 'package:laozi_ai/router/app_route.dart';

class HomeAppBarButton extends StatelessWidget {
  const HomeAppBarButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () => Navigator.of(context).popUntil(
          ModalRoute.withName(AppRoute.home.path),
        ),
        borderRadius: BorderRadius.circular(100),
        child: const ClipOval(
          child: CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(
              '${constants.imageAssetsPath}logo.png',
            ),
          ),
        ),
      ),
    );
  }
}
