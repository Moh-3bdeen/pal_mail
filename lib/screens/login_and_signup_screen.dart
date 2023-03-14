import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pal_mail/components/main_widgets.dart';
import 'package:pal_mail/constants.dart';
import 'package:pal_mail/screens/home_screen.dart';

import '../api/api_auth_functions/authentication.dart';

class LoginAndSignupPage extends StatefulWidget {
  static const String id = "LoginAndSignupPage";

  const LoginAndSignupPage({Key? key}) : super(key: key);

  @override
  State<LoginAndSignupPage> createState() => _LoginAndSignupPageState();
}

class _LoginAndSignupPageState extends State<LoginAndSignupPage>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late TabController tabController;

  String emailLogin = "";
  String passwordLogin = "";
  bool isVisibleLogin = false;

  String name = "";
  String emailSignup = "";
  String passwordSignup = "";
  bool isVisibleSignup = false;

  bool showProgress = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: 300,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [kMainColorLight, kMainColorDark],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(80),
                  bottomRight: Radius.circular(80),
                ),
              ),
            ),
            Column(
              children: [
                const SizedBox(
                  height: 24,
                ),
                Image.asset("images/icon.png"),
                const Text(
                  "Pal Mail",
                  style: TextStyle(color: Colors.white, fontSize: 28),
                ),
                const SizedBox(
                  height: 8,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.all(24),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.white),
                      borderRadius: const BorderRadius.all(Radius.circular(50)),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              elevation: 5,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white70,
                                  borderRadius: BorderRadius.circular(50),
                                ),
                                child: TabBar(
                                  labelColor: Colors.white,
                                  unselectedLabelColor: kMainColorLight,
                                  indicator: BoxDecoration(
                                    borderRadius: BorderRadius.circular(120),
                                    color: kMainColorLight,
                                  ),
                                  controller: tabController,
                                  isScrollable: true,
                                  labelPadding: const EdgeInsets.symmetric(
                                      horizontal: 48),
                                  tabs: const [
                                    Expanded(
                                      child: Tab(
                                        child: Text("Login"),
                                      ),
                                    ),
                                    Expanded(
                                      child: Tab(
                                        child: Text("SignUp"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        kSizeBoxH32,
                        Expanded(
                          child: TabBarView(
                            controller: tabController,
                            children: [
                              //
                              // Login
                              //
                              ListView(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      emailLogin = value;
                                    },
                                    decoration: kTextFieldDecoration.copyWith(
                                        hintText: 'Write your Email',
                                        prefixIcon: const Icon(Icons.email)),
                                  ),
                                  kSizeBoxH8,
                                  TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    onChanged: (value) {
                                      passwordLogin = value;
                                    },
                                    obscureText: !isVisibleLogin,
                                    decoration: kTextFieldDecoration.copyWith(
                                      hintText: 'Write your password',
                                      prefixIcon: const Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isVisibleLogin = !isVisibleLogin;
                                          });
                                        },
                                        icon: isVisibleLogin
                                            ? const Icon(
                                                Icons.visibility,
                                                color: Colors.grey,
                                              )
                                            : const Icon(
                                                Icons.visibility_off,
                                                color: Colors.grey,
                                              ),
                                      ),
                                    ),
                                  ),
                                  kSizeBoxH32,
                                  kSizeBoxH16,
                                  MainBtn(
                                      text: "Login",
                                      showProgress: showProgress,
                                      onPressed: () async {
                                        if (emailLogin.isEmpty || passwordLogin.isEmpty) {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content:
                                                  Text('Fill all fields !'),
                                            ),
                                          );
                                        } else {
                                          if (emailLogin.contains("@") && !emailLogin.startsWith("@") && !emailLogin.endsWith("@")) {
                                            if (passwordLogin.length >= 6) {
                                              setState(() {
                                                showProgress = true;
                                              });
                                              if (await Authentication.login(emailLogin, passwordLogin)) {
                                                Navigator.pushReplacementNamed(context, HomePage.id);
                                              } else {
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text('Invalid credentials.'),),
                                                );
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'The password must be at least 6 characters.'),
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'The email must be a valid email address.'),
                                              ),
                                            );
                                          }
                                        }
                                        setState(() {
                                          showProgress = false;
                                        });

                                      }),
                                ],
                              ),

                              //
                              // Sign Up
                              //

                              ListView(
                                children: [
                                  TextFormField(
                                    keyboardType: TextInputType.name,
                                    onChanged: (value) {
                                      name = value;
                                    },
                                    decoration: kTextFieldDecoration.copyWith(
                                        hintText: 'Write your name',
                                        prefixIcon:
                                            const Icon(Icons.account_circle)),
                                  ),
                                  kSizeBoxH8,
                                  TextFormField(
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      emailSignup = value;
                                    },
                                    decoration: kTextFieldDecoration.copyWith(
                                        hintText: 'Write your Email',
                                        prefixIcon: const Icon(Icons.email)),
                                  ),
                                  kSizeBoxH8,
                                  TextFormField(
                                    keyboardType: TextInputType.visiblePassword,
                                    onChanged: (value) {
                                      passwordSignup = value;
                                    },
                                    obscureText: !isVisibleSignup,
                                    decoration: kTextFieldDecoration.copyWith(
                                      hintText: 'Write your password',
                                      prefixIcon: const Icon(Icons.lock),
                                      suffixIcon: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            isVisibleSignup = !isVisibleSignup;
                                          });
                                        },
                                        icon: isVisibleSignup
                                            ? const Icon(
                                                Icons.visibility,
                                                color: Colors.grey,
                                              )
                                            : const Icon(
                                                Icons.visibility_off,
                                                color: Colors.grey,
                                              ),
                                      ),
                                    ),
                                  ),
                                  kSizeBoxH32,
                                  kSizeBoxH24,
                                  MainBtn(
                                    text: "SignUp",
                                    showProgress: showProgress,
                                    onPressed: () async {
                                      if (name.isEmpty || emailSignup.isEmpty || passwordSignup.isEmpty) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Fill all fields !')),
                                        );
                                      } else {
                                        if (emailSignup.contains("@") && !emailSignup.startsWith("@") && !emailSignup.endsWith("@")) {
                                          if (passwordSignup.length >= 6) {
                                            setState(() {
                                              showProgress = true;
                                            });
                                            if (await Authentication.signUp(name, emailSignup, passwordSignup)) {
                                              Navigator.pushReplacementNamed(
                                                  context, HomePage.id);
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                const SnackBar(
                                                  content: Text(
                                                      'The email has already been taken.'),
                                                ),
                                              );
                                            }
                                          } else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    'The password must be at least 6 characters.'),
                                              ),
                                            );
                                          }
                                        } else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'The email must be a valid email address.'),
                                            ),
                                          );
                                        }
                                      }
                                      setState(() {
                                        showProgress = false;
                                      });
                                    },
                                  ),
                                  kSizeBoxH32,
                                  kSizeBoxH8,
                                  Row(
                                    children: const [
                                      kDivider,
                                      Text(
                                        "OR",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      kDivider,
                                    ],
                                  ),
                                  kSizeBoxH24,
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      SocialMedialRegistration(
                                        icon: FontAwesomeIcons.google,
                                        onPressed: () {},
                                      ),
                                      SocialMedialRegistration(
                                        icon: FontAwesomeIcons.facebook,
                                        onPressed: () {},
                                      ),
                                      SocialMedialRegistration(
                                        icon: FontAwesomeIcons.twitter,
                                        onPressed: () {},
                                      ),
                                      SocialMedialRegistration(
                                        icon: FontAwesomeIcons.linkedinIn,
                                        onPressed: () {},
                                      ),
                                    ],
                                  ),
                                  kSizeBoxH16,
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
