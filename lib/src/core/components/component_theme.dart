import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/src/utils/constants/common_constants.dart';

const Color colorPrimary = Color(0xFF2C7973);
const Color colorPrimaryReadMode = Color(0xFFF5A512);
Color colorPrimaryOpacity10 = const Color(0xFF2C7973).withOpacity(0.1);
Color colorPrimaryOpacity20 = const Color(0xFF2C7973).withOpacity(0.2);
Color colorPrimaryOpacity40 = const Color(0xFF2C7973).withOpacity(0.4);
Color colorPrimaryOpacity80 = const Color(0xFF2C7973).withOpacity(0.8);
const Color colorSecondary = Color(0xFFFFFFFF);
const Color colorSecondaryReadMode = Color(0xFFDFCEBC);
const Color transparent = Color(0x00000000);
const Color colorStar = Color(0xFFFFCE16);
Color colorGeneralCover = const Color(0xFF797d62).withOpacity(0.6);
Color colorHealthCover = const Color(0xFF9b9b7a).withOpacity(0.6);
Color colorBusinessCover = const Color(0xFFd9ae94).withOpacity(0.6);
Color colorSportsCover = const Color(0xFFf1dca7).withOpacity(0.6);
Color colorScienceCover = const Color(0xFFffcb69).withOpacity(0.6);
Color colorEntertainmentCover = const Color(0xFFd08c60).withOpacity(0.6);
Color colorTechnologyCover = const Color(0xFF997b66).withOpacity(0.6);

const Color colorsBlack = Color(0xFF000000);
const Color colorsBlackGray = Color.fromARGB(255, 27, 27, 27);
// const Color colorPrimary = Color(0xFF2E8EFF);
const Color colorWhite = Color(0xFFFFFFFF);
const Color colorGray = Color(0xFFEFEFEF);
const Color colorTextGray = Color(0xFF585858);
const Color buttonGray = Color(0xFFDEDEDE);
const Color borderGray = Color(0xFFE1E1E1);
const Color textGray = Color(0xFF595959);
const Color darkThemeText = Color.fromARGB(255, 135, 134, 134);

final ligthTheme = ThemeData(
    visualDensity: VisualDensity.adaptivePlatformDensity,
    primaryColor: colorPrimary,
    // primarySwatch: primaryCustomSwatch,
    brightness: Brightness.light,
    fontFamily: GoogleFonts.roboto().fontFamily,
    bottomSheetTheme:
        BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
    scaffoldBackgroundColor: Colors.white,
    backgroundColor: Colors.white,
    textTheme: const TextTheme(
      bodyText1: TextStyle(),
      bodyText2: TextStyle(),
    ).apply(
      bodyColor: colorsBlack,
      displayColor: colorsBlack,
    ),
    colorScheme: const ColorScheme.light()
        .copyWith(primary: colorPrimary, onPrimary: colorPrimary)
        .copyWith(
          primary: colorPrimary,
          secondary: colorPrimary,
          brightness: Brightness.light,
        ),
    textSelectionTheme: const TextSelectionThemeData(cursorColor: colorPrimary),
    // elevatedButtonTheme: ElevatedButtonThemeData(
    //   style: ElevatedButton.styleFrom(
    //     elevation: 0,
    //     foregroundColor: Colors.white,
    //     backgroundColor: colorPrimary,
    //     shape: const StadiumBorder(),
    //     maximumSize: const Size(double.infinity, 56),
    //     minimumSize: const Size(double.infinity, 56),
    //   ),
    // ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: colorPrimaryOpacity10,
      iconColor: colorPrimary,
      prefixIconColor: colorPrimary,
      contentPadding: EdgeInsets.symmetric(
          horizontal: CommonConstants.defaultPadding,
          vertical: CommonConstants.defaultPadding),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide.none,
      ),
    ));

final darkTheme = ThemeData(
  visualDensity: VisualDensity.adaptivePlatformDensity,
  primaryColor: colorPrimary,
  // primarySwatch: colorPrimary,
  backgroundColor: colorsBlack,
  progressIndicatorTheme: const ProgressIndicatorThemeData(
    color: Colors.white,
  ),
  brightness: Brightness.dark,
  textTheme: const TextTheme(
    bodyText1: TextStyle(),
    bodyText2: TextStyle(),
  ).apply(
    bodyColor: Colors.white,
    displayColor: Colors.white,
  ),
  fontFamily: GoogleFonts.roboto().fontFamily,
  bottomSheetTheme:
      BottomSheetThemeData(backgroundColor: Colors.black.withOpacity(0)),
  scaffoldBackgroundColor: colorsBlack,
  colorScheme: const ColorScheme.dark()
      .copyWith(primary: colorPrimary, onPrimary: colorPrimary)
      .copyWith(
        secondary: colorPrimary,
        brightness: Brightness.dark,
      ),
  textSelectionTheme: const TextSelectionThemeData(cursorColor: colorPrimary),
);
