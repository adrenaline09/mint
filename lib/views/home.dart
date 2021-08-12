// ignore_for_file: prefer_const_constructors
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mint/models/article_model.dart';
import 'package:mint/models/category_model.dart';
import 'package:mint/requirements/data.dart';
import 'package:mint/requirements/news.dart';
import 'package:mint/views/article_view.dart';

import 'category_news.dart';


class Home extends StatefulWidget {
  const Home({ Key? key }) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = List<CategoryModel>.empty(growable: true);
  List<ArticleModel> articles = List<ArticleModel>.empty(growable: true);
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    categories = getCategory();
    getNews();
  }

  getNews() async {
    News newsClass = News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading = false;
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
      ): SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [      
              ///categories
              Container(    
                height: 70,
                child: ListView.builder(
                  itemCount: categories.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context,index){
                  return CategoryTile(
                    imageUrl: categories[index].imageUrl,
                    categoryName: categories[index].categoryName,
                  );
                },
                ),
              ),
              //Blogs
              Container(
                padding: EdgeInsets.only(top: 16),
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

class CategoryTile extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final String  imageUrl, categoryName;
  CategoryTile({required this.imageUrl,required this.categoryName});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){Navigator.push(
        context,MaterialPageRoute(
          builder: (context)=>CategoryNews(
          category:categoryName.toLowerCase()
      )
      ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 16),
        child: Stack(
          children: [ 
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(imageUrl:imageUrl,width: 120,height: 60,fit: BoxFit.cover,)),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Colors.black26,),
              width: 120,
              height: 60,
              child: Text(categoryName, 
              style: TextStyle(
                color: Colors.white,fontSize: 16, 
                fontWeight: FontWeight.w400), 
              ),
            )
          ],
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