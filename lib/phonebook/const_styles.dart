library sg_styles;

import 'package:flutter/material.dart';

import 'const_colors.dart';

// TODO: Separate utils styles from constants

// BORDER RADIUS
const BorderRadius INPUT_FIELD_RADIUS =  BorderRadius.all(Radius.circular(10.0));

// TEXT SIZE
const double ERROR_TEXT = 13.0;

// TEXT STYLES
const TextStyle GREY_TEXT = TextStyle(
    color: BLACK_COLOUR
);

// BORDERS
const GREY_BORDER = BorderSide(
    color: LIGHT_GREY_COLOUR
);

// INPUT TEXT BOX DECORATION
const GREY_INPUT_BOX = OutlineInputBorder(
    borderSide: GREY_BORDER,
    borderRadius: INPUT_FIELD_RADIUS
);

