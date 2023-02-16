# light

## About

A [Processing](https://processing.org/) example program utilising computer vision. Watch "bacteria" grow on the screen as you shine a light into the camera. 

The program detects the brightest point with the camera and reveals a part of the screen as if the user is illuminating it with their light source. Dark circles (representing bacteria) will appear and grow in the light. They will wither and disappear when left in the dark.

![demo.gif](demo.gif)

Homework for the Interaction and Information Design course at the University of Ljubljana, Faculty of Computer and Information Science in 2019.

## Tips

* Works best in a darker room.
* Enable or disable the debug mode in the header of the source code.
* Camera is set for a resolution of 176x144. If your camera has a different resolution you can change it with the two global variables *int camWidth* and *int camHeigh*. The program logs all supported resolutions of your system in the console at the start. 

