import 'package:flutter/material.dart';

class ReviewImagesPage extends StatefulWidget {
  final List<String> urls;

  ReviewImagesPage(this.urls);

  @override
  State<StatefulWidget> createState() {
    return ReviewImagesStatus();
  }
}

class ReviewImagesStatus extends State<ReviewImagesPage> {
  @override
  void initState() {
    super.initState();
    widget.urls.add(
        'https://upload-images.jianshu.io/upload_images/1913040-4470e7e9bf4328e2.png');
    widget.urls.add(
        'https://upload-images.jianshu.io/upload_images/1913040-f9a51ca5e5142672.png');
    widget.urls.add(
        'https://upload-images.jianshu.io/upload_images/1913040-4470e7e9bf4328e2.png');
    widget.urls.add(
        'https://upload-images.jianshu.io/upload_images/1913040-f9a51ca5e5142672.png');
    widget.urls.add(
        'https://upload-images.jianshu.io/upload_images/1913040-4470e7e9bf4328e2.png');
    widget.urls.add(
        'https://upload-images.jianshu.io/upload_images/1913040-f9a51ca5e5142672.png');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('附件'),
      ),
      body: Center(
        child: GridView.custom(
            childrenDelegate: SliverChildBuilderDelegate(
              (context, index) {
                return Image.network(widget.urls[index]);
              },
              childCount: widget.urls.length,
            ),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 4.0,
              crossAxisSpacing: 4.0,
            )),
      ),
    );
  }
}
