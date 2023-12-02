import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../common/util/images.dart';

class HeaderView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: 320,
      color: const Color(0XFFFEFFFE),
      child: Stack(
        children: <Widget>[
          Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 40,
              child: Image.asset(
                AssetsImages.banner,
                fit: BoxFit.fill,
              )),
          Positioned(
            right: 15,
            bottom: 20,
            child: SizedBox(
                width: 60,
                height: 60,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      AssetsImages.getDefaultAvatar(),
                      fit: BoxFit.cover,
                    ))),
          ),
          const Positioned(
            right: 100,
            bottom: 50,
            child: Text(
              "sunnytu",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  shadows: [Shadow(color: Colors.black, offset: Offset(1, 1))]),
            ),
          )
        ],
      ),
    );
  }
}
