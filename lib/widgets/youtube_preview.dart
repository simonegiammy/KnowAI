import 'package:KnowAI/style.dart';
import 'package:KnowAI/utils.dart';
import 'package:flutter/cupertino.dart';

class YoutubePreview extends StatelessWidget {
  final String link;
  const YoutubePreview({super.key, required this.link});

  @override
  Widget build(BuildContext context) {
    String videoId = AppUtils.extractVideoId(link);
    String thumbnailUrl =
        'https://img.youtube.com/vi/$videoId/maxresdefault.jpg';

    return GestureDetector(
      onTap: () {
        AppUtils.launchURL(link);
      },
      child: Container(
        width: MediaQuery.of(context).size.width * 0.5,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: AppStyle.gray)),
        child: Image.network(
          thumbnailUrl,
          errorBuilder: (context, error, stackTrace) {
            return Container();
          },
        ),
      ),
    );
  }
}
