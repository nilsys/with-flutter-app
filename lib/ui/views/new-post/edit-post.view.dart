import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:with_app/core/models/post.model.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/view_models/camera.vm.dart';
import 'package:with_app/core/view_models/layout.vm.dart';
import 'package:with_app/core/view_models/story.vm.dart';
import 'package:with_app/ui/shared/all.dart';
import 'package:with_app/ui/views/camera/camera2.view.dart';

final NavigationService navService = NavigationService();

class EditPostView extends StatefulWidget {
  final Story story;
  final String postId;

  EditPostView({
    @required this.story,
    this.postId,
  });

  @override
  _EditPostViewState createState() => _EditPostViewState();
}

class _EditPostViewState extends State<EditPostView> {
  final LayoutVM layoutProvider = locator<LayoutVM>();

  final StoryVM storyProvider = locator<StoryVM>();

  final TextEditingController postTitleController = TextEditingController(
      // text: storyProvider.getPostById(widget.postId).title,
      );

  final TextEditingController postDescController = TextEditingController();

  final CameraVM cameraProvider = locator<CameraVM>();

  final ScrollController scrollController = ScrollController();

  final picker = ImagePicker();

  bool _isWorking = false;

  List<String> _media = [];
  List<String> _deleteMedia = [];

  @override
  void initState() {
    super.initState();
    Post post = storyProvider.getPostById(widget.postId);
    postTitleController.text = post.title;
    postDescController.text = post.text;
    _media = post.media;
  }

  @override
  void didChangeDependencies() {
    Provider.of<CameraVM>(context, listen: true);
    super.didChangeDependencies();
  }

  void _notEnough() {
    Toaster(
      type: 'error',
      title: 'That\'s not enough...',
      icon: Icon(Icons.error),
      content: Text(
          'You must provide at least a title, or a body, or a media item.'),
    )..show(context);
  }

  void _trySubmit() async {
    FocusScope.of(context).unfocus();
    setState(() {
      _isWorking = true;
    });
    try {
      if (widget.postId != null) {
        await storyProvider.editPost(
            widget.postId,
            new Post(
              timestamp: DateTime.now(),
              title: postTitleController.value.text.trim(),
              text: postDescController.value.text.trim(),
              media: _media,
            ),
            cameraProvider.filePath,
            _deleteMedia);
      } else {
        await storyProvider.addPost(
            new Post(
              timestamp: DateTime.now(),
              title: postTitleController.value.text.trim(),
              text: postDescController.value.text.trim(),
            ),
            cameraProvider.filePath);
      }
      navService.goBack();
    } on PlatformException catch (err) {
      print(err);
    } catch (err) {
      print(err);
      setState(() {
        _isWorking = false;
      });
      Toaster(
        title: 'Facebook Login',
        icon: Icon(Icons.error),
        content: Text('Oops! somthing went wrong...'),
      )..show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    print('storyProvider.story.id: ${storyProvider.story.id}');

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (cameraProvider.filePath.length > 0) {
        scrollController.jumpTo(scrollController.position.maxScrollExtent);
      }
    });

    Future _getImageFromGallery() async {
      var pickedFile = await picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 50, // do 100 for max quality
      );
      if (pickedFile != null) {
        cameraProvider.storeFilePath(pickedFile.path);
      }
    }

    @swidget
    Widget topNav() {
      return Container(
        margin: EdgeInsets.only(top: layoutProvider.gutter / 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.only(left: layoutProvider.gutter - 8),
              child: TextButton(
                onPressed: () {
                  navService.goBack();
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: layoutProvider.gutter - 8),
              child: TextButton(
                onPressed: () {
                  final titleIsValid =
                      postTitleController.value.text.trim().length > 0;
                  final descIsValid =
                      postDescController.value.text.trim().length > 0;
                  final meidaIsValid = cameraProvider.filePath.length > 0;
                  if (titleIsValid || descIsValid || meidaIsValid) {
                    _trySubmit();
                  } else {
                    _notEnough();
                  }
                },
                child: Text('Share'),
              ),
            ),
          ],
        ),
      );
    }

    @swidget
    Widget storyHeader() {
      const imgWidth = 72.0;
      return Container(
        margin: EdgeInsets.only(bottom: layoutProvider.gutter * 1.5),
        padding: EdgeInsets.symmetric(
            vertical: layoutProvider.gutter, horizontal: layoutProvider.gutter),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.black.withAlpha(70)),
          ),
        ),
        child: Row(
          children: [
            this.widget.story.cover != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      this.widget.story.cover,
                      fit: BoxFit.cover,
                      width: imgWidth,
                      height: imgWidth,
                    ),
                  )
                : SizedBox(),
            Container(
              width: MediaQuery.of(context).size.width -
                  imgWidth -
                  (layoutProvider.gutter * 3),
              margin: EdgeInsets.only(left: layoutProvider.gutter),
              padding: EdgeInsets.only(right: layoutProvider.gutter),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    this.widget.story.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: Theme.of(context)
                        .textTheme
                        .headline1
                        .copyWith(fontSize: 18.0),
                  ),
                  Opacity(
                    opacity: 0.5,
                    child: Row(
                      children: [
                        Icon(Icons.lock, size: 16.0),
                        Container(
                            margin: EdgeInsets.only(
                              left: layoutProvider.gutter / 2,
                            ),
                            child: Text('Family & Friends')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    @swidget
    Widget postTitle() {
      return TextField(
        // key: key,
        autofocus: false,
        onTap: () {},
        controller: postTitleController,
        maxLines: null,
        cursorHeight: 29,
        cursorColor: Colors.black,
        style: Theme.of(context).textTheme.headline1,
        decoration: InputDecoration(
          contentPadding:
              EdgeInsets.symmetric(horizontal: layoutProvider.gutter),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: 'Post Title',
          fillColor: Colors.transparent,
          hintStyle: Theme.of(context).textTheme.headline1.copyWith(
                color: Theme.of(context)
                    .textTheme
                    .headline1
                    .color
                    .withOpacity(0.17),
              ),
        ),
        // onChanged: () {},
        // inputFormatters: [
        //   FilteringTextInputFormatter.deny(deny),
        // ],
      );
    }

    @swidget
    Widget postDescription() {
      return TextField(
        // key: key,
        autofocus: false,
        onTap: () {},
        maxLines: null,
        controller: postDescController,
        cursorHeight: 22,
        cursorColor: Colors.black,
        style: TextStyle(
          textBaseline: TextBaseline.alphabetic,
          fontSize: 18.0,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(
              horizontal: layoutProvider.gutter, vertical: 10.0),
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: 'Description...',
          fillColor: Colors.transparent,
          hintStyle: Theme.of(context).textTheme.bodyText1.copyWith(
                fontSize: 18.0,
                color: Theme.of(context)
                    .textTheme
                    .headline1
                    .color
                    .withOpacity(0.17),
              ),
        ),
        // onChanged: () {},
        // inputFormatters: [
        //   FilteringTextInputFormatter.deny(deny),
        // ],
      );
    }

    @swidget
    Widget meidaSection() {
      return Container(
        // color: Colors.amber,
        margin: EdgeInsets.fromLTRB(
            0, layoutProvider.gutter, 0, layoutProvider.gutter),
        // padding: EdgeInsets.fromLTRB(
        //     layoutProvider.gutter, 0, layoutProvider.gutter, 0),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            MediaGallery(
              media: _media + cameraProvider.filePath,
              onRemoveImg: (String path) {
                if (path.startsWith('http')) {
                  setState(() {
                    _deleteMedia = _deleteMedia + [path];
                    _media = _media.where((src) => src != path);
                  });
                } else {
                  cameraProvider.removeFilePath(path);
                }
              },
            ),
            Row(
              children: [
                SizedBox(width: layoutProvider.gutter),
                IconButton(
                  padding: EdgeInsets.all(0.0),
                  icon: Icon(
                    Icons.camera,
                    size: 37,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '${CameraView.route}');
                  },
                ),
                SizedBox(width: layoutProvider.gutter),
                IconButton(
                  padding: EdgeInsets.all(0.0),
                  icon: Icon(
                    Icons.photo,
                    size: 37,
                  ),
                  onPressed: _getImageFromGallery,
                ),
              ],
            )
          ],
        ),
      );
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(this.context).unfocus();
        },
        child: SingleChildScrollView(
          controller: scrollController,
          child: Column(
            children: [
              topNav(),
              storyHeader(),
              postTitle(),
              postDescription(),
              meidaSection(),
            ],
          ),
        ),
      ),
    );
  }
}
