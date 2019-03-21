import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to Flutter',
      theme: new ThemeData(
        primaryColor: Colors.teal
      ),
      home: new RandomWords(),
    );
  }
}

class RandomWordsState extends State<RandomWords>{
  final List<WordPair> _wordList = <WordPair>[];
  final TextStyle _textStyle = const TextStyle(fontSize: 18.0);
  final Set<WordPair> _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("List Example"),
        actions: <Widget>[
          new IconButton(icon: const Icon(Icons.list), onPressed: _pushSaved)
        ],
      ),
      body: buildListWords(),
    );
  }

  Widget buildListWords(){
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (BuildContext _context, int i){
        if (i.isOdd){
          return new Divider();
        }
        final int index = i~/2;
        if(index >= _wordList.length){
          _wordList.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_wordList[index]);
      }
    );
  }

  Widget _buildRow(WordPair word){
    final bool _alreadySave = _saved.contains(word);
    return new ListTile(
      title: new Text(
        word.asPascalCase,
        style: _textStyle,
      ),
      trailing: new Icon(
        _alreadySave ? Icons.favorite : Icons.favorite_border,
        color: _alreadySave ? Colors.red : null,
      ),
      leading: new Icon(Icons.label_outline),
      onTap: (){
        setState(() {
          if(_alreadySave){
            _saved.remove(word);
          }else{
            _saved.add(word);
          }
        });
      },
    );
  }
  
  void _pushSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute<void>(
          builder: (BuildContext context){
            final Iterable<ListTile> tiles = _saved.map(
              (WordPair word){
                return new ListTile(
                  title: new Text(
                    word.asPascalCase,
                    style: _textStyle,
                  ),
                );
              }
            );
            final List<Widget> divided = ListTile
              .divideTiles(
                context: context,
                tiles: tiles
              ).toList();
            return new Scaffold(
              appBar: new AppBar(
                title: const Text("Favoritos"),
              ) ,
              body: new ListView(children: divided),
            );
          }
      )
    );
  }
}

class RandomWords extends StatefulWidget{
  @override
  RandomWordsState createState() => new RandomWordsState();
}