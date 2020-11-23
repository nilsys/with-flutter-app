import 'package:flutter/material.dart';
import 'package:functional_widget_annotation/functional_widget_annotation.dart';
import 'package:no_context_navigation/no_context_navigation.dart';
import 'package:with_app/core/models/story.model.dart';
import 'package:with_app/core/view_models/layout.vm.dart';

final NavigationService navService = NavigationService();

class EditPostView extends StatelessWidget {
  final Story story;

  EditPostView({
    @required this.story,
  });

  final LayoutVM layoutProvider = locator<LayoutVM>();

  @override
  Widget build(BuildContext context) {
    final TextEditingController postTitleController = TextEditingController();

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
                onPressed: () {},
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
        // margin: EdgeInsets.only(top: layoutProvider.gutter / 2),
        padding: EdgeInsets.symmetric(
            vertical: layoutProvider.gutter, horizontal: layoutProvider.gutter),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(width: 1, color: Colors.black.withAlpha(70)),
          ),
        ),
        child: Row(
          children: [
            this.story.cover != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      this.story.cover,
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
                    this.story.title,
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
        onTap: () {},
        controller: postTitleController,
        cursorHeight: 20,
        decoration: InputDecoration(
          floatingLabelBehavior: FloatingLabelBehavior.never,
          hintText: 'Post Title',
          contentPadding: EdgeInsets.fromLTRB(0.0, 0, 0, 0),
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

    return SafeArea(
      child: Column(
        children: [
          topNav(),
          storyHeader(),
          postTitle(),
        ],
      ),
    );
  }
}
