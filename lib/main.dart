import 'package:flutter/material.dart';
import 'package:memory_game/models/squares.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider(
          create: (context) => Squares(),
          child: const TilesGrid(),
        ),
      ),
    );
  }
}

class TilesGrid extends StatelessWidget {
  const TilesGrid({super.key});

  Color check(int i, List<int> selected, List<int> series) {
    if (selected.contains(i) && series.contains(i)) {
      return Colors.green;
    } else if (selected.contains(i) && !series.contains(i) && series.isNotEmpty) {
      return Colors.red;
    } else if (selected.contains(i) || series.contains(i)) {
      return Colors.blue;
    } else {
      return Colors.white70;
    }
  }

  @override
  Widget build(BuildContext context) {
    final Squares model = Provider.of<Squares>(context);
    // model.generateSeries();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Wrap(
          spacing: 20,
          children: [
            IconButton(
                onPressed: () {
                  model.previousLevel();
                },
                icon: const Icon(Icons.remove)),
            IconButton(
                onPressed: () {
                  model.nextLevel();
                },
                icon: const Icon(Icons.add)),
            IconButton(
                onPressed: () {
                  model.play();
                },
                icon: const Icon(Icons.play_arrow)),
            IconButton(
                onPressed: () {
                  model.show(model.series.isEmpty);
                },
                icon: const Icon(Icons.remove_red_eye_outlined)),
          ],
        ),
        // Wrap(
        //   spacing: 15,
        //   children: [
        //     Text("Size: ${model.size.toString()}"),
        //     Text("Sequence: ${model.seriesHidden.toString()}"),
        //     Text("Selected: ${model.selected.toString()}"),
        //   ],
        // ),
        Expanded(
          child: LayoutBuilder(builder: (context, constraints) {
            double gridWidth = constraints.maxWidth;
            double gridHeight = constraints.maxHeight;
            double cardWidth = gridWidth / model.size;
            double cardHeight = gridHeight / model.size;

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: model.size,
                childAspectRatio: cardWidth / cardHeight,
              ),
              itemCount: model.size * model.size,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    model.select(index);
                  },
                  child: Card(
                    color: check(index, model.selected, model.series),
                    child: const SizedBox(),
                  ),
                );
              },
            );
          }),
        ),
      ],
    );
  }
}
