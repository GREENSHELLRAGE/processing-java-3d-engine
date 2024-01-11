# Processing Java 3D Engine

This was created as a final assignment for a first year computer science course. The assignment was to draw a "monster" on screen and be able to interact with it, and only required a simple 2D drawing of the "monster", which is really boring. So I exported the default monkey head mesh from Blender and made a crappy 3D engine to draw it in 3D.

The code could be significantly better optimized and all of the physics are completely hardcoded, but it ran well enough to get 100% on the assignment. Since I finished this course, I will not be actively updating this repo.

![Screenshot1](https://raw.githubusercontent.com/GREENSHELLRAGE/processing-java-3d-engine/main/screenshots/Screen%20Shot%202022-12-09%20at%2011.51.40%20PM.png)

![Screenshot2](https://raw.githubusercontent.com/GREENSHELLRAGE/processing-java-3d-engine/main/screenshots/Screen%20Shot%202022-12-09%20at%2011.52.27%20PM.png)

![Screenshot3](https://raw.githubusercontent.com/GREENSHELLRAGE/processing-java-3d-engine/main/screenshots/Screen%20Shot%202022-12-09%20at%2011.52.56%20PM.png)

# Dependencies

The computer science course used the Processing IDE which you can get from [here](https://processing.org/download). It has a built in 2D graphics API that makes it easy to draw polygons and text on screen.

# Original README.txt from the assignment

1. Setting up the program:


This program uses a custom scratch-built 3D engine to render its graphics. Like most other 3D games and programs, it may be necessary to change the graphics settings for optimal performance on your system. The graphics settings are clearly labelled and can be found at the beginning of the code. Here are a couple of general tips for optimizing the graphics settings:
- If the frame rate is low, try decreasing the resolution.
- Recommended resolutions:
	- 360p: 640x360
	- 480p: 848x480
	- 540p: 960x540
	- 720p: 1280x720 (default)
	- 1080p: 1920x1080
	- 1440p: 2560x1440
	- 2160p: 3840x2160
- It is recommended that you set the FPS limit to the refresh rate of your display (most displays run at 60Hz), however it can be lowered if you are experiencing very inconsistent frame rates.

There are also settings to change the controls for moving around and interacting with objects. This program also includes a feature that allows you to use your mouse to look around, however it may require giving Processing additional permissions in your computer's settings. If you cannot use the mouse to look around, you can use the arrow keys instead.


2. The monster:


The monster is a hungry monkey. You can find food at the corners of the map. When you pick up the food, the monkey's eyes will turn red and the monkey will chase the food. Bring the food close to the monkey to feed it. The monkey's eyes will turn blue when being fed.


3. Bugs:


- There is some code that tries to keep the speed of movement the same regardless of the current frame rate, however it is not perfect and slowdowns can occur if the frame rate is very inconsistent and/or low
- There is an edge case where the monkey gan get into an infinite loop of feeding itself if it is fed very close to the corner of the map where food spawns, however this loop can be stopped if you pick up food from the other corner of the map
- Program will crash if the 3d models are in the wrong folder
