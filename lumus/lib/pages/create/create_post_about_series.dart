import 'package:flutter/material.dart';
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

class CreatePostAboutSeries extends StatefulWidget {
  const CreatePostAboutSeries({super.key, this.series});
  final Series? series;

  @override
  State<CreatePostAboutSeries> createState() => _CreatePostAboutSeriesState();
}

class _CreatePostAboutSeriesState extends State<CreatePostAboutSeries> {
  final TextEditingController _contentController = TextEditingController();
  late DateTime releaseDate;
  late String releaseYear;
  late String seriesInfo;

  @override
  void initState() {
    super.initState();
    releaseDate = widget.series?.firstAirDate != ""
        ? DateTime.parse(widget.series!.firstAirDate!)
        : DateTime.now();

    releaseYear = '(${DateFormat('yyyy').format(releaseDate)})';
    seriesInfo = "${widget.series?.name ?? "Não informado"}  $releaseYear";
  }

  void sendPostAboutSeries(
    String userId,
    String username,
    String? profilePhoto,
  ) async {
    try{
      String response = await FirestoreMethods().sendPostAboutSeries(
        _contentController.text, 
        userId, 
        username, 
        profilePhoto, 
        widget.series!.id,
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
      backgroundColor: Color.fromRGBO(5, 39, 68, 1),
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
          IconButton(
            onPressed: () => sendPostAboutSeries(
              user.id, 
              user.username, 
              user.profilePhoto
            ), 
            icon: Icon(
              Icons.check,
              size: 30,
            )
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
            Container(
              width: 120,
              child: SizedBox(
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
                            fit: BoxFit.cover,
                          )
                        : Container(
                            width: 120,
                            height: 180,
                            color: Colors.grey,
                          ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
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
                  hintText: 'O que você achou do filme?',
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