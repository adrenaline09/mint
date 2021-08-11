import 'dart:convert';

import 'package:mint/models/article_model.dart';
import 'package:http/http.dart' as http;

class News{

  List<ArticleModel> news =  [];

  Future<void> getNews() async{

    var uri  = Uri.parse("https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=cf1fea53791a48d188aca50b91aa245b");
    var response  = await http.get(uri);

    var jsonData = jsonDecode(response.body);

    if(jsonData['status'] == 'ok'){
      jsonData["articles"].forEach((element){
         
         if(element["urlToImage"] != null && element['description'] != null){
           ArticleModel articlModel = ArticleModel(
             title: element['title'],
             author: element["author"],
             description: element["description"],
             url: element["url"],
             urlToImage: element["urlToImage"],           
             content: element["content"]
           );
           news.add(articlModel);
         }
      });
    }
  }
}