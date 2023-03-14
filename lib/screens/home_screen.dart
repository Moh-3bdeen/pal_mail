import 'package:flutter/material.dart';
import 'package:pal_mail/api/api_category_functions/get_all_categories.dart';
import 'package:pal_mail/api/api_status_functions/get_all_status.dart';
import 'package:pal_mail/api/api_tag_functions/get_all_tags.dart';
import 'package:pal_mail/api/api_user_functions/logout.dart';
import 'package:pal_mail/components/main_widgets.dart';
import 'package:pal_mail/constants.dart';
import 'package:pal_mail/models/active_list.dart';
import 'package:pal_mail/screens/all_mails_of_tag.dart';
import 'package:pal_mail/screens/login_and_signup_screen.dart';
import 'package:pal_mail/screens/new_inbox_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/api_mail_functions/get_all_mails.dart';
import '../api/api_user_functions/user_info.dart';
import '../provider/pass_data.dart';

class HomePage extends StatefulWidget {
  static const String id = "HomePage";

  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isClickOfficial = false;
  bool isClickOther = false;
  bool isClickNgos = false;
  List allStatus = [{}, {}, {}, {}];
  List allTags = [];
  List allMails = [];
  List allCategories = [];
  List<ActiveListCategory> allActiveList = [];
  Map user = {};
  bool isLogout = false;

  bool isCheckApi = false;

  void getAllData() async {
    allStatus = (await AllStatus.getAllStatus())!["statuses"];
    allTags = (await AllTags.getAllTags())["tags"];
    allMails = (await AllMails.getAllMails())["mails"]["data"];
    allCategories = (await AllCategories.getAllCategories())["categories"];
    for(var cat in allCategories){
      allActiveList.add(ActiveListCategory(cat["name"], 0, false, cat["senders"]));
    }
    Provider.of<PassAllData>(context, listen: false).putMails(allMails);
    Provider.of<PassAllData>(context, listen: false).putCategory(allCategories);
    Provider.of<PassAllData>(context, listen: false).putTags(allTags);
    user = await UserInformation.getUserInfo();
    setState(() {
      isCheckApi = true;
    });
  }

  @override
  void initState() {
    getAllData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: isLogout ? const Center(child: CircularProgressIndicator()) : ListView(
          shrinkWrap: false,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {},
                    child: CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white,
                      child: isCheckApi ? user["image"] != null ? Image.network(
                        "https://palmail.betweenltd.com/storage/${user["image"]}",
                        fit: BoxFit.cover,
                        height: 32,
                        width: 32,
                      ) : const Icon(Icons.circle, color: kMainColorDark, size: 48,) : const CircularProgressIndicator(strokeWidth: 1),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      size: 24,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      setState(() {
                        isLogout = true;
                      });
                      bool isLogin = await UserLogout.logout();
                      if(isLogin){
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.remove("userToken");
                        setState(() {
                          isLogout = false;
                        });
                        Navigator.pushReplacementNamed(context, LoginAndSignupPage.id);
                      }
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: TextField(
                onChanged: (value) {
                  // Method For Searching
                },
                decoration: const InputDecoration(
                  hintText: "Search",
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: StatusContainer(
                        status: allStatus[0],
                      ),
                    ),
                    Expanded(
                      child: StatusContainer(
                        status: allStatus[1],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: StatusContainer(
                        status: allStatus[2],
                      ),
                    ),
                    Expanded(
                      child: StatusContainer(
                        status: allStatus[3],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            for(int i = 0; i < allActiveList.length; i++)...{
              if(allActiveList[i].senders!.isNotEmpty)...{
                ActiveList(
                  title: "${allActiveList[i].name}",
                  isChecked: isCheckApi,
                  icon: allActiveList[i].isClick
                      ? Icons.keyboard_arrow_down_outlined
                      : Icons.keyboard_arrow_up,
                  iconColor: kMainColorLight,
                  onPressed: () {
                    setState(() {
                      allActiveList[i].isClick = !allActiveList[i].isClick;
                    });
                  },
                ),
                allActiveList[i].isClick
                    ? Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: ShowMailsOfCategory(
                    userImageUrl: user["image"],
                    data: allMails,
                    categoryName: allCategories[i]["name"],
                  ),
                )
                    : const SizedBox(),
              }
            },

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                "Tags",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: !isCheckApi
                  ? const Center(child: CircularProgressIndicator())
                  : Wrap(
                      children: [
                         TagContainer(tagName: "All Tags", isSelected: false, onPressed: (){}),
                        for (int i = 0; i < allTags.length; i++) ...{
                          TagContainer(tagName: "#${allTags[i]["name"]}", isSelected: false, onPressed: (){
                            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                                AllMailsOfTag(userImageUrl: user["image"], allMails: allMails, tagSelected: allTags[i]["name"])));
                          },)
                        },
                      ],
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          if(user["name"] != null) {
            Provider.of<PassAllData>(context, listen: false).passUserData(user["image"], "${user["name"]}");
            Navigator.pushNamed(context, NewInboxPage.id);
          }else {
            ScaffoldMessenger.of(context)
                .showSnackBar(
              const SnackBar(
                content: Text('Wait to get user data.'),
              ),
            );
          }
        },
        child: Container(
          padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Colors.grey.shade400))),
          child: Row(
            children: const [
              Icon(
                Icons.add_circle,
                color: Colors.blue,
                size: 32,
              ),
              SizedBox(
                width: 8,
              ),
              Text(
                "New Inbox",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
