import 'package:flutter/material.dart';
import '../components/main_widgets.dart';
import '../constants.dart';
import 'details_screen.dart';

class AllMailsOfTag extends StatelessWidget {
  final String? userImageUrl;
  final List allMails;
  final String tagSelected;
  const AllMailsOfTag({Key? key, required this.userImageUrl, required this.allMails, required this.tagSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        child: ListView(
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
                    onPressed: (){},
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "All mails contains #$tagSelected tag",
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 18),
                )
              ],
            ),
            kSizeBoxH16,
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < allMails.length; i++) ...{
                    if((allMails[i]["tags"] as List).isNotEmpty)...{
                      for(int j = 0; j < (allMails[i]["tags"] as List).length; j++)...{
                        if (allMails[i]["tags"][j]["name"] == tagSelected) ...{
                          InkWell(
                            onTap: () {
                              String tags = "";
                              for(int j = 0; j < (allMails[i]["tags"] as List).length; j++){
                                tags += "#${(allMails[i]["tags"] as List)[j]["name"]} ";
                              }
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailsPage(
                                    userImageUrl: userImageUrl,
                                    mailId: allMails[i]["id"],
                                    categoryName: allMails[i]["category"]["name"],
                                    senderName: allMails[i]["sender"]["name"],
                                    dateSend: allMails[i]["updated_at"],
                                    archiveNumber: allMails[i]["archive_number"],
                                    titleMail: allMails[i]["subject"],
                                    descriptionMail: allMails[i]["description"],
                                    tags: tags,
                                    statusName: allMails[i]["status"]["name"],
                                    statusColor: allMails[i]["status"]["color"],
                                    decision: allMails[i]["decision"],
                                    imagesUrl: allMails[i]["attachments"],
                                  ),
                                ),
                              );
                            },
                            child: ShowMessageSends(
                              containerColor: Color(int.parse(allMails[i]["status"]["color"])),
                              organizationName: "${allMails[i]["sender"]["name"]}",
                              dateSend: allMails[i]["updated_at"].toString().substring(0, 10),
                              subject: "${allMails[i]["subject"]}",
                              message: "${allMails[i]["description"]}",
                              colorMessage: Colors.blue,
                            ),
                          ),
                          if ((allMails[i]["tags"] as List).isNotEmpty) ...{
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                              child: Wrap(
                                children: [
                                  for (int j = 0;
                                  j < (allMails[i]["tags"] as List).length;
                                  j++) ...{
                                    Text(
                                      "#${allMails[i]["tags"][j]["name"]}  ",
                                      style:
                                      const TextStyle(color: Colors.blue, fontSize: 16),
                                    )
                                  },
                                ],
                              ),
                            ),
                          },
                          if ((allMails[i]["attachments"] as List).isNotEmpty) ...{
                            Padding(
                              padding:
                              const EdgeInsets.symmetric(vertical: 4, horizontal: 24),
                              child: Wrap(
                                children: [
                                  for (int x = 0; x < (allMails[i]["attachments"] as List).length; x++) ...{
                                    ShowImage(
                                        onPressed: () {},
                                        imageUrl:
                                        "${(allMails[i]["attachments"] as List)[x]["image"]}"),
                                    const SizedBox(
                                      width: 2,
                                    ),
                                  },
                                ],
                              ),
                            ),
                          },
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            child: kDivider,
                          )
                        }
                      }

                    },
                  },
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
