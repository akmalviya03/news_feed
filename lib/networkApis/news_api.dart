import 'package:news_feed/networkApis/search_api.dart';
import 'package:news_feed/Constants.dart';
import '../api_keys.dart';
import '../newsModels/news_list_model.dart';
class NewsApi {
  Future getCountryNews([String countryName = 'in']) async {
    SearchApi networkHelper = SearchApi(
        '$newsUrl?country=$countryName&apiKey=$apiKey');
    var newsData = await networkHelper.getData();
    return NewsListModel.fromJson(newsData);
  }
}