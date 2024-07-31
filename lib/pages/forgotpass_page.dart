import 'package:buyandsell/widgets/signin.dart';
import 'package:flutter/material.dart';
import 'package:buyandsell/widgets/itemcard.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ForgotpassPage extends StatefulWidget {
  const ForgotpassPage({super.key, required this.mode});
  final String mode;

  @override
  State<ForgotpassPage> createState() => _ForgotpassPageState();
}

class _ForgotpassPageState extends State<ForgotpassPage> {
  @override
  Widget build(BuildContext context) {
    Itemcard itemCard = Itemcard(mode: 'dark', cardsperrow: 1);

    Color logocolor = itemCard.mode == 'dark'
        ? Color.fromARGB(255, 248, 248, 248)
        : Color.fromARGB(255, 4, 14, 30);

    return SafeArea(
      child: Scaffold(
        backgroundColor: widget.mode == 'dark'
            ? Color.fromARGB(255, 3, 14, 34)
            : Color.fromARGB(255, 248, 248, 248),
        body: Center(
          child: Container(
            margin: const EdgeInsets.all(0.0),
            padding: const EdgeInsets.all(0.0),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      child: SvgPicture.asset(
                        'lib/Assets/Images/logo.svg',
                        colorFilter:
                            ColorFilter.mode(logocolor, BlendMode.srcIn),
                      ),
                    ),
                    SignIn(mode: widget.mode).forgotPass(context),
                    SizedBox(
                      height: 10,
                    ),
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 370,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Container(
                              child: InkWell(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text(
                                      'Sign Up',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontFamily: 'Nunito',
                                        fontWeight: FontWeight.w700,
                                        color: Colors.blue,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Colors.blue,
                                    )
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/signup');
                                },
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              child: InkWell(
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'Sign In',
                                        textAlign: TextAlign.right,
                                        style: TextStyle(
                                          fontFamily: 'Nunito',
                                          fontWeight: FontWeight.w700,
                                          color: Colors.blue,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios,
                                      size: 14,
                                      color: Colors.blue,
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/signin');
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
