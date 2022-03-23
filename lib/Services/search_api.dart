import 'package:http/http.dart' as http;
import 'dart:convert';

class SearchApi {
  SearchApi(this.url);

  final String url;

  Future getData() async {
    try {
      http.Response response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        String data = response.body;
        return jsonDecode(data);
      } else {
        throw 'Something bad Happened';
      }
    } on Exception catch (e){
      print('Error on Search Api ' + e.toString());
      rethrow;
    }finally{
      print('Search Api');
    }
  }
}
