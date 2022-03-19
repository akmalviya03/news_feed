import 'package:news_feed/networkApis/search_api.dart';
import 'package:news_feed/constants.dart';
import '../api_keys.dart';
import '../News/newsModels/news_list_model.dart';

class NewsApi {
  Future getCountryNews(
      {String countryName = 'in',
      int page = 1,
      String categoryName = ""}) async {
    SearchApi networkHelper = SearchApi(
        '$newsUrl?country=$countryName&category=$categoryName&pageSize=10&page=$page&apiKey=$apiKey');
    var newsData = await networkHelper.getData();
    return NewsListModel.fromJson(newsData);
  }
}
