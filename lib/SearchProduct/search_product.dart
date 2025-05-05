import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../HomeScreen/home_screen.dart';
import '../Widgets/listview_widget.dart';
class SearchProduct extends StatefulWidget {


  @override
  State<SearchProduct> createState() => _SearchProductState();
}

class _SearchProductState extends State<SearchProduct> {



  final TextEditingController _searchQueryController = TextEditingController();
  String searchQuery = '';
  bool _isSearching = false;
  Widget _buildSearchField()
  {
    return TextField(
      controller : _searchQueryController ,
      autofocus: true,
      decoration:const InputDecoration(
        hintText: 'Search here...',
        hintStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontFamily: 'Quicksand',
        ),
      ),
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontFamily: 'Quicksand',
      ),
      onChanged: (query) => updateSearchQuery(query),
    );
  }


  updateSearchQuery(String newQuery)
  {
    setState(() {
      searchQuery = newQuery;
      print(searchQuery);
    });
  }

  List<Widget> _buildActions() {
    if (_isSearching) {
      return <Widget>
      [
        IconButton(
          icon: const Icon(Icons.clear, color: Colors.white,),
          onPressed: () {
            if (_searchQueryController == null ||
                _searchQueryController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }

            _clearSearchQuery();
          },
        ),
      ];
    }
    return <Widget>[
      Padding(
        padding: const EdgeInsets.only(right: 25.0),
        // move slightly left by reducing right space
        child: IconButton(
          icon: const Icon(Icons.search, color: Colors.white, size: 25),
          onPressed: _starSearch,
        ),
      ),
    ];
  }

  _clearSearchQuery()
  {
    setState(() {
      _searchQueryController.clear();
      updateSearchQuery('');
    });
  }

  _starSearch()
  {
    ModalRoute.of(context)!.addLocalHistoryEntry(LocalHistoryEntry(onRemove: _stopSearching ));
    setState(() {
      _isSearching = true;
    });
  }

  _stopSearching()
  {
    _clearSearchQuery();
    setState(() {
      _isSearching = false;
    });
  }

  _buildTitle(BuildContext context)
  {
    return const Text('Search Posts' ,
      style: TextStyle(
      color: Colors.white, // Change to any color you want
      fontSize: 18,         // Optional: adjust font size
      fontFamily: 'Quicksand', // Optional: make it bold
    ),
    );
  }

  _buildBackButton()
  {
    return IconButton(
      icon: const Icon(Icons.arrow_back , color: Colors.white,),
      onPressed: () {
        Navigator.pushReplacement(context ,
            MaterialPageRoute(builder: (context) => HomeScreen()));
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blueAccent, Colors.white],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: [0.0, 0.0], // Corrected stops
          tileMode: TileMode.clamp,
        ),
      ),
      child : Scaffold(
        backgroundColor: Colors.transparent,
      appBar: AppBar(

        leading: _isSearching ? const BackButton() : _buildBackButton(),
        title: _isSearching ? _buildSearchField() : _buildTitle(context),
        actions: _buildActions(),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blueAccent, Colors.white],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              stops: [1.0, 1.0], // Corrected stops
              tileMode: TileMode.clamp,
            ),
          ),
        ),
       ),


        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
            stream: FirebaseFirestore.instance
                .collection('items')
                .where('itemName' , isGreaterThanOrEqualTo: _searchQueryController.text.trim())
                .where('status' , isEqualTo: 'approved')
                .snapshots(),

          builder: (context, AsyncSnapshot snapshot)
          {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data!.docs.isNotEmpty) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    final doc = snapshot.data!.docs[index];
                    return ListviewWidget(
                      docId: doc.id,
                      img1: doc['urlImage1'],
                      img2: doc['urlImage2'],
                      img3: doc['urlImage3'],
                      postId: doc['id'],
                      userId: doc['id'],
                      itemName: doc['itemName'],
                      itemCon: doc['itemCon'],
                      description: doc['description'],
                      userNumber: doc['userNumber'],
                      date: doc['time'].toDate(),
                      userName: doc['userName'],
                      imgPro: doc['imgPro'],
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text('There are no items posted yet.'),
                );
              }
            }
            return const Center(
              child: Text(
                'Something went wrong',
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          },
        ),

      ),
    );
  }
}
