import 'package:news_feed/Services/search_api.dart';
import 'package:news_feed/Constants/constants.dart';
import '../Constants/api_keys.dart';
import '../Models/news_list_model.dart';

class NewsApi {
  Future getCountryNews(
      {String countryName = 'in',
      int page = 1,
      String categoryName = ""}) async {
    late SearchApi networkHelper;
    if (categoryName != "") {
      networkHelper = SearchApi(
          '$newsUrl?country=$countryName&category=$categoryName&pageSize=10&page=$page&apiKey=$apiKey');
    } else {
      networkHelper = SearchApi(
          '$newsUrl?country=$countryName&pageSize=10&page=$page&apiKey=$apiKey');
    }
    try {
      var newsData = await networkHelper.getData();
      if (newsData['status'] == 'error') {
       return Future.value( 'Error while fetching data');
      } else {
        return NewsListModel.fromJson(newsData);
      }
    }
    on Exception catch (e){
      print('Error on News Api ' + e.toString());
      rethrow;
    }finally{
      print('News Api');
    }
  }
}
