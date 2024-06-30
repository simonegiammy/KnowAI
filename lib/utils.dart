import 'package:url_launcher/url_launcher.dart';

class AppUtils {
  static int getMinutesReading(String content) {
    int numeroParole = content.split(' ').length;
    double velocitaLetturaMedia = 225; // parole al minuto
    double tempoLetturaMinuti = numeroParole / velocitaLetturaMedia;
    if (tempoLetturaMinuti < 1) {
      tempoLetturaMinuti = 1;
    }
    return tempoLetturaMinuti.floor();
  }

  static String extractVideoId(String url) {
    Uri uri = Uri.parse(url);
    if (uri.host == 'youtu.be') {
      return uri.pathSegments.first;
    } else if (uri.host == 'www.youtube.com' || uri.host == 'youtube.com') {
      return uri.queryParameters['v'] ?? '';
    }
    return '';
  }

  static void launchURL(String url) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
