import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_webservice/places.dart';

import '../../bloc/google_map/google_map_bloc.dart';

class SearchResultOption extends StatefulWidget {
  const SearchResultOption({
    super.key,
    required this.prediction,
  });

  final Prediction prediction;

  @override
  State<StatefulWidget> createState() => _SearchResultOptionState();
}

class _SearchResultOptionState extends State<SearchResultOption> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<GoogleMapBloc>().add(
              OnLoadNewLocationEvent(widget.prediction),
            );

        context.router.pop();
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        width: MediaQuery.of(context).size.width,
        color: Colors.white,
        child: Row(
          children: [
            const Icon(
              Icons.search,
              size: 20,
            ),
            Expanded(
              child: Text(
                widget.prediction.description ?? 'UNDEFINED',
                maxLines: 2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
