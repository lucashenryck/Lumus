import 'package:flutter/material.dart';
import 'package:lumus/api/tmdb_api.dart';
import 'package:lumus/constants.dart';
import 'package:lumus/pages/series_details_page.dart';

class TrendingSeries extends StatelessWidget {
  const TrendingSeries({
    super.key,
    required this.snapshot
  });

  final AsyncSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal, 
        physics: const BouncingScrollPhysics(),
        itemCount: 10,
        itemBuilder: (context, itemIndex){
          final series = snapshot.data[itemIndex];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white,
                  width: 0.25, 
                ),
              ),
              child: GestureDetector(
                onTap: () async {
                  try{
                    final seriesDetails = await TmdbApi().getSeriesDetails(series.id);
                    final cast = await TmdbApi().getCastFromSeries(series.id);
                    final crew = await TmdbApi().getCrewFromSeries(series.id);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SeriesDetailsPage(
                          series: seriesDetails,
                        ),
                      ),
                    );
                  }catch (e){
                    print('Erro ao obter detalhes da série: $e');
                  }
                },
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: SizedBox(
                        height: 225,
                        width: 140,
                        child: Image.network(
                          filterQuality: FilterQuality.high,
                          fit: BoxFit.cover,
                          '${Constants.imagePath}${snapshot.data[itemIndex].posterPath}'
                        )
                      ),
                    ),
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '${itemIndex + 1}',
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          )
                        )
                      )
                    )
                  ],
                ),
              ),
            ),
          );
        }, 
      ),
    );
  }
}