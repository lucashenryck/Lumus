import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lumus/constants.dart';
import 'package:lumus/models/series.dart';
import 'package:lumus/models/user.dart';
import 'package:lumus/providers/user_provider.dart';
import 'package:lumus/resources/firestore_methods.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class CreateReviewAboutSeries extends StatefulWidget {
  const CreateReviewAboutSeries({super.key, this.series});
  final Series? series;

  @override
  State<CreateReviewAboutSeries> createState() => _CreateReviewAboutSeriesState();
}

class _CreateReviewAboutSeriesState extends State<CreateReviewAboutSeries> {
  final TextEditingController _contentController = TextEditingController();
  late DateTime releaseDate;
  late String releaseYear;
  late String seriesInfo;
  double rating = 0;

  @override
  void initState() {
    super.initState();
    releaseDate = widget.series?.firstAirDate != ""
        ? DateTime.parse(widget.series!.firstAirDate!)
        : DateTime.now();

    releaseYear = '(${DateFormat('yyyy').format(releaseDate)})';
    seriesInfo = "${widget.series?.name ?? "Não informado"}  $releaseYear";
  }

  void sendReviewAboutSeries(
    String userId,
    String username,
    String? profilePhoto,
  ) async {
    try{
      String response = await FirestoreMethods().sendReviewAboutSeries(
        _contentController.text, 
        userId, 
        username, 
        profilePhoto, 
        widget.series!.id,
        rating,
        seriesInfo
      );
      if(response == "success"){
        confirmationAlert();
      } else{
        errorAlert();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void confirmationAlert(){
    QuickAlert.show(
      context: context, 
      type: QuickAlertType.success,
      text: "Post publicado!",
      title: "Sucesso!",
      confirmBtnText: "Concluir"
    );
  }

  void errorAlert(){
    QuickAlert.show(
      context: context, 
      type: QuickAlertType.error,
      text: "Algo de errado ocorreu!",
      title: "Erro!",
      confirmBtnText: "Continuar"
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final UserLumus user = Provider.of<UserProvider>(context).getUserLumus;
    return Scaffold(
      backgroundColor: Color.fromRGBO(3, 21, 37, 1),
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.close,
            size: 30,
          ),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        backgroundColor: Color.fromRGBO(3, 21, 37, 1),
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10, right: 10),
            child: ElevatedButton(
              onPressed: () => sendReviewAboutSeries(
                user.id, 
                user.username, 
                user.profilePhoto
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromRGBO(240, 240, 240, 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: Text(
                'Publicar',
                style: GoogleFonts.dmSans(
                  color: Color.fromRGBO(3, 21, 37, 1),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Text(
                      seriesInfo,
                      style: GoogleFonts.dmSans(
                        color: Color.fromRGBO(240, 240, 240, 1),
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    textAlign: TextAlign.center
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 180,
              width: 120,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Color.fromRGBO(240, 240, 240, 1))
                ),
                child: Center(
                  child: widget.series?.posterPath != null
                      ? Image.network(
                          '${Constants.imagePath}${widget.series!.posterPath}',
                          width: 120,
                          height: 180,
                          fit: BoxFit.fill,
                        )
                      : Container(
                          width: 120,
                          height: 180,
                          color: Colors.grey,
                        ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            RatingBar.builder(
              initialRating: rating,
              minRating: 0,
              unratedColor: Color.fromARGB(255, 80, 79, 79),
              glowRadius: 5,
              glowColor: Colors.yellow,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              updateOnDrag: true,
              itemSize: 50,
              onRatingUpdate: (rating) => setState(() {
                this.rating = rating;
              }),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
              child: TextFormField(
                controller: _contentController,
                minLines: 1,
                maxLines: 500,
                autofocus: true,
                keyboardType: TextInputType.multiline,
                style: GoogleFonts.dmSans(
                  color: Color.fromRGBO(240, 240, 240, 1), // Change the color of the typed text
                  textStyle: TextStyle(
                    fontSize: 16,
                  ),
                ),
                decoration: InputDecoration(
                  hintText: 'O que você achou dessa série?',
                  hintStyle: GoogleFonts.dmSans(
                    color: Color.fromRGBO(240, 240, 240, 1),
                    textStyle: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.transparent,  // Change the color of the border for the normal state
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(
                      color: Colors.transparent,  // Change the color of the border for the focused state
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}