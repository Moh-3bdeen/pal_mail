import 'package:flutter/material.dart';
import 'package:pal_mail/api/api_mail_functions/delete_mail.dart';
import 'package:pal_mail/components/main_widgets.dart';
import 'package:pal_mail/constants.dart';
import '../models/activity.dart';

class DetailsPage extends StatefulWidget {
  static const String id = "DetailsPage";

  final String? userImageUrl;
  final int? mailId;
  final String categoryName;
  final String senderName;
  final String dateSend;
  final String archiveNumber;
  final String titleMail;
  final String descriptionMail;
  final String tags;
  final String statusName;
  final String statusColor;
  final String? decision;
  final List<dynamic> imagesUrl;

  const DetailsPage({Key? key, required this.mailId, required this.userImageUrl, required this.categoryName, required this.senderName, required this.dateSend,
    required this.archiveNumber, required this.titleMail, required this.descriptionMail, required this.tags,
    required this.statusName, required this.statusColor, required this.decision, required this.imagesUrl}) : super(key: key);

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  TextEditingController activityController = TextEditingController();

  bool isClickTile = false;
  bool isClickActivity = false;
  List<Activity> activities = [];

  bool isClickDelete = false;

  @override
  Widget build(BuildContext context) {

    String allTags = "";
    for(int i = 0; i < widget.tags.length; i++){
      allTags += widget.tags[i];
    }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: isClickDelete ? const Center(child: CircularProgressIndicator()) :ListView(
          shrinkWrap: false,
          children: [
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 24,
                      color: kMainColorLight,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.more_horiz,
                      size: 24,
                      color: kMainColorLight,
                    ),
                    onPressed: () {
                      showModalBottomSheet(
                        clipBehavior: Clip.hardEdge,
                        context: context,
                        elevation: 5,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30),
                          ),
                        ),
                        builder: (context) {
                          return FractionallySizedBox(
                            heightFactor: 0.50,
                            child: Scaffold(
                              backgroundColor: kBackgroundColor,
                              body: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.titleMail,
                                          style: const TextStyle(
                                              color: Colors.black, fontSize: 16),
                                        ),
                                        IconButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.black,
                                            )),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 16,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                      children: [
                                        ActionMail(icon: Icons.archive, color: Colors.grey, text: "Archive", onPressed: (){},),
                                        kSizeBoxW8,
                                        ActionMail(icon: Icons.ios_share_outlined, color: Colors.blue, text: "Share", onPressed: (){},),
                                        kSizeBoxW8,
                                        ActionMail(icon: Icons.delete, color: Colors.red, text: "Delete", onPressed: () async {
                                          print("widget.mailId = ${widget.mailId}");
                                          if(widget.mailId != null) {
                                            Navigator.pop(context);
                                            setState(() {
                                              isClickDelete = true;
                                            });
                                            if(await DeleteMail.deleteMail(widget.mailId!)){
                                              setState(() {
                                                isClickDelete = true;
                                              });
                                              Navigator.pop(context);
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                const SnackBar(
                                                  backgroundColor: Colors.blue,
                                                  content: Text(
                                                    'Mail has been deleted',
                                                    style: TextStyle(color: Colors.white),
                                                  ),
                                                ),
                                              );
                                            }else{
                                              setState(() {
                                                isClickDelete = true;
                                              });
                                              Navigator.pop(context);
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
                                          }
                                        },),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: Column(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.person,
                                color: Colors.grey,
                              ),
                              const SizedBox(
                                width: 8,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.senderName,
                                    style: const TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                    ),
                                  ),
                                  Text(
                                    widget.categoryName,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      // fontWeight: FontWeight.bold,
                                      // fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                widget.dateSend.substring(0, 10),
                                style: const TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.archiveNumber,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  // fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: const [
                          Expanded(
                            child: Divider(
                              indent: 16,
                              color: Colors.grey,
                              thickness: 1.5,
                              endIndent: 16,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            widget.titleMail,
                            style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                                !isClickTile
                                    ? Icons.keyboard_arrow_down_outlined
                                    : Icons.keyboard_arrow_up,
                                color: Colors.black),
                            onPressed: () {
                              setState(() {
                                isClickTile = !isClickTile;
                              });
                            },
                          ),
                        ],
                      ),
                      !isClickTile
                          ? Text(
                        widget.descriptionMail,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 6,
                        style: const TextStyle(color: Colors.grey),
                      )
                          : const SizedBox(),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.numbers,
                  color: Colors.grey,
                ),
                title: Text(
                  allTags.isNotEmpty ? allTags : "No any tags",
                  style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                  ),
                ),
                trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(40)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      kSizeBoxW8,
                      const Icon(
                        Icons.question_mark,
                        color: Colors.grey,
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(int.parse(widget.statusColor)),
                          borderRadius: const BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Center(
                            child: Text(
                              widget.statusName,
                              style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                            )),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.arrow_forward_ios_outlined,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Decision",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Text(
                    "${widget.decision}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Add image",
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 17),
                  ),
                  kSizeBoxH8,
                  for(int i = 0; i < widget.imagesUrl.length; i++)...{
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            InkWell(
                              onTap: () {},
                              child: const Icon(Icons.circle_outlined, color: Colors.red, size: 32,),
                            ),
                            kSizeBoxW8,
                            Container(
                              height: 42,
                              width: 42,
                              decoration: const BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(8),
                                ),
                              ),
                              child: Center(
                                child: Image.network(
                                  "https://palmail.betweenltd.com/storage/${widget.imagesUrl[i]["image"]}",
                                  width: 42,
                                  height: 42,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            kSizeBoxW16,
                            const Text(
                              "Image",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 17,
                              ),
                            ),
                          ],
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.list,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),
                  },
                ],
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
                  prefixIcon: widget.userImageUrl != null
                      ? Image.network(
                    "https://palmail.betweenltd.com/storage/${widget.userImageUrl}",
                    fit: BoxFit.cover,
                  )
                      : const Icon(
                    Icons.circle,
                    color: kMainColorDark,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      if (activityController.text.isNotEmpty) {
                        setState(() {
                          String date = DateTime.now().toString();
                          Activity activity = Activity(
                              widget.userImageUrl,
                              widget.senderName,
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
}
