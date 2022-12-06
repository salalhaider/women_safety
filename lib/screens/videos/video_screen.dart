// ignore_for_file: avoid_print

import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:women_safety_app/models/video.dart';
import 'package:women_safety_app/screens/dashboard/custom_text_field.dart';
import 'package:women_safety_app/screens/videos/video_player.dart';
import 'package:women_safety_app/utils/globals.dart';
import 'package:women_safety_app/utils/utils.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  final formKey = GlobalKey<FormState>();

  showAlert(Video? video, bool isEdit) {
    String title = '';
    ValueNotifier<String?> videoUrl = ValueNotifier(video?.videoUrl ?? '');
    Alert(
        context: context,
        title: isEdit?"Edit Video": "Add Video",
        content: Column(
          children: <Widget>[
            const SizedBox(
              height: 10,
            ),
            ValueListenableBuilder(
                valueListenable: videoUrl,
                builder: (context, url, _) {
                  return url != null && url.toString().isNotEmpty
                      ? SizedBox(
                          height: 100,
                          width: 100,
                          child: VideoApp(
                            url: url.toString(),
                            isFullScreen: false,
                          ),
                        )
                      : InkWell(
                          onTap: () async {
                            isLoadingNotifier.value = true;
                            await loadVideosWeb()
                                .then((value) => videoUrl.value = value);
                            isLoadingNotifier.value = false;
                            isLoadingNotifier.notifyListeners();
                            videoUrl.notifyListeners();
                          },
                          child: Card(
                            color: Colors.grey.shade100,
                            child: const SizedBox(
                              height: 100,
                              width: 100,
                              child: Center(
                                child: Icon(
                                  Icons.upload,
                                ),
                              ),
                            ),
                          ),
                        );
                }),
            const SizedBox(
              height: 10,
            ),
            Form(
              key: formKey,
              child: CustomTextField(
                initialValue: video?.title ?? title,
                label: 'Title',
                hint: 'Enter Title',
                onSaved: (v) {
                  if (isEdit) {
                    video!.title = v;
                  } else {
                    title = v!;
                  }
                },
                onValitdate: (v) {
                  if (v == null || v.isEmpty) {
                    return 'Title cannot be null';
                  } else {
                    return null;
                  }
                },
              ),
            ),
          ],
        ),
        buttons: [
          DialogButton(
            onPressed: () {
                  if (formKey.currentState!.validate() &&
                      videoUrl.value != null &&
                      videoUrl.value!.isNotEmpty) {
                    formKey.currentState!.save();
                    if (isEdit) {
                      videoRepo.editVideo(video!);
                    } else {
                      videoRepo.addNewVideo(Video(videoUrl.value, title));
                    }
                    Navigator.pop(context);
                  }
                },
            child: ValueListenableBuilder(
              valueListenable: isLoadingNotifier,
              builder: (context,isLoading,_) {
                return isLoading == false
                ? const Text('Save',style: TextStyle(color: Colors.white),)
                : const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ));
              }
            ),
          ),
        ]).show();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tutorials'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              if (kIsWeb)
                ValueListenableBuilder(
                    valueListenable: isLoadingNotifier,
                    builder: (context, isLoading, _) {
                      return Container(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                            onPressed: () async {
                              showAlert(null, false);
                              // if (isLoading != null && isLoading == false) {
                              // isLoadingNotifier.value = true;
                              // await loadVideosWeb();
                              // }
                              // isLoadingNotifier.value = false;
                            },
                            child: isLoading == false
                                ? const Text('Add Video')
                                : const SizedBox(
                                    height: 15,
                                    width: 15,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ))),
                      );
                    }),
              if (kIsWeb)
                const SizedBox(
                  height: 10,
                ),
              StreamBuilder(
                  stream: videoRepo.getAllVideosStream(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      QuerySnapshot qs = snapshot.data as QuerySnapshot;
                      // print(snapshot);
                      if (qs.docs.isNotEmpty) {
                        return GridView.builder(
                            shrinkWrap: true,
                            // scrollDirection: Axis.horizontal,
                            physics: NeverScrollableScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: kIsWeb ? 6 : 2,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                    mainAxisExtent: kIsWeb ? 300 : 220),
                            itemCount: qs.docs.length,
                            itemBuilder: (context, index) {
                              print(qs.docs[index].data());
                              Video video = Video.fromJson(qs.docs[index].data()
                                  as Map<String, dynamic>);
                              return Card(
                                child: GridTile(
                                    child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      Container(
                                          height: kIsWeb ? 150:100,
                                          width: kIsWeb ? 150:100,
                                          color: Colors.blueGrey.shade100,
                                          child: video.videoUrl != null &&
                                                  video.videoUrl!.isNotEmpty
                                              ? VideoApp(
                                                  url: video.videoUrl,
                                                  isFullScreen: false,
                                                )
                                              : const Icon(
                                                  Icons.play_circle_outlined,
                                                )),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Text(video.title!),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        VideoApp(
                                                          url: video.videoUrl,
                                                        )));
                                            if (kIsWeb) {
                                              // addNewProduct(_product, true);
                                            } else {}
                                          },
                                          child: const Center(
                                            child: Text('Play'),
                                          )),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      if (kIsWeb)
                                        ElevatedButton(
                                            onPressed: () {
                                              showAlert(video, true);
                                            },
                                            child: const Center(
                                              child: Text('Edit'),
                                            ))
                                    ],
                                  ),
                                )),
                              );
                            });
                      } else {
                        print('emtyyyyyy');
                        return SizedBox(
                          height: constraints.maxHeight - 80,
                          child: const Center(
                            child: Text('Sorry! No Video availabe right now'),
                          ),
                        );
                      }
                    } else if (snapshot.hasError) {
                      print(snapshot.error);
                      return const Center(
                        child: Text('Sorry! Error occured'),
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
        );
      }),
    );
  }
}
