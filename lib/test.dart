import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TestScreenPage extends StatefulWidget {
  @override
  _TestScreenPageState createState() => _TestScreenPageState();
}

class _TestScreenPageState extends State<TestScreenPage> {
  int rows = 0;
  int columns = 0;
  late List<List<String>> grid;
  late List<List<bool>> highlights;
  bool showGrid = false;
  bool showText = false;
  bool showSearchText = false;
  TextEditingController searchText = TextEditingController();
  TextEditingController textController = TextEditingController();
  @override
  void initState() {
    super.initState();
    // Initialize highlights with false initially
  }

  @override
  void dispose() {
    searchText.dispose();
    textController.dispose();
    super.dispose();
  }

  void createGrid(int rows, int columns, List<String> alphabets) {
    if (alphabets.isEmpty || alphabets.length < (rows * columns)) {
      showGrid = false;
      showSearchText = false;
      setState(() {});
      return;
    }
    print(alphabets.length);
    grid = List.generate(
        rows,
        (i) => List.generate(columns, (j) {
              print(
                  "Row:- $i, Columns:- $columns, J:- $j,[$i * $columns + $j]:-alphabates[${i * columns + j}]");
              return alphabets[i * columns + j];
            }));
    highlights =
        List.generate(rows, (i) => List.generate(columns, (j) => false));
    showGrid = true;
    showSearchText = true;
    setState(() {});
  }

  List<List<bool>> searchForText(String text) {
    highlights =
        List.generate(rows, (i) => List.generate(columns, (j) => false));

    // Matrikx ke har cell se shuru karen
    for (int row = 0; row < rows; row++) {
      for (int col = 0; col < columns; col++) {
        // Har cell se shuru ho kar text ki length tak check karen
        for (int k = 0; k < text.length; k++) {
          // Left to Right (East) Direction Check
          if (col + k < columns && grid[row][col + k] == text[k]) {
            highlights[row][col + k] = true;
          }
          // Top to Bottom (South) Direction Check
          if (row + k < rows && grid[row + k][col] == text[k]) {
            highlights[row + k][col] = true;
          }
          // Diagonal (South-East) Direction Check
          if (row + k < rows &&
              col + k < columns &&
              grid[row + k][col + k] == text[k]) {
            highlights[row + k][col + k] = true;
          }
        }
      }
    }
    return highlights;
  }

  Widget buildGridWithHighlights() {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
      ),
      itemCount: rows * columns,
      itemBuilder: (context, index) {
        int row = index ~/ columns;
        int col = index % columns;
        return GridTile(
          child: Center(
            child: Text(
              grid[row][col],
              style: TextStyle(
                fontWeight:
                    highlights[row][col] ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        );
      },
    );
  }

  textFieldShow() {
    if (rows != 0 && columns != 0) {
      showText = true;
      setState(() {});
    } else {
      showText = false;
      showSearchText = false;
      showGrid = false;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matrix Example'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Row(children: [
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      label: Text("Row"),
                      hintText: "Enter Row ex:-3"),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]')),
                    // FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    int? v = int.tryParse(value);
                    if (v != null) {
                      rows = v;
                      textFieldShow();
                    }
                  },
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: TextField(
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15))),
                      label: Text("Column"),
                      hintText: "Enter Column ex:-3"),
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    // FilteringTextInputFormatter.allow(RegExp('[a-z A-Z 0-9]')),
                    // FilteringTextInputFormatter.deny(RegExp(r'\s')),
                  ],
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    int? limit = int.tryParse(value);
                    if (limit == null || limit > 25 || value.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text("Colum is greater then 25 or Empty")));
                    } else {
                      columns = limit;
                      textFieldShow();
                    }
                  },
                ),
              ),
            ]),
            const SizedBox(height: 5),
            showText
                ? TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        label: Text("Distinct Text"),
                        hintText: "Enter Distinct Text ex:-asdf"),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp('[a-z A-Z 0-9]')),
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    keyboardType: TextInputType.text,
                    maxLength: rows * columns,
                    controller: textController,
                  )
                : const SizedBox.shrink(),
            const SizedBox(height: 5),
            showText
                ? ElevatedButton(
                    onPressed: () {
                      if (rows == 0 ||
                          columns == 0 ||
                          textController.text.length < (columns * rows)) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                                "Value Not Accept:- Rows is $rows, Column is $columns and Text is less than ${columns * rows}")));
                      } else {
                        createGrid(
                          rows,
                          columns,
                          textController.text.split(""),
                        );
                      }
                    },
                    child: const Text("Generate Grid"))
                : const SizedBox.shrink(),
            const SizedBox(height: 15),
            showSearchText
                ? TextField(
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15))),
                        label: Text("Search"),
                        hintText: "Enter Text ex:-asdf"),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(
                          RegExp('[a-z A-Z 0-9]')),
                      FilteringTextInputFormatter.deny(RegExp(r'\s')),
                    ],
                    keyboardType: TextInputType.text,
                    maxLength: rows * columns,
                    controller: searchText,
                    onChanged: (value) {
                      setState(() {
                        highlights = searchForText(value);
                      });
                    },
                  )
                : const SizedBox.shrink(),
            showGrid == false
                ? const SizedBox.shrink()
                : Expanded(child: buildGridWithHighlights()),
          ],
        ),
      ),
    );
  }
}
