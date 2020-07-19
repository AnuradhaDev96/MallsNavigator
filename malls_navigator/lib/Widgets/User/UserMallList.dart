//Developed by
//IT17006408 - A.S.H. Siribaddana
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Model/mall.dart';
import '../../Model/user.dart';
import '../../Model/favouriteMall.dart';
import '../../Controller/PolestarService.dart';
import '../Map/MallLocatorMap.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:share/share.dart';

//Shopping Mall list for view customer
//Tab view which contains available shopping malls and favourite shopping malls of logged in user 
class UserMallList extends StatefulWidget {
      UserMallList({Key key, this.loggedInUser}) : super(key: key);
      User loggedInUser;
      @override
      _UserMallListState createState() => _UserMallListState();
}

class _UserMallListState extends State<UserMallList> {
  PolestarService _polestarService = PolestarService();
  TextStyle mallHeadingStyle = TextStyle(fontSize: 14, fontWeight: FontWeight.bold);
  final String typeMalls = "malls";
  final String typeFavMalls = "favMalls";
  static Stream<QuerySnapshot> favmallList;
  static TextEditingController searchBarController = TextEditingController();
  final _userMallsScaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    favmallList = getMalls(typeFavMalls);
    super.initState();
  }

  getMalls(String mallType){
    if (mallType == "malls"){
      return _polestarService.getMalls();
    }
    else{
      return _polestarService.getFavouriteMalls(widget.loggedInUser.reference);
    }    
  }

  addtoFavourites(Mall mall){
    FavouriteMall favouriteMall = FavouriteMall(name: mall.name, description: mall.description, longitude: mall.longitude, latitude: mall.latitude, userId: widget.loggedInUser.reference, mallId: mall.reference);
    _polestarService.addFavouriteMall(favouriteMall);
  }

  removeFromFavourites(FavouriteMall favMall){
    _polestarService.deleteFavouriteMall(favMall);
  }

  Widget buildBody(BuildContext context, String mallType){
    return StreamBuilder<QuerySnapshot>(
      stream: getMalls(mallType),
      builder: (context, snapshot){
        if(snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if(snapshot.hasData){
          return buildList(context, snapshot.data.documents, mallType);
        }
      },
    );
  }

  Widget buildFavouriteMallsBody(BuildContext context, String mallType){
    return StreamBuilder<QuerySnapshot>(
      stream: favmallList,
      //initialData: api.getSingleMall(),
      builder: (context, snapshot){
        if(snapshot.hasError) {
          return Text('Error ${snapshot.error}');
        }
        if(snapshot.hasData){
          return buildList(context, snapshot.data.documents, mallType);
        }
      },
    );
  }

  Widget buildSearchBar(BuildContext context){
    return TextField(
      onEditingComplete: (){
        setState(() {
          favmallList = null;
          filterFavouriteMallsByMallName(searchBarController.text);
        });
      },
      textInputAction: TextInputAction.search,
      controller: searchBarController,
      decoration: InputDecoration(
        labelText: "Search",
        hintText: "Search Mall Here",    
        prefixIcon: IconButton(
          splashColor: Colors.blue,      
          iconSize: 20.0,
          icon: Icon(Icons.search), 
          onPressed: () {
            filterFavouriteMallsByMallName(searchBarController.text);
            },
        ),
        suffixIcon: IconButton(
          tooltip: "Clear Search",
          splashColor: Colors.blue,      
          iconSize: 20.0,
          icon: Icon(Icons.clear), 
          onPressed: () {
            filterFavouriteMallsByMallName("ALL");
            },
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0))
        )
      ),
    );
  }

  void filterFavouriteMallsByMallName(String mallName) async{    
    if(mallName == "ALL"){
      setState(() {
        favmallList = null;
        favmallList = _polestarService.getFavouriteMalls(widget.loggedInUser.reference);
        searchBarController.text = "";
      });
    }else{
      setState(() {
        favmallList = null;
        favmallList = _polestarService.getFavouriteMallsByMallName(mallName, widget.loggedInUser.reference);
      });
      
    }    
  }

  Widget buildList(BuildContext context, List<DocumentSnapshot> snapshot, String mallType){
    return ListView(
      children: snapshot.map((data) => buildListItem(context, data, mallType)).toList(),
    );
  }

  Widget buildListItem(BuildContext context, DocumentSnapshot data, String mallType){
    var mall;
    if (mallType == typeMalls){
      mall = Mall.fromSnapshot(data);
    } else {
      mall = FavouriteMall.fromSnapshot(data);
    }
    
    return Padding (
      key: ValueKey(mall.reference.documentID),
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: Container( 
        //height: 72,       
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          gradient: (mallType == typeMalls) ? LinearGradient(
            colors: [Colors.pink[200], Colors.purple[400]],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
          ):LinearGradient(
            colors: [Colors.orange[300], Colors.red[700]],
                  begin: Alignment.centerRight,
                  end: Alignment.centerLeft,
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[           
            mallSlidable(context, mall, mallType),
          ]
        )
      ),
    );
  }

  void navigate(Mall mall) async{
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MallLocatorMap(title: 'Malls Edit Console', latitude: mall.latitude, longitude: mall.longitude, locationName: mall.name)),
    );
  }

  Widget mallSlidable(BuildContext context, dynamic mall, String mallType) {
    return Slidable(
      actionPane: new SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,      
      child: new ListTile(              
        title: Text(
          mall.name,
          style: TextStyle(
            color: Colors.grey[200],
            fontWeight: FontWeight.bold,
            fontSize: 25.0
          ),
        ),
        subtitle: Text(
          mall.description, 
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 12.0
          )       
        ),
        onTap: (){
          navigate(mall);
        },
      ),
      actions: <Widget>[
        new IconSlideAction(
          caption: 'Share',
          color: Colors.indigo,
          icon: Icons.share,
          onTap: () {
            final name = mall.name;
            final description = mall.description;
            final latitude = mall.latitude;
            final longitude = mall.longitude;
            Share.share(
              'See what I have found for shopping\n$name\n$description\n\nhttps://www.google.com/maps/search/?api=1&query=$latitude,$longitude',              
            );
          }
        ),
      ],
      secondaryActions: <Widget>[
        new IconSlideAction(
          caption: 'Navigate',
          color: Colors.green,
          icon: Icons.navigation,
          onTap: () {
            navigate(mall);
          } 
        ),
        (mallType == typeMalls) 
        ? new IconSlideAction(          
          caption: 'Save',
          color: Colors.orange[300],
          icon: Icons.star,
          onTap: (){
            addtoFavourites(mall);
          }
        )
        : new IconSlideAction(          
          caption: 'Unsave',
          color: Colors.pink[800],
          icon: Icons.delete_sweep,
          onTap: (){
            removeFromFavourites(mall);
          }
        )
      ],
    );
  }

  //create AddToFavourite and RemoveFromFavourites
  //TODO: create a add to favourite button while checking whether user has added this mall to their favourites 

  //tab of malls
  Widget buildMallsTab(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(0.5),
      child: Padding(              
        padding: const EdgeInsets.all(5.0),
        child: Column(                
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.location_on, size: 12.0,),
                  Text(
                    "  Tap to view location on Polestar Map",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.indigo[600]
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.swap_horizontal_circle, size: 12.0,),
                  Text(
                    "  Swipe for options",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.purple[400]
                    ),
                  )
                ],
              ),
              Flexible(
                    child: buildBody(context, typeMalls)
                  ),
          ],
        ),
      ),
    );
  }

  Widget buildFavouriteMallsTab(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5.0),
      child: Padding(              
        padding: const EdgeInsets.all(5.0),
        child: Column(                
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            buildSearchBar(context),
            SizedBox(
              height:5.0
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.location_on, size: 12.0,),
                  Text(
                    "  Tap to view location on Polestar Map",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.indigo[600]
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Icon(Icons.swap_horizontal_circle, size: 12.0,),
                  Text(
                    "  Swipe for options",
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.orange[600]
                    ),
                  )
                ],
              ),
              Flexible(
                    child: buildFavouriteMallsBody(context, typeFavMalls)
                  )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(      
      home: DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar( 
            actions: <Widget>[
              CircleAvatar(
                radius: 25,
                backgroundColor: Colors.grey[200],
                child: ClipOval(                
                child: SizedBox(
                  height: 45,
                  width: 45,
                  child: Image.network(widget.loggedInUser.profileImageUrl),
                ),
              ),
              )              
            ],           
            elevation: 5.0,
            backgroundColor: Colors.indigo[600],
            bottom: TabBar(
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white30,
              tabs: [
                Tab(icon: Icon(Icons.store)),
                Tab(icon: Icon(Icons.star)),
              ],
            ),
            title: Text('Shopping Malls'),
          ),
          body: TabBarView(
            children: [
              buildMallsTab(context),
              buildFavouriteMallsTab(context)              
            ],
          ),
        ),
      )
    ); 
  }  
}