import 'package:less_api_client/cloud.dart';

Cloud createCloud(String entryUrl,
    {GetTokenFunction getAccessToken, int timeout: 5000}) {
  return new Cloud(
      entryUrl: entryUrl, getAccessToken: getAccessToken, timeout: timeout);
}
