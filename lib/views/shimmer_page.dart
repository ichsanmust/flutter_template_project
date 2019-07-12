import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
//import 'package:skeleton_text/skeleton_text.dart';

class ShimmerPage extends StatelessWidget {
  Future<List<int>> _getResults() async {
    await Future.delayed(Duration(seconds: 3));
    return List<int>.generate(10, (index) => index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shimmer'),
      ),
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
//              SkeletonAnimation(
//                child: Container(
//                  width: 70.0,
//                  height: 70.0,
//                  decoration: BoxDecoration(
//                    color: Colors.grey[300],
//                  ),
//                ),
//              ),
//              SkeletonAnimation(
//                child: Container(
//                  width: 50.0,
//                  height: 10.0,
//                  decoration: BoxDecoration(
//                    color: Colors.grey[300],
//                  ),
//                ),
//              ),

            Container(
              margin: EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
              child: Text(
                'List Data',
                style: TextStyle(fontSize: 30),
              ),
            ),
            Expanded(
              child: FutureBuilder<List<int>>(
                  // perform the future delay to simulate request
                  future: _getResults(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return ListView.builder(
                        itemCount: 10,
                        // Important code
                        itemBuilder: (context, index) {
                          return Shimmer.fromColors(
                              baseColor: Colors.grey[300],
                              highlightColor: Colors.white,
                              child: ListItemLoader());
                        },
                      );
                    } else {
                      return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return ListItem(index: index);
                        },
                      );
                    }
                  }),
            )
          ]),
    );
  }
}

class ListItem extends StatelessWidget {
  final int index;
  const ListItem({Key key, this.index});
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      //margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
      margin: EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
      child: Row(
        children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.only(right: 15.0),
            color: Colors.blue,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'This is title $index',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text('This is more details'),
              Text('One more detail'),
            ],
          )),
        ],
      ),
    );
  }
}

class ListItemLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        height: 50,
        //margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        margin: EdgeInsets.fromLTRB(20.0, 5, 20.0, 5),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
        child: Row(children: <Widget>[
          Container(
            width: 50.0,
            height: 50.0,
            margin: EdgeInsets.only(right: 15.0),
            color: Colors.blue,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 50.0,
                  height: 10.0,
                  margin: EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                Container(
                  height: 10.0,
                  margin: EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
                Container(
                  height: 10.0,
                  margin: EdgeInsets.only(top: 5.0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ]));
  }
}
