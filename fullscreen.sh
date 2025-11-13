#!/bin/bash

# ////
WIN_ID=$(xdotool getactivewindow)

#///
wmctrl -i -r $WIN_ID -b add,fullscreen
