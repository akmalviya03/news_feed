import 'package:news_feed/networkApis/search_api.dart';
import 'package:news_feed/Constants.dart';
import '../api_keys.dart';
import '../newsModels/news_list_model.dart';

class NewsApi {
  Future getCountryNews({String countryName = 'in', int page = 1}) async {
    SearchApi networkHelper =
        SearchApi('$newsUrl?country=$countryName&pageSize=10&page=$page&apiKey=$apiKey');
    var newsData = await networkHelper.getData();
    return NewsListModel.fromJson(newsData);
  }
}
