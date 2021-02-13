import 'package:flutter/material.dart';
import 'package:news_app/models/article_model.dart';
import 'package:news_app/views/home.dart';
import 'package:news_app/helper/news.dart';
class CategoryNews extends StatefulWidget {
  final String category;
  CategoryNews({this.category});
  @override
  _CategoryNewsState createState() => _CategoryNewsState();
}

class _CategoryNewsState extends State<CategoryNews> {
  List<ArticleModel> articles =new List<ArticleModel>();
  bool _loading =true;

  void initState() {
    super.initState();
    getCategorieNews();
  }
  
  getCategorieNews() async {
    CategoryNewsClass newsClass =CategoryNewsClass();
    await newsClass.getNews(widget.category);
    articles = newsClass.news;
    setState(() {
      _loading=false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          
          Text("News",style: TextStyle(color: Colors.blue,fontSize: 21),)
        ],),
        actions: [
          Opacity( 
            opacity:0,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal:16),
            child:Icon(Icons.save)
          ),
          ),
          
        ],
        elevation: 0.0,
      ),
      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      ):SingleChildScrollView(
              child: Container(
          child:Column(
            children:[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 14),
                // margin: EdgeInsets.only(top:14),
                child: ListView.builder(
                  
                  itemCount: articles.length,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  // scrollDirection: Axis.vertical,
                  itemBuilder: (context,index){
                    return BlogTile(imageUrl: articles[index].urlToImage,
                     title: articles[index].title, desc: articles[index].description, url:articles[index].url);
                  }),
              ),
            ],
          ),
        ),
      ),
    );
  }
  }