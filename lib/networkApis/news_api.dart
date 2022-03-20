import 'package:news_feed/networkApis/search_api.dart';
import 'package:news_feed/Utility/constants.dart';
import '../Utility/api_keys.dart';
import '../News/newsModels/news_list_model.dart';

class NewsApi {
  Future getCountryNews(
      {String countryName = 'in',
      int page = 1,
      String categoryName = ""}) async {
    late SearchApi networkHelper;
    if(categoryName != ""){
     networkHelper = SearchApi(
        '$newsUrl?country=$countryName&category=$categoryName&pageSize=10&page=$page&apiKey=$apiKey');
    }else{
      networkHelper = SearchApi(
          '$newsUrl?country=$countryName&pageSize=10&page=$page&apiKey=$apiKey');
    }
    var newsData = await networkHelper.getData();
    if (newsData['status'] == 'error') {
      return Future.error('Error while fetching data');
    }
    return NewsListModel.fromJson(newsData);
  }
}
