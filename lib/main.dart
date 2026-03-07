import 'package:flutter/material.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

void main() {
  runApp(const MainApp());
}

const isRunningWithWasm = bool.fromEnvironment('dart.tool.dart2wasm');

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TableExample(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
    );
  }
}

/// The class containing the TableView for the sample application.
class TableExample extends StatefulWidget {
  /// Creates a screen that demonstrates the TableView widget.
  const TableExample({super.key});

  @override
  State<TableExample> createState() => _TableExampleState();
}

class _TableExampleState extends State<TableExample> {
  late final ScrollController _horizontalController;
  late final ScrollController _verticalController;
  int _rowCount = 20;
  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
    _verticalController = ScrollController();
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Running ${isRunningWithWasm ? 'WASM' : 'JavaScript?'}'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 50.0),
        child: Scrollbar(
          controller: _horizontalController,
          child: Scrollbar(
            controller: _verticalController,
            child: TableView.builder(
              horizontalDetails: ScrollableDetails.horizontal(
                controller: _horizontalController,
              ),
              verticalDetails: ScrollableDetails.vertical(
                controller: _verticalController,
              ),
              cellBuilder: _buildCell,
              columnCount: 20,
              columnBuilder: _buildColumnSpan,
              rowCount: _rowCount,
              rowBuilder: _buildRowSpan,
            ),
          ),
        ),
      ),
      persistentFooterButtons: <Widget>[
        OverflowBar(
          alignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            TextButton(
              onPressed: () {
                _verticalController.jumpTo(0);
              },
              child: const Text('Jump to Top'),
            ),
            TextButton(
              onPressed: () {
                _verticalController.jumpTo(
                  _verticalController.position.maxScrollExtent,
                );
              },
              child: const Text('Jump to Bottom'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _rowCount += 10;
                });
              },
              child: const Text('Add 10 Rows'),
            ),
          ],
        ),
      ],
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) {
    Widget result = Center(
      child: Text('Tile c: ${vicinity.column}, r: ${vicinity.row}'),
    );
    if (vicinity.column == 0) {
      result = Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [FlutterLogo(), Text('Row: ${vicinity.row}')],
          ),
        ),
      );
    }
    if (vicinity.column == 1) {
      result = Center(
        child: Chip(
          label: Text('Tile c: ${vicinity.column}, r: ${vicinity.row}'),
        ),
      );
    }
    return TableViewCell(child: result);
  }

  TableSpan _buildColumnSpan(int index) {
    const decoration = TableSpanDecoration(
      border: TableSpanBorder(trailing: BorderSide()),
    );

    switch (index % 5) {
      case 0:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(100),
        );
      case 1:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: MinSpanExtent(
            FixedTableSpanExtent(600),
            MaxSpanExtent(
              FixedTableSpanExtent(120),
              const FractionalTableSpanExtent(0.5),
            ),
          ),
        );
      case 2:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(120),
        );
      case 3:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(145),
        );
      case 4:
        return TableSpan(
          foregroundDecoration: decoration,
          extent: const FixedTableSpanExtent(200),
        );
    }
    throw AssertionError(
      'This should be unreachable, as every index is accounted for in the '
      'switch clauses.',
    );
  }

  TableSpan _buildRowSpan(int index) {
    final decoration = TableSpanDecoration(
      color: index.isEven
          ? Theme.of(context).colorScheme.surfaceContainer
          : null,
      border: const TableSpanBorder(trailing: BorderSide(width: 3)),
    );

    return TableSpan(
      backgroundDecoration: decoration,
      extent: const FixedTableSpanExtent(65),
    );
  }
}
