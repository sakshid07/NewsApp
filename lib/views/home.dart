import 'package:flutter/material.dart';
import 'package:news_app/helper/data.dart';
import 'package:news_app/helper/news.dart';
import 'package:news_app/models/category_model.dart';
import 'package:news_app/models/article_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:news_app/views/article_view.dart';
import 'package:news_app/views/category_news.dart';
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoryModel> categories = new List<CategoryModel>();
  List<ArticleModel> articles = new List<ArticleModel>();
  bool _loading = true;
  @override
  void initState() {
    super.initState();
    categories = getCategories();
    getNews();
  }

  getNews() async {
    News newsClass =News();
    await newsClass.getNews();
    articles = newsClass.news;
    setState(() {
      _loading=false;
    });


  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
          // Text("Today's"),
          Text("News",style: TextStyle(color: Colors.blue,fontSize: 21),)
        ],),
        elevation: 0.0,
      ),
      body: _loading ? Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      )
      :SingleChildScrollView(
              child: Container(
          child: Column(children:[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              height: 90,
              child:ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context,index){
                  return CategoryTitle(
                    imageUrl: categories[index].imageUrl,
                    categoryName: categories[index].categoryName,
                  );
                },)
            ),


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
          ]),
        ),
      ),
    );
  }
}
class CategoryTitle extends StatelessWidget {
  final imageUrl, categoryName;
  CategoryTitle({this.imageUrl, this.categoryName});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryNews(
              category:categoryName.toLowerCase(),
            )));
          },
          child: Container(
        margin: EdgeInsets.only(right: 8,left:8,top:16,bottom:13),
        child: Stack(children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(7),
            child: CachedNetworkImage(imageUrl:imageUrl, width: 120,height: 80,fit: BoxFit.cover,)),
          Container(
            alignment: Alignment.center,
            width: 120,height: 90,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(7), 
              color: Colors.black26,
            ),
            
            child: Text(categoryName, style: TextStyle(color: Colors.white,fontSize: 14,fontWeight: FontWeight.w500),),
          ),
        ],),
        
      ),
    );
  }
}


class BlogTile extends StatelessWidget {
  final String imageUrl, title, desc, url;
  BlogTile({@required this.imageUrl,@required this.title,@required this.desc,@required this.url});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=> ArticleView(
          blogUrl: url,
          
        )));
      },
          child: Container(
        margin: EdgeInsets.only(top:8,bottom:16),
        child: Column(children:[
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(imageUrl)),
          SizedBox(height:8),
          Text(title, style:TextStyle(
            fontSize:18,
            color:Colors.white,
            fontWeight: FontWeight.w400,
          ),),
          SizedBox(height:8),
          Text(desc, style:TextStyle(
            color:Colors.white70,
            fontWeight: FontWeight.w400,
          ),),
        ])
        
      ),
    );
  }
}