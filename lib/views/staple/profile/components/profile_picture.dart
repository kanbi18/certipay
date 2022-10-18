import 'package:certipay/services/auth/auth_service.dart';
import 'package:certipay/services/auth/auth_user.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatefulWidget {
  const ProfilePicture({Key? key}) : super(key: key);

  @override
  State<ProfilePicture> createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  final user = AuthService.firebase().currentUser ?? AuthUser(false, "");
  late String profileName;
  @override
  void initState() {
    super.initState();
    profileName = user.getDisplayName;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        fit: StackFit.expand,
        clipBehavior: Clip.none,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 25),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 25,
                ),
                Text(
                  profileName,
                  style: const TextStyle(
                      color: Colors.black, fontSize: 15, fontFamily: "Serif"),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.location_on_outlined,
                      color: Colors.black,
                      size: 30,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "Random Address, Aus",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          // To add rounded image
          const Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 56,
              width: 56,
              child: CircleAvatar(
                backgroundColor: Colors.lightBlue,
              ),
            ),
          )
        ],
      ),
    );
  }
}
