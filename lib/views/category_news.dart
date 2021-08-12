import 'package:flutter/material.dart';
import 'package:mint/models/article_model.dart';
import 'package:mint/requirements/news.dart';
import 'package:mint/views/article_view.dart';

class CategoryNews extends StatefulWidget {
  final String category;
  CategoryNews({required this.category});

  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> articles = List<ArticleModel>.empty(growable: true);
  bool _loading = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategoryNews();
  }

  getCategoryNews() async {
    CategoryNewsClass newsClass = CategoryNewsClass();
    await newsClass.getNews(widget.category);
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black,),
        centerTitle: true,
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children:[
            Text("Mint",style: TextStyle(color: Colors.black),),
            Text("News",style: TextStyle(color: Colors.yellowAccent.shade700),)
          ],
        ),
      ),
      body: _loading? Center(
        child: CircularProgressIndicator()
      ):SingleChildScrollView(
        child: Container( 
           padding: EdgeInsets.only(top: 16),
          child: Column(
            children: [
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    itemCount: articles.length,
                    shrinkWrap: true,
                    itemBuilder: (context,index){
                      return BlogTile(
                        imageUrl: articles[index].urlToImage , 
                        title: articles[index].title , 
                        desc: articles[index].description,
                        url: articles[index].url,
                      );
                    },
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }
}


class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc,url;
  BlogTile({required this.imageUrl,required this.title,required this.desc,required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
          builder: (context)=> ArticleView(blogUrl: url)
        ));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(imageUrl)),
            SizedBox(height: 8,),
            Text(title,style: TextStyle(fontSize: 17 ,color: Colors.black87),),
            SizedBox(height: 8,),
            Text(desc,style: TextStyle(color: Colors.grey),),
          ],
        ),
      ),
    );
  }
}