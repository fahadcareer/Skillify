import 'package:Skillify/src/res/colors/colors.dart';
import 'package:Skillify/src/res/dimentions/app_dimensions.dart';
import 'package:Skillify/src/res/style/app_typography.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeClass {
  static ThemeData lightTheme(Color primaryColor) {
    return ThemeData(
      // textTheme: GoogleFonts.openSansTextTheme(),
      scaffoldBackgroundColor: Color(0xFFF7F8FA),
      useMaterial3: false,
      primaryColor: primaryColor,
      //  canvasColor :AppColors.textBoxColor,
      //  cardColor
//  dialogBackgroundColor :AppColors.textBlackColor,
//  disabledColor,
      dividerColor: Color(0xFFBFBFBF),
      focusColor: AppColors.textBoldColor,
      //  highlightColor :,
      hintColor: AppColors.textColor,
//  hoverColor,
      indicatorColor: AppColors.textBoxColor,
      // unselectedWidgetColor:AppColors.whiteColor,
//    splashColor,
// textSelectionTheme :TextSelectionThemeData(),
      textTheme: GoogleFonts.openSansTextTheme().copyWith(
        titleLarge: TextStyles.h1!.copyWith(
          color: AppColors.textBlackColor,
        ),
        titleMedium: TextStyles.h2!.copyWith(
          color: AppColors.textBlackColor,
        ),
        titleSmall: TextStyles.h3!.copyWith(
          color: AppColors.textBlackColor,
        ),
        bodyLarge: TextStyles.b1!.copyWith(
          color: AppColors.textBlackColor,
        ),
        bodyMedium: TextStyles.b2!.copyWith(
          color: AppColors.textBlackColor,
        ),
        bodySmall: TextStyles.b3!.copyWith(
          color: AppColors.textBlackColor,
        ),
        labelLarge: TextStyles.l1!.copyWith(
          color: AppColors.textBlackColor,
        ),
        labelMedium: TextStyles.l2!.copyWith(
          color: AppColors.textBlackColor,
        ),
      ),
      chipTheme: ChipThemeData(
          backgroundColor: AppColors.whiteColor,
          labelStyle: TextStyles.b2!.copyWith(
              color: AppColors.textColor, fontWeight: FontWeight.normal)),

      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(foregroundColor: Colors.white),

      cupertinoOverrideTheme: CupertinoThemeData(
          textTheme: CupertinoTextThemeData(
        dateTimePickerTextStyle: TextStyles.b1!.copyWith(
            color: AppColors.textBlackColor, fontSize: AppDimensions.font(10)),
      )),

      colorScheme: ColorScheme.fromSwatch()
          .copyWith(
            brightness: Brightness.light,
            primary: Color(0xFF1E3354),
            secondary: Color.fromARGB(255, 255, 255, 255),
            surface: Colors.white,
            background: Colors.brown,
            error: AppColors.redColor,
            onPrimary: primaryColor,
            onSecondary: Color.fromARGB(255, 253, 253, 253),
            onSurface: AppColors.grayColor,
            onBackground: Color(0xFF3D3D3D),
            onError: AppColors.whiteColor,
          )
          .copyWith(background: Colors.brown),
    );
  }

  static ThemeData darkTheme(Color primaryColor) {
    return ThemeData(
      // textTheme: GoogleFonts.openSansTextTheme(),
      useMaterial3: false,
      primaryColor: primaryColor,
      //  canvasColor :AppColors.textBoxColor,
      cardColor: Color(0xFF5E6267),
//  dialogBackgroundColor,
//  disabledColor,
// dialogBackgroundColor :Colors.white,
      dividerColor: Color(0xFFBFBFBF),
      focusColor: Color.fromRGBO(195, 205, 221, 0.898),
      //  highlightColor :,
      hintColor: Color(0xFFffffff),
//  hoverColor,
      indicatorColor: Color(0xFF575757),
      // unselectedWidgetColor: AppColors.wrapColor,
//    splashColor,

      chipTheme: ChipThemeData(
          backgroundColor: Color(0xFF3D3D3D),
          labelStyle: TextStyles.b2!.copyWith(
              color: AppColors.whiteColor, fontWeight: FontWeight.normal)),

      textTheme: GoogleFonts.openSansTextTheme().copyWith(
        titleLarge: TextStyles.h1!.copyWith(color: Color(0xFFededed)),
        titleMedium: TextStyles.h2!.copyWith(
          color: Color(0xFFededed),
        ),
        titleSmall: TextStyles.h3!.copyWith(
          color: Color(0xFFededed),
        ),
        bodyLarge: TextStyles.b1!.copyWith(
          color: Color(0xFFededed),
        ),
        bodyMedium: TextStyles.b2!.copyWith(
          color: Color(0xFFededed),
        ),
        bodySmall: TextStyles.b3!.copyWith(
          color: Color(0xFFededed),
        ),
        labelLarge: TextStyles.l1!.copyWith(
          color: Color(0xFFededed),
        ),
        labelMedium: TextStyles.l2!.copyWith(
          color: Color(0xFFededed),
        ),
      ),
      cupertinoOverrideTheme: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          dateTimePickerTextStyle: TextStyles.b1!
              .copyWith(color: Colors.white, fontSize: AppDimensions.font(10)),
        ),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        titleTextStyle: TextStyle(color: Colors.white),
      ),
      bottomSheetTheme:
          BottomSheetThemeData(backgroundColor: Color(0xFF3D3D3D)),
      floatingActionButtonTheme:
          FloatingActionButtonThemeData(foregroundColor: Colors.white),

      colorScheme: ColorScheme.fromSwatch()
          .copyWith(
            brightness: Brightness.dark,
            primary: Color(0xFF1E3354),
            secondary: Color(0xFF5E6267),
            surface: Color(0xFF5E6267),
            background: const Color.fromARGB(255, 206, 153, 134),
            error: AppColors.redColor,
            onPrimary: AppColors.whiteColor,
            onSecondary: Color(0xFF5E6267),
            onSurface: AppColors.grayColor,
            onBackground: Color(0xFF3D3D3D),
            onError: AppColors.whiteColor,
          )
          .copyWith(background: const Color.fromARGB(255, 206, 153, 134)),
    );
  }
}
