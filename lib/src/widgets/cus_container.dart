import 'package:flutter/material.dart';
import 'package:dotted_border/dotted_border.dart';

class CustomContainer extends StatelessWidget {
  final double? width;
  final double? height;
  final Color? color;
  final Widget? child;
  final EdgeInsets? padding;
  final Alignment? alignment;
  final bool cartDes;
  final bool cartGra;
  final bool iconGra;
  final bool titleCart;
  final bool useDottedBorder;
  final Color? borderColor;
  const CustomContainer({
    Key? key,
    this.color = Colors.white,
    this.width,
    this.height,
    this.child,
    this.padding,
    this.alignment,
    this.cartDes = false,
    this.cartGra = false,
    this.iconGra = false,
    this.titleCart = false,
    this.useDottedBorder = false,
    this.borderColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BoxDecoration fullDesign = BoxDecoration(
      //boxShadow: [],
      borderRadius: BorderRadius.all(
        Radius.circular(8),
      ),
    );

    BoxDecoration cartDesign = BoxDecoration(
      boxShadow: [
        BoxShadow(
          color: Colors.grey.shade200,
          // blurRadius:,
        ),
      ],
      color: color,
      borderRadius: BorderRadius.all(
        Radius.circular(11),
      ),
    );

    BoxDecoration dotdesign = BoxDecoration(
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.grey.shade200,
      //     // blurRadius:,
      //   ),
      // ],
      color: Colors.transparent,
      borderRadius: BorderRadius.all(
        Radius.circular(11),
      ),
    );

    BoxDecoration iconDesign = BoxDecoration(
      color: color,
      // boxShadow: [
      //   BoxShadow(
      //     color: Colors.black12,
      //     blurRadius: 8,
      //   ),
      // ],
      borderRadius: BorderRadius.circular(20),
      // gradient: LinearGradient(
      //   begin: Alignment(0.72, 0.7),
      //   end: Alignment(-0.72, -0.7),
      //   colors: [
      //     Theme.of(context).colorScheme.secondary,
      //     Theme.of(context).colorScheme.onSecondary
      //   ],
      // ),
      border: Border.all(
        color: Theme.of(context).primaryColor,
      ),
    );

    ShapeDecoration cartLinearGradient = ShapeDecoration(
      // shadows: [
      //   BoxShadow(
      //     color: Colors.black12,
      //     blurRadius: 16,
      //   ),
      // ],
      gradient: LinearGradient(
        begin: Alignment(0.99, -0.16),
        end: Alignment(-0.99, 0.16),
        colors: [
          Theme.of(context).colorScheme.surface,
          Theme.of(context).colorScheme.surface
        ],
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        // side: const BorderSide(width: 3),
      ),
    );

    BoxDecoration titleCartGradient = BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(5), topRight: Radius.circular(5)),
    );
    return Container(
        width: width,
        height: height,
        padding: padding,
        alignment: alignment,
        child: cartGra && useDottedBorder
            ? DottedBorder(
                color: borderColor!,
                strokeWidth: 2.5,
                radius: Radius.circular(8),
                borderType: BorderType.RRect,
                child: Container(
                  width: width,
                  height: height,
                  decoration: dotdesign,
                  child: child,
                ))
            : Container(
                decoration: cartDes
                    ? cartDesign
                    : cartGra
                        ? cartLinearGradient
                        : iconGra
                            ? iconDesign
                            : titleCart
                                ? titleCartGradient
                                : fullDesign,
                width: width,
                height: height,
                padding: padding,
                alignment: alignment,
                child: child,
              ));
  }
}
