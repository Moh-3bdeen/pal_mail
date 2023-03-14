import 'package:flutter/material.dart';
import 'package:pal_mail/api/api_mail_functions/create_mail.dart';
import 'package:pal_mail/api/api_tag_functions/get_all_tags.dart';
import 'package:pal_mail/models/activity.dart';
import 'package:pal_mail/models/tag.dart';
import 'package:provider/provider.dart';
import '../api/api_category_functions/get_all_categories.dart';
import '../api/api_user_functions/user_info.dart';
import '../components/main_widgets.dart';
import '../constants.dart';
import '../provider/pass_data.dart';

class NewInboxPage extends StatefulWidget {
  static const String id = "NewInboxPage";

  const NewInboxPage({Key? key}) : super(key: key);

  @override
  State<NewInboxPage> createState() => _NewInboxPageState();
}

class _NewInboxPageState extends State<NewInboxPage> {
  TextEditingController activityController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();

  TextEditingController searchController = TextEditingController();
  TextEditingController tagNameController = TextEditingController();

  TextEditingController titleMailController = TextEditingController();
  TextEditingController descriptionMailController = TextEditingController();
  TextEditingController decisionMailController = TextEditingController();

  String senderMobileSelected = "";
  String senderNameSelected = "";
  String? senderCategorySelected;
  String senderCategorySelectedName = "Other";
  List<int> selectedTagsId = [];
  String allTagsSelected = "";

  List allCategories = [];
  List<Tag> allTags = [];
  String nameWritten = "";
  bool isCheck = false;

  bool isCreateMail = false;

  void getTagsApi() async {
    List allTagsApi = (await AllTags.getAllTags()) as List;
    allTags.clear();

    for (var tag in allTagsApi) {
      allTags.add(Tag(tag["id"], tag["name"], false));
    }
    Provider.of<PassAllData>(context, listen: false).putTags(allTagsApi);
    setState(() {});
  }

  void getAllCategories() async {
    if (Provider.of<PassAllData>(context, listen: false)
        .getAllCategory()
        .isEmpty) {
      allCategories = (await AllCategories.getAllCategories())["categories"];
      isCheck = true;
      Provider.of<PassAllData>(context, listen: false).putCategory(allCategories);
    } else {
      isCheck = true;
      allCategories =
          Provider.of<PassAllData>(context, listen: false).getAllCategory();
    }
    setState(() {});
  }

  @override
  void initState() {
    getAllCategories();
    List tags = Provider.of<PassAllData>(context, listen: false).allTags;
    for (var tag in tags) {
      allTags.add(Tag(tag["id"], tag["name"], false));
    }
    super.initState();
  }

  bool isClickActivity = false;
  List<Activity> activities = [];

  @override
  Widget build(BuildContext context) {
    String? imageUrl =
        Provider.of<PassAllData>(context, listen: false).imageUrl;
    String? name = Provider.of<PassAllData>(context, listen: false).name;
    // String? senderName = Provider.of<PassAllData>(context, listen: false).senderName;
    // String? senderMobile = Provider.of<PassAllData>(context, listen: false).senderMobile;
    //
    // // String? categoryName = Provider.of<PassAllData>(context, listen: false).categoryName;
    // int? categoryId = Provider.of<PassAllData>(context, listen: false).categoryId;

    if (senderNameSelected.isNotEmpty) {
      nameController.text = senderNameSelected;
      mobileController.text = senderMobileSelected.isNotEmpty
          ? senderMobileSelected
          : mobileController.text;
    }

    print("senderCategorySelected $senderCategorySelected");
    for (var element in allCategories) {
      if ("${element["id"]}" == "$senderCategorySelected") {
        senderCategorySelectedName = element["name"];
        setState(() {});
        print("senderCategorySelectedName $senderCategorySelectedName");
      }
    }

    allTagsSelected = "";
    for (int i = 0; i < selectedTagsId.length; i++) {
      for (int j = 0; j < allTags.length; j++) {
        if (selectedTagsId[i] == allTags[j].id) {
          allTagsSelected += "#${allTags[j].name} ";
        }
      }
    }

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: isCreateMail
            ? Center(child: CircularProgressIndicator())
            : ListView(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text(
                              "Cancel",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            )),
                        const Text(
                          "New Inbox",
                          style:
                              TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        TextButton(
                            onPressed: () async {
                              if (titleMailController.text.isNotEmpty &&
                                  descriptionMailController.text.isNotEmpty) {
                                setState(() {
                                  isCreateMail = true;
                                });
                                int suerId = (await UserInformation.getUserInfo())["id"];
                                List<Map<String, dynamic>> activityList = [];
                                for (int i = 0; i < activities.length; i++) {
                                  activityList.add({
                                    "body": activities[i].activityText,
                                    "user_id": suerId
                                  });
                                }
                                // Mail mail = Mail(titleMailController.text, descriptionMailController.text,
                                //     int.tryParse(senderCategorySelected ?? "1"), "2000", DateTime.now().toString(),
                                //     decisionMailController.text, 1, null, DateTime.now().toString(), DateTime.now().toString(),
                                //     selectedTagsId, activityList);

                                print("===================================");
                                print(titleMailController.text);
                                print(descriptionMailController.text);
                                print(int.parse("$senderCategorySelected" ?? "1"));
                                print(decisionMailController.text);
                                print(selectedTagsId);
                                print(activityList);
                                print("===================================");

                                if (await CreateMail.createNewMail(
                                    titleMailController.text, descriptionMailController.text,
                                    int.parse(senderCategorySelected ?? "1"), "2000",
                                    DateTime.now().toString(), decisionMailController.text,
                                    1, decisionMailController.text, selectedTagsId, activityList)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.blue,
                                      content: Text(
                                        'Mail has been created',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                  Navigator.pop(context);
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Colors.red,
                                      content: Text(
                                        'Error',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                }
                                setState(() {
                                  isCreateMail = false;
                                });
                              }else{
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Fill all fields'),
                                  ),
                                );
                              }
                            },
                            child: const Text(
                              "Done",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 16),
                            )),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          decoration: InputDecoration(
                            hintText: 'Sender',
                            border: const UnderlineInputBorder(),
                            prefixIcon: const Icon(Icons.person),
                            prefixIconColor: Colors.grey,
                            suffixIcon: IconButton(
                                onPressed: () {
                                  allSendersBottomSheet();
                                },
                                icon: const Icon(Icons.error_outline)),
                            suffixIconColor: Colors.blue,
                          ),
                          onChanged: (value) {},
                        ),
                        TextFormField(
                          controller: mobileController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            hintText: 'Mobile',
                            border: UnderlineInputBorder(),
                            prefixIcon: Icon(Icons.phone_android),
                            prefixIconColor: Colors.grey,
                          ),
                          onChanged: (value) {},
                        ),
                        kSizeBoxH16,
                        InkWell(
                          onTap: () {
                            allCategoriesBottomSheet();
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  "Category",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                Row(children: [
                                  Text(
                                    senderCategorySelectedName,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 15,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios_outlined,
                                    color: Colors.grey,
                                  ),
                                ]),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: titleMailController,
                          decoration: const InputDecoration(
                            hintText: 'Title of mail',
                            border: UnderlineInputBorder(),
                          ),
                          onChanged: (value) {},
                        ),
                        TextFormField(
                          controller: descriptionMailController,
                          decoration: const InputDecoration(
                            hintText: 'Description',
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {},
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Column(
                      children: [
                        // Row(
                        //   children: [
                        //     const Icon(
                        //       Icons.date_range,
                        //       color: Colors.blue,
                        //     ),
                        //     const SizedBox(
                        //       width: 8,
                        //     ),
                        //     Column(
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children:[
                        //         const Text(
                        //           "Date",
                        //           style: TextStyle(color: Colors.black, fontSize: 18),
                        //         ),
                        //         Text(
                        //           "${DateTime.now()}",
                        //           style: const TextStyle(color: Colors.grey, fontSize: 16),
                        //         )
                        //       ],
                        //     ),
                        //   ],
                        // ),
                        // Row(
                        //   children: const [
                        //     Expanded(
                        //       child: Divider(
                        //         indent: 16,
                        //         color: Colors.grey,
                        //         thickness: 0.9,
                        //         endIndent: 0,
                        //       ),
                        //     ),
                        //   ],
                        // ),
                        Row(
                          children: [
                            const Icon(
                              Icons.description_rounded,
                              color: Colors.blue,
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Archive number",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18),
                                ),
                                Text(
                                  "2023 / 6019",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 16),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: InkWell(
                      onTap: () {
                        allTagsBottomSheet();
                      },
                      child: ListTile(
                        leading: const Icon(
                          Icons.numbers,
                          color: Colors.grey,
                        ),
                        title: Text(
                          allTagsSelected.isNotEmpty ? allTagsSelected : "Tags",
                          style: TextStyle(
                              color: allTagsSelected.isNotEmpty
                                  ? Colors.blue
                                  : Colors.grey,
                              fontSize: 16),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: ListTile(
                        leading: const Icon(
                          Icons.question_mark,
                          color: Colors.grey,
                        ),
                        title: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          decoration: const BoxDecoration(
                            color: Color(0xfffa3a57),
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: const Center(
                              child: Text(
                            "Inbox",
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          )),
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Decision",
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                        TextFormField(
                          controller: decisionMailController,
                          onChanged: (value) {},
                          keyboardType: TextInputType.text,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Add decision...",
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: const Text(
                      "Add image",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  ActiveList(
                    title: "Activity",
                    isChecked: true,
                    icon: isClickActivity
                        ? Icons.keyboard_arrow_down_outlined
                        : Icons.keyboard_arrow_up,
                    iconColor: kMainColorLight,
                    onPressed: () {
                      setState(() {
                        isClickActivity = !isClickActivity;
                      });
                    },
                  ),
                  !isClickActivity
                      ? Column(
                          children: [
                            for (int i = 0; i < activities.length; i++) ...{
                              ActivityContainer(
                                  imageUrl: activities[i].imageUrl,
                                  nameSender: "${activities[i].nameSender}",
                                  dateSend: "${activities[i].dateSend}",
                                  activityText:
                                      "${activities[i].activityText}"),
                            }
                          ],
                        )
                      : const SizedBox(),
                  Container(
                    margin:
                        const EdgeInsets.only(left: 16, right: 16, bottom: 8),
                    decoration: const BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                    child: TextField(
                      controller: activityController,
                      decoration: InputDecoration(
                        hintText: "Add new activity...",
                        prefixIcon: imageUrl != null
                            ? Image.network(
                                "https://palmail.betweenltd.com/storage/$imageUrl",
                                fit: BoxFit.cover,
                              )
                            : const Icon(
                                Icons.circle,
                                color: kMainColorDark,
                              ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            print(imageUrl);
                            print(name);
                            if (activityController.text.isNotEmpty) {
                              setState(() {
                                String date = DateTime.now().toString();
                                Activity activity = Activity(
                                    imageUrl,
                                    name,
                                    date.substring(0, 10),
                                    activityController.text);
                                activities.add(activity);
                                activityController.clear();
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.send,
                            color: Colors.blue,
                          ),
                        ),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void allSendersBottomSheet() {
    showModalBottomSheet(
        clipBehavior: Clip.hardEdge,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStateSheet) {
            return FractionallySizedBox(
              heightFactor: 0.92,
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Select Sender",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(
                            left: 16, right: 16, bottom: 0),
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                        child: TextField(
                          controller: searchController,
                          onChanged: (value) {
                            nameWritten = value;
                            print(nameWritten);
                            setStateSheet(() {});
                          },
                          decoration: InputDecoration(
                            hintText: "search a sender...",
                            prefixIcon: const Icon(Icons.search),
                            suffixIcon: IconButton(
                              onPressed: () {
                                searchController.clear();
                                nameWritten = "";
                                setState(() {});
                                setStateSheet(() {});
                              },
                              icon: const Icon(
                                Icons.close,
                                color: Colors.grey,
                              ),
                            ),
                            border: const OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                            ),
                          ),
                        ),
                      ),
                      kDivider,
                      InkWell(
                        onTap: () {
                          if (nameWritten.isNotEmpty) {
                            setState(() {
                              senderNameSelected = nameWritten.trim();
                              senderMobileSelected = "";
                              senderCategorySelected = "1";
                              searchController.clear();
                            });
                            nameWritten = "";
                            Navigator.pop(context);
                          }
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                nameWritten.isNotEmpty
                                    ? "\"$nameWritten\""
                                    : "",
                              ),
                            ),
                          ],
                        ),
                      ),
                      kDivider,
                      isCheck
                          ? Column(
                              children: [
                                for (int i = 0; i < allCategories.length; i++) ...{
                                  if (nameWritten.isEmpty) ...{
                                    if ((allCategories[i]["senders"] as List).isNotEmpty) ...{
                                      Row(
                                        children: [
                                          kSizeBoxW16,
                                          Text(
                                            "${allCategories[i]["name"]}",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      for (int j = 0; j < (allCategories[i]["senders"] as List).length; j++) ...{
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              senderNameSelected = "${allCategories[i]["senders"][j]["name"]}";
                                              senderMobileSelected = "${allCategories[i]["senders"][j]["mobile"]}";
                                              senderCategorySelected = "${allCategories[i]["senders"][j]["category_id"]}";
                                              searchController.clear();
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: ShowSenderList(
                                              sender: (allCategories[i]
                                                  ["senders"] as List)[j]),
                                        ),
                                      },
                                      kDivider,
                                    }
                                  } else ...{
                                    for (int j = 0; j < (allCategories[i]["senders"] as List).length; j++) ...{
                                      if ((allCategories[i]["senders"] as List)[j]["name"].toString().toUpperCase()
                                          .contains(nameWritten.trim().toUpperCase())) ...{
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              senderNameSelected = "${allCategories[i]["senders"][j]["name"]}";
                                              senderMobileSelected = "${allCategories[i]["senders"][j]["mobile"]}";
                                              senderCategorySelected ="${allCategories[i]["senders"][j]["category_id"]}";
                                              searchController.clear();
                                            });
                                            Navigator.pop(context);
                                          },
                                          child: ShowSenderList(sender: (allCategories[i]["senders"] as List)[j]),
                                        ),
                                      },
                                    },
                                  }
                                }
                              ],
                            )
                          : const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ),
            );
          });
        });
  }

  void allCategoriesBottomSheet() {
    showModalBottomSheet(
        clipBehavior: Clip.hardEdge,
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: 0.92,
            child: Scaffold(
              backgroundColor: kBackgroundColor,
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Cancel",
                                style:
                                    TextStyle(color: Colors.blue, fontSize: 16),
                              ),
                            ),
                            TextButton(
                              onPressed: () {},
                              child: const Text(
                                "Select Category",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                            // TextButton(
                            //   onPressed: () {},
                            //   child: const Text(
                            //     "Done",
                            //     style: TextStyle(color: Colors.blue, fontSize: 16),
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                      kSizeBoxH16,
                      Container(
                        margin: const EdgeInsets.only(left: 16, right: 16),
                        padding: const EdgeInsets.all(16),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: isCheck
                            ? Column(
                                children: [
                                  for (int i = 0; i < allCategories.length; i++) ...{
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          senderCategorySelected =
                                              "${allCategories[i]["id"]}";
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: ShowCategory(
                                        category: allCategories[i],
                                      ),
                                    ),
                                    kDivider,
                                  }
                                ],
                              )
                            : const CircularProgressIndicator(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  void allTagsBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        bool isAddedTag = false;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateTagsSheet) {
            return Scaffold(
              backgroundColor: kBackgroundColor,
              body: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TextButton(
                          onPressed: () {
                            selectedTagsId.clear();
                            for(var tag in allTags){
                              tag.isSelected = false;
                            }
                            Navigator.pop(context);
                            setState(() {});
                          },
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        ),
                        const Text(
                          "Select Tags",
                          style: TextStyle(color: Colors.black, fontSize: 16),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Done",
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: isAddedTag
                        ? const CircularProgressIndicator()
                        : Wrap(
                            children: [
                              for (int i = 0; i < allTags.length; i++) ...{
                                TagContainer(
                                    tagName: "#${allTags[i].name}",
                                    isSelected: allTags[i].isSelected,
                                    onPressed: (){
                                      setStateTagsSheet(() {
                                        allTags[i].isSelected = !allTags[i].isSelected;
                                        if (allTags[i].isSelected) {
                                          selectedTagsId.add(allTags[i].id!);
                                        } else {
                                          selectedTagsId.remove(allTags[i].id!);
                                        }
                                        setState(() {});
                                      });
                                    },
                                )
                              },
                            ],
                          ),
                  ),
                  // Container(
                  //   margin: const EdgeInsets.all(16),
                  //   decoration: const BoxDecoration(
                  //     color: Colors.white70,
                  //     borderRadius: BorderRadius.all(Radius.circular(50)),
                  //   ),
                  //   child: TextField(
                  //     controller: tagNameController,
                  //     decoration: InputDecoration(
                  //       hintText: "Add tag...",
                  //       suffixIcon: IconButton(
                  //         onPressed: () async {
                  //           setStateTagsSheet((){
                  //             isAddedTag = true;
                  //           });
                  //           if(tagNameController.text.trim().isNotEmpty){
                  //             if(await CreateTag.createNewTag(tagNameController.text.trim())){
                  //               tagNameController.clear();
                  //               ScaffoldMessenger.of(context).showSnackBar(
                  //                 const SnackBar(
                  //                   backgroundColor: Colors.blue,
                  //                   content: Text('Tag is created', style: TextStyle(color: Colors.white),),
                  //                 ),
                  //               );
                  //               setStateTagsSheet((){
                  //                 getTagsApi();
                  //               });
                  //             }else{
                  //               ScaffoldMessenger.of(context).showSnackBar(
                  //                 const SnackBar(
                  //                   backgroundColor: Colors.red,
                  //                   content: Text('Add failed!', style: TextStyle(color: Colors.white),),
                  //                 ),
                  //               );
                  //             }
                  //           }
                  //           setStateTagsSheet((){
                  //             isAddedTag = false;
                  //           });
                  //         },
                  //         icon: const Icon(
                  //           Icons.send,
                  //           color: Colors.blue,
                  //         ),
                  //       ),
                  //       border: const OutlineInputBorder(
                  //         borderRadius: BorderRadius.all(Radius.circular(50)),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
