// Assignment 9 Question 1

/*--------------------------------*
|        GRAPHICS SETTINGS        |
*--------------------------------*/
// ----- YOU MAY MODIFY THESE VARIABLES -----
// Resolution
int screenX = 1280; // Sets the vertical resolution. If unsure, set this to the width of your computer's screen.
int screenY = 720; // Sets the horizontal resolution. If unsure, set this to the height of your computer's screen.

// Frame rate
int fps = 60; // Sets the frame rate limit. If unsure, set this to 60.
boolean showFPSCounter = true; // Shows an FPS counter at the top left of the screen when set to true. Useful for optimizing other graphics settings.

// Text
int textSize = 20; // Sets the size of text. Recommended values are between 10 and 40.

// Debugging
boolean showDebugInfo = false; // Shows rendering statistics and camera position/location at the top left of the screen. Only useful for debugging. If unsure, set this to false.
boolean wireFrameRendering = false; // Enables wireframe rendering when set to true. May cause slowdowns! If unsure, set this to false.

/*-------------------------------*
|         INPUT SETTINGS         |
*-------------------------------*/
// ----- YOU MAY MODIFY THESE VARIABLES -----
// Mouse settings
boolean useMouseToLook = false; // Enables using the mouse to look around when set to true. You may need to give Processing extra permissions in your computer's settings to use this feature.
int mouseSensitivity = 10; // Sets the mouse sensitivity. Set this to any value between 1 and 100. Higher numbers make the mouse more sensitive. This setting is ignored when useMouseToLook is set to false.

// Keybinds
char moveForward = 'w'; // Key to move forward
char moveBackward = 's'; // Key to move backward
char moveLeft = 'a'; // Key to move left
char moveRight = 'd'; // Key to move right
char interactWithObject = 'f'; // Key to pick up food/feed monkey

/*-------------------------------*
|         GAME VARIABLES         |
*-------------------------------*/
// ----- DO NOT MODIFY ANY VARIABLES PAST THIS POINT -----
import java.util.Arrays;
import java.lang.management.ManagementFactory;
import java.lang.management.RuntimeMXBean;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.MouseInfo;

RuntimeMXBean rb = ManagementFactory.getRuntimeMXBean();
PFont f;

// Size of ground plane
int planeSize = 10;

// Monkey variables
float monkeyX = 0;
float monkeyY = -6;
float monkeyZ = 1.1;
float monkeySpeed = 2;

// Apple variables
float appleX = -planeSize + 0.7; 
float appleY = -planeSize + 0.7;
float appleZ = 0.8;

// Banana variables
float bananaX = planeSize - 0.7;
float bananaY = planeSize - 0.7;
float bananaZ = 0.8;

// Player variables
boolean hasBanana = false;
boolean hasApple = false;
float itemHoldDistance = 1.3;
float runSpeed = 6;

// Used for calculating frame render times and current frame rate
long frameStartTime;
long totalFrameRenderTime;
float currentFPS;

// Instance of renderer
renderer screen;

// 3D models
model groundplane;
model cube;
// Apple models
model appleBody;
model appleNearStem;
model appleStem;
// Banana models
model bananaBody;
model bananaStem;
model bananaStemEdge;
// Monkey models
model monkeyHead;
model monkeyEyes;
model monkeyPupils;
model monkeyNose;
model monkeyMouth;
model monkeyEars;


void settings() {
  // Check if resolution is valid and set resolution
  if (screenX < 125 || screenX > 7680 || screenY < 125 || screenY > 4320) {
    screenX = 1280;
    screenY = 720;
    println("Invalid screenX and/or screenY setting! Using default resolution of 1280x720.");
  }
  // Create window
  size(screenX, screenY);
}


void setup() {
  // Check if fps is valid and set fps
  if (fps < 1 || fps > 1000) {
    fps = 60;
    println("Invalid FPS setting! Using default value of 60.");
  }
  frameRate(fps);
  currentFPS = fps;
  
  // Check if text size is valid and set text size
  if (textSize < 1 || textSize > screenY / 2) {
    textSize = 20;
    println("Invalid textSize setting! Using default value of 20.");
  }
  
  // Check if mouse sensitivity is valid and set mouse sensitivity
  if (mouseSensitivity < 1 || mouseSensitivity > 100) {
    mouseSensitivity = 50;
    println("Invalid mouse sensitivity setting! Using default value of 50.");
  }
  
  // Set up text font
  f = createFont("Arial", textSize, true);
  
  // Set up instance of renderer
  screen = new renderer(0, 0, screenX, screenY);
  screen.wireFrame = wireFrameRendering;
  screen.showDebugInfo = showDebugInfo;
  // Set up camera
  screen.cameraY = 0;
  screen.cameraZ = 2;
  screen.cameraXRotation = PI / 2;
  
  // Load 3D models
  groundplane = new model("3dmodels/groundplane.obj", 0, 100, 0, 255);
  cube = new model("3dmodels/cube2.obj", 100, 100, 100, 255);
  // Load apple models
  appleBody = new model("3dmodels/applebody.obj", 187, 50, 47, 255);
  appleNearStem = new model("3dmodels/applenearstem.obj", 177, 179, 66, 255);
  appleStem = new model("3dmodels/applestem.obj", 62, 50, 28, 255);
  // Load banana models
  bananaBody = new model("3dmodels/bananabody.obj", 195, 151, 54, 255);
  bananaStem = new model("3dmodels/bananastem.obj", 177, 179, 66, 255);
  bananaStemEdge = new model("3dmodels/bananastemedge.obj", 41, 30, 25, 255);
  // Load monkey models
  monkeyHead = new model("3dmodels/monkeyhead.obj", 50, 50, 0, 255);
  monkeyEyes = new model("3dmodels/monkeyeyes.obj", 255, 255, 255, 255);
  monkeyPupils = new model("3dmodels/monkeypupils.obj", 0, 0, 0, 255);
  monkeyNose = new model("3dmodels/monkeynose.obj", 100, 100, 0, 255);
  monkeyMouth = new model("3dmodels/monkeymouth.obj", 100, 0, 100, 255);
  monkeyEars = new model("3dmodels/monkeyears.obj", 200, 0, 200, 255);
  
  // Setup mouse position
  if (useMouseToLook) {
    try{
      Robot bot = new Robot();
      bot.mouseMove(200, 200);
    } catch (AWTException e) {
      println("Cannot move mouse!", e);
    }
  }
}


void draw() {
  // Used to calculate frame render times
  frameStartTime = rb.getUptime();
  
  // Set background color
  background(255, 255, 255);
  
  /*--------------------------------*
  |       REGISTER USER INPUT       |
  *--------------------------------*/
  
  // Register key inputs
  if (keyPressed) {
    if (key == CODED) {
      if (keyCode == UP) {
        screen.cameraXRotation += PI / currentFPS;
      }
      if (keyCode == DOWN) {
        screen.cameraXRotation -= PI / currentFPS;
      }
      if (keyCode == LEFT) {
        screen.cameraZRotation += PI / currentFPS;
      }
      if (keyCode == RIGHT) {
        screen.cameraZRotation -= PI / currentFPS;
      }
    }
    if (key == moveForward) {
      screen.cameraY -= (float)runSpeed / currentFPS * cos(screen.cameraZRotation);
      screen.cameraX -= (float)runSpeed / currentFPS * sin(screen.cameraZRotation);
    }
    if (key == moveBackward) {
      screen.cameraY += (float)runSpeed / currentFPS * cos(screen.cameraZRotation);
      screen.cameraX += (float)runSpeed / currentFPS * sin(screen.cameraZRotation);
    }
    if (key == moveLeft) {
      screen.cameraY -= (float)runSpeed / currentFPS * -sin(screen.cameraZRotation);
      screen.cameraX -= (float)runSpeed / currentFPS * cos(screen.cameraZRotation);
    }
    if (key == moveRight) {
      screen.cameraY += (float)runSpeed / currentFPS * -sin(screen.cameraZRotation);
      screen.cameraX += (float)runSpeed / currentFPS * cos(screen.cameraZRotation);
    }
  }
  
  // Register mouse movement
  if (useMouseToLook) {
    // Get mouse position
    float mouseXPos = MouseInfo.getPointerInfo().getLocation().x - 200;
    float mouseYPos = MouseInfo.getPointerInfo().getLocation().y - 200;
    // Rotate camera based on mouse movement
    screen.cameraXRotation += -mouseYPos * mouseSensitivity / 10000;
    screen.cameraZRotation += -mouseXPos * mouseSensitivity / 10000;
    // Move mouse back
    try{
      Robot bot = new Robot();
      bot.mouseMove(200, 200);
    } catch (AWTException e) {
      println("Cannot move mouse!", e);
    }
  }
  
  // Keep X rotation between 0 and pi
  if (screen.cameraXRotation > PI) {
    screen.cameraXRotation = PI;
  } else if (screen.cameraXRotation < 0) {
    screen.cameraXRotation = 0;
  }
  // Keep Z rotation between 0 and 2pi
  if (screen.cameraZRotation >= 2 * PI) {
    screen.cameraZRotation = 0;
  } else if (screen.cameraZRotation < 0) {
    screen.cameraZRotation = 2 * PI;
  }
  
  /*-------------------------------*
  |        HANDLE COLLISION        |
  *-------------------------------*/
  
  // Collision for food tables
  if (screen.cameraX > planeSize - 2 && screen.cameraY > planeSize - 2) {
    if (screen.cameraX - planeSize + 2 < screen.cameraY - planeSize + 2) {
      screen.cameraX = planeSize - 2;
    } else {
      screen.cameraY = planeSize - 2;
    }
  }
  if (screen.cameraX < -planeSize + 2 && screen.cameraY < -planeSize + 2) {
    if (screen.cameraX + planeSize - 2 > screen.cameraY + planeSize - 2) {
      screen.cameraX = -planeSize + 2;
    } else {
      screen.cameraY = -planeSize + 2;
    }
  }
  // Collision for edges of ground plane
  if (screen.cameraX < -planeSize) {
    screen.cameraX = -planeSize;
  } else if (screen.cameraX > planeSize) {
    screen.cameraX = planeSize;
  }
  if (screen.cameraY < -planeSize) {
    screen.cameraY = -planeSize;
  } else if (screen.cameraY > planeSize) {
    screen.cameraY = planeSize;
  }
  
  /*-------------------------------*
  |           GAME LOGIC           |
  *-------------------------------*/
  
  // Array of models to render
  ArrayList<model> world = new ArrayList<model>();
  
  /*-------------------------------*
  |          MONKEY LOGIC          |
  *-------------------------------*/
  
  // Collision for monkey (forces you away if you get too close)
  float monkeyDistanceToCamera = dist(screen.cameraX, screen.cameraY, monkeyX, monkeyY);
  float monkeyAngleToCamera = atan2(monkeyY - screen.cameraY, monkeyX - screen.cameraX);
  if (monkeyDistanceToCamera < 2.4) {
    // Force camera away
    if (abs(monkeyY - screen.cameraY) < abs(monkeyX - screen.cameraX)) {
      screen.cameraX = monkeyX - 2.4 * cos(monkeyAngleToCamera);
    } else {
      screen.cameraY = monkeyY - 2.4 * sin(monkeyAngleToCamera);
    }
  }
  
  if (hasBanana || hasApple) {
    // Red eyes when player has food
    monkeyEyes.r = 255;
    monkeyEyes.g = 0;
    monkeyEyes.b = 0;
    // Follow camera
    if (monkeyDistanceToCamera > 2.4) {
      monkeyX -= monkeySpeed * cos(monkeyAngleToCamera) / currentFPS;
      monkeyY -= monkeySpeed * sin(monkeyAngleToCamera) / currentFPS;
    }
  } else if (dist(monkeyX, monkeyY, monkeyZ, bananaX, bananaY, bananaZ) < 3 && dist(monkeyX, monkeyY, monkeyZ, bananaX, bananaY, bananaZ) > 0.6 || dist(monkeyX, monkeyY, monkeyZ, appleX, appleY, appleZ) < 3 && dist(monkeyX, monkeyY, monkeyZ, appleX, appleY, appleZ) > 0.6) {
    // Cyan eyes when being fed
    monkeyEyes.r = 0;
    monkeyEyes.g = 255;
    monkeyEyes.b = 255;
  } else {
    // Normal eyes
    monkeyEyes.r = 255;
    monkeyEyes.g = 255;
    monkeyEyes.b = 255;
  }
  
  // Add monkey models to world
  model[] monkey = new model[]{monkeyHead.cloneModel(), monkeyEyes.cloneModel(), monkeyPupils.cloneModel(), monkeyNose.cloneModel(), monkeyMouth.cloneModel(), monkeyEars.cloneModel()};
  for (int m = 0; m < monkey.length; m++) {
    monkey[m].scaleModel(0.8, 0.8, 0.8);
    if (hasBanana || dist(monkeyX, monkeyY, monkeyZ, bananaX, bananaY, bananaZ) < 3 && dist(monkeyX, monkeyY, monkeyZ, bananaX, bananaY, bananaZ) > 0.6) {
      // Monkey looks at banana
      monkey[m].rotateModel(0, atan2(bananaZ - monkeyZ, dist(bananaX, bananaY, monkeyX, monkeyY)), 0);
      monkey[m].rotateModel(0, 0, atan2(monkeyY - bananaY, monkeyX - bananaX));
    } else if (hasApple || dist(monkeyX, monkeyY, monkeyZ, appleX, appleY, appleZ) < 3 && dist(monkeyX, monkeyY, monkeyZ, appleX, appleY, appleZ) > 0.6) {
      // Monkey looks at apple
      monkey[m].rotateModel(0, atan2(appleZ - monkeyZ, dist(appleX, appleY, monkeyX, monkeyY)), 0);
      monkey[m].rotateModel(0, 0, atan2(monkeyY - appleY, monkeyX - appleX));
    } else {
      // Monkey looks at camera
      monkey[m].rotateModel(0, atan2(screen.cameraZ - monkeyZ, monkeyDistanceToCamera), 0);
      monkey[m].rotateModel(0, 0, monkeyAngleToCamera);
    }
    monkey[m].translateModel(monkeyX, monkeyY, monkeyZ);
    // Add to world
    world.add(monkey[m]);
  }

  /*-------------------------------*
  |          BANANA LOGIC          |
  *-------------------------------*/
  
  // Add banana models to world
  model[] banana = new model[]{bananaBody.cloneModel(), bananaStem.cloneModel(), bananaStemEdge.cloneModel()};
  for (int m = 0; m < banana.length; m++) {
    banana[m].scaleModel(0.2, 0.2, 0.2);
    if (hasBanana) {
      banana[m].rotateModel(-screen.cameraXRotation + PI / 2, 0, 0);
      banana[m].rotateModel(0, 0, -screen.cameraZRotation);
      // Hold in front of camera
      bananaX = screen.cameraX + itemHoldDistance * cos(-screen.cameraZRotation - PI / 2) * -cos(-screen.cameraXRotation - PI / 2);
      bananaY = screen.cameraY + itemHoldDistance * sin(-screen.cameraZRotation - PI / 2) * -cos(-screen.cameraXRotation - PI / 2);
      bananaZ = screen.cameraZ + itemHoldDistance * sin(-screen.cameraXRotation - PI / 2);
    } else if (dist(monkeyX, monkeyY, monkeyZ, bananaX, bananaY, bananaZ) < 3 && dist(monkeyX, monkeyY, monkeyZ, bananaX, bananaY, bananaZ) > 0.6) {
      // Move towards monkey
      bananaX += 1 * cos(atan2(monkeyY - bananaY, monkeyX - bananaX)) / currentFPS;
      bananaY += 1 * sin(atan2(monkeyY - bananaY, monkeyX - bananaX)) / currentFPS;
      bananaZ += 1 * (monkeyZ - bananaZ) / currentFPS;
    } else {
      // Move to food table
      bananaX = planeSize - 0.7;
      bananaY = planeSize - 0.7;
      bananaZ = 0.8;
    }
    banana[m].translateModel(bananaX, bananaY, bananaZ);
    // Add to world
    world.add(banana[m]);
  }
  
  /*--------------------------------*
  |           APPLE LOGIC           |
  *--------------------------------*/
  
  // Add apple models to world
  model[] apple = new model[]{appleBody.cloneModel(), appleNearStem.cloneModel(), appleStem.cloneModel()};
  for (int m = 0; m < apple.length; m++) {
    apple[m].scaleModel(0.2, 0.2, 0.2);
    if (hasApple) {
      apple[m].rotateModel(-screen.cameraXRotation + PI / 2, 0, 0);
      apple[m].rotateModel(0, 0, -screen.cameraZRotation);
      // Hold in front of camera
      appleX = screen.cameraX + itemHoldDistance * cos(-screen.cameraZRotation - PI / 2) * -cos(-screen.cameraXRotation - PI / 2);
      appleY = screen.cameraY + itemHoldDistance * sin(-screen.cameraZRotation - PI / 2) * -cos(-screen.cameraXRotation - PI / 2);
      appleZ = screen.cameraZ + itemHoldDistance * sin(-screen.cameraXRotation - PI / 2);
    } else if (dist(monkeyX, monkeyY, monkeyZ, appleX, appleY, appleZ) < 3 && dist(monkeyX, monkeyY, monkeyZ, appleX, appleY, appleZ) > 0.6) {
      // Move towards monkey
      appleX += 1 * cos(atan2(monkeyY - appleY, monkeyX - appleX)) / currentFPS;
      appleY += 1 * sin(atan2(monkeyY - appleY, monkeyX - appleX)) / currentFPS;
      appleZ += 1 * (monkeyZ - appleZ) / currentFPS;
    } else {
      // Move to food table
      appleX = -planeSize + 0.7;
      appleY = -planeSize + 0.7;
      appleZ = 0.8;
    }
    apple[m].translateModel(appleX, appleY, appleZ);
    // Add to world
    world.add(apple[m]);
  }
  
  /*--------------------------------*
  |    ADD OTHER MODELS TO WORLD    |
  *--------------------------------*/
  
  // Generate ground plane
  for (int y = -planeSize + 1; y < planeSize + 1; y++) {
    for (int x = -planeSize; x < planeSize; x++) {
      if (x > -planeSize + 1 && y < planeSize - 1 || x < planeSize - 2 && y > -planeSize + 2) {
        model groundplane1 = groundplane.cloneModel();
        groundplane1.translateModel(x, y, 0);
        if (y % 2 == 0 ^ x % 2 == 0) {
          groundplane1.g = 50;
        }
        world.add(groundplane1);
      }
    }
  }
  // Add tables for food at corners of ground plane
  model cube1 = cube.cloneModel();
  cube1.scaleModel(1, 1, 0.25);
  cube1.translateModel(-planeSize + 1, -planeSize + 1, 0.25);
  world.add(cube1);
  model cube2 = cube.cloneModel();
  cube2.scaleModel(1, 1, 0.25);
  cube2.translateModel(planeSize - 1, planeSize - 1, 0.25);
  world.add(cube2);
  
  /*-------------------------------*
  |          RENDER WORLD          |
  *-------------------------------*/
  
  // Convert world arraylist to array
  model[] worldArray = new model[world.size()];
  worldArray = world.toArray(worldArray);
  // Translate and rotate models to camera coordinate system
  for (int m = 0; m < world.size(); m++) {
    worldArray[m].translateModel(-screen.cameraX, -screen.cameraY, -screen.cameraZ);
    worldArray[m].rotateModel(screen.cameraXRotation, screen.cameraYRotation, screen.cameraZRotation);
  }
  // Render world on screen
  screen.renderToScreen(worldArray, 0, 127, 255);
  
  /*-------------------------------*
  |    ADD OTHER TEXT ON SCREEN    |
  *-------------------------------*/
  
  // Interaction prompt for picking up banana
  if (dist(screen.cameraX, screen.cameraY, screen.cameraZ, bananaX, bananaY, bananaZ) < 3 && !hasBanana && !(dist(monkeyX, monkeyY, monkeyZ, bananaX, bananaY, bananaZ) < 3 && dist(monkeyX, monkeyY, monkeyZ, bananaX, bananaY, bananaZ) > 0.5)) {
    fill(255, 255, 255);
    textFont(f, textSize);
    textAlign(CENTER, CENTER);
    text("Press " + interactWithObject + " to pick up Banana", screen.renderViewX + screen.renderViewWidth / 2, screen.renderViewY + screen.renderViewHeight / 2);
  }
  
  // Interaction prompt for picking up apple
  if (dist(screen.cameraX, screen.cameraY, screen.cameraZ, appleX, appleY, appleZ) < 3 && !hasApple && !(dist(monkeyX, monkeyY, monkeyZ, appleX, appleY, appleZ) < 3 && dist(monkeyX, monkeyY, monkeyZ, appleX, appleY, appleZ) > 0.5)) {
    fill(255, 255, 255);
    textFont(f, textSize);
    textAlign(CENTER, CENTER);
    text("Press " + interactWithObject + " to pick up Apple", screen.renderViewX + screen.renderViewWidth / 2, screen.renderViewY + screen.renderViewHeight / 2);
  }
  
  // Interaction prompt for feeding banana to monkey
  if (dist(bananaX, bananaY, bananaZ, monkeyX, monkeyY, monkeyZ) < 3 && hasBanana) {
    fill(255, 255, 255);
    textFont(f, textSize);
    textAlign(CENTER, CENTER);
    text("Press " + interactWithObject + " to feed Banana to Monkey", screen.renderViewX + screen.renderViewWidth / 2, screen.renderViewY + screen.renderViewHeight / 2);
  }
  
  // Interaction prompt for feeding apple to monkey
  if (dist(appleX, appleY, appleZ, monkeyX, monkeyY, monkeyZ) < 3 && hasApple) {
    fill(255, 255, 255);
    textFont(f, textSize);
    textAlign(CENTER, CENTER);
    text("Press " + interactWithObject + " to feed Apple to Monkey", screen.renderViewX + screen.renderViewWidth / 2, screen.renderViewY + screen.renderViewHeight / 2);
  }
  
  // Save the render time for this frame
  totalFrameRenderTime = rb.getUptime() - frameStartTime;
}


// Workaround for a bug in Processing where pressing SHIFT or CONTROL would cause keys to be registered even if no keys were being pressed
void keyReleased() {
  keyPressed = false;
}

/*-------------------------------*
|   REGISTER OTHER KEY PRESSES   |
*-------------------------------*/

void keyPressed() {
  if (key == interactWithObject) {
    if (dist(screen.cameraX, screen.cameraY, screen.cameraZ, bananaX, bananaY, bananaZ) < 3 && !hasBanana && !(dist(monkeyX, monkeyY, monkeyZ, bananaX, bananaY, bananaZ) < 3 && dist(monkeyX, monkeyY, monkeyZ, bananaX, bananaY, bananaZ) > 0.5)) {
      hasBanana = true;
      hasApple = false;
      return;
    } else {
      hasBanana = false;
    }
    if (dist(screen.cameraX, screen.cameraY, screen.cameraZ, appleX, appleY, appleZ) < 3 && !hasApple && !(dist(monkeyX, monkeyY, monkeyZ, appleX, appleY, appleZ) < 3 && dist(monkeyX, monkeyY, monkeyZ, appleX, appleY, appleZ) > 0.5)) {
      hasApple = true;
      hasBanana = false;
      return;
    } else {
      hasApple = false;
    }
  }
}

/*--------------------------------*
|      CLASSES AND FUNCTIONS      |
*--------------------------------*/

// 3D model class
class model{
  float[][] verticies; // Stores points [[x1, y1, z1],...]
  int[][] faces; // Stores indexes of verticies array to make triangles [[v1, v2, v3],...]
  // Stores color of model
  int r;
  int g;
  int b;
  int a;
  
  // Constructor
  model(float[][] verticies, int[][] faces, int r, int g, int b, int a) {
    this.verticies = verticies;
    this.faces = faces;
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
  }
  
  // Constructor that takes an OBJ file
  model(String filename, int r, int g, int b, int a) {
    // Arrays of verticies and faces
    ArrayList<float[]> verticiesFromFile = new ArrayList<float[]>();
    ArrayList<int[]> facesFromFile = new ArrayList<int[]>();
    
    // Load verticies and faces from file
    String[] modelData = loadStrings(filename);
    for (int i = 0; i < modelData.length; i++) {
      // Add verticies
      if (modelData[i].charAt(0) == 'v') {
        float x = Float.parseFloat(split(modelData[i], ' ')[1]);
        float y = Float.parseFloat(split(modelData[i], ' ')[2]);
        float z = Float.parseFloat(split(modelData[i], ' ')[3]);
        verticiesFromFile.add(new float[]{x, y, z});
      }
      // Add faces
      if (modelData[i].charAt(0) == 'f') {
        int v1 = Integer.parseInt(split(modelData[i], ' ')[1]);
        int v2 = Integer.parseInt(split(modelData[i], ' ')[2]);
        int v3 = Integer.parseInt(split(modelData[i], ' ')[3]);
        facesFromFile.add(new int[]{v1, v2, v3});
      }
    }
    
    float[][] verticies = new float[verticiesFromFile.size()][];
    int[][] faces = new int[facesFromFile.size()][];
    
    this.verticies = verticiesFromFile.toArray(verticies);
    this.faces = facesFromFile.toArray(faces);
    this.r = r;
    this.g = g;
    this.b = b;
    this.a = a;
  }
  
  // Method for cloning model
  model cloneModel() {
    // Create deep copy of arrays so that modifying the clone of the model will not modify the original model
    // Java is really annoying lol
    final float[][] newVerticies = new float[this.verticies.length][3];
    final int[][] newFaces = new int[this.faces.length][3];
    for (int i = 0; i < this.verticies.length; i++) {
      newVerticies[i] = Arrays.copyOf(this.verticies[i], this.verticies[i].length);
    }
    for (int i = 0; i < this.faces.length; i++) {
      newFaces[i] = Arrays.copyOf(this.faces[i], this.faces[i].length);
    }
    // Return new model
    return new model(newVerticies, newFaces, this.r, this.g, this.b, this.a);
  }
  
  // Method for translating model
  void translateModel(float x, float y, float z) {
    for (int i = 0; i < verticies.length; i++) {
      this.verticies[i][0] += x;
      this.verticies[i][1] += y;
      this.verticies[i][2] += z;
    }
  }
  
  // Method for scaling model
  void scaleModel(float x, float y, float z) {
    for (int i = 0; i < verticies.length; i++) {
      this.verticies[i][0] *= x;
      this.verticies[i][1] *= y;
      this.verticies[i][2] *= z;
    }
  }
  
  // Method for rotating model
  void rotateModel(float x, float y, float z) {
    // Rotation matricies
    float[][] xMatrix = new float[][]{
      {1, 0, 0},
      {0, cos(x), -sin(x)}, 
      {0, sin(x), cos(x)}
    };
    float[][] yMatrix = new float[][]{
      {cos(y), 0, sin(y)},
      {0, 1, 0},
      {-sin(y), 0, cos(y)}
    };
    float[][] zMatrix = new float[][]{
      {cos(z), -sin(z), 0}, 
      {sin(z), cos(z), 0}, 
      {0, 0, 1}
    };
    // Rotate each vertex
    for (int i = 0; i < this.verticies.length; i++) {
      // convert vertex to matrix
      float[][] vertexMatrix = new float[][]{{this.verticies[i][0]}, {this.verticies[i][1]}, {this.verticies[i][2]}};
      // Rotate
      vertexMatrix = matMul(xMatrix, matMul(yMatrix, matMul(zMatrix, vertexMatrix)));
      // convert back to point
      this.verticies[i][0] = vertexMatrix[0][0];
      this.verticies[i][1] = vertexMatrix[1][0];
      this.verticies[i][2] = vertexMatrix[2][0];
    }
  }
}


// Class for rendering
// Made as a class to make it possible to create multiple rendering viewports for things like split-screen multiplayer
class renderer{
  // Position and size of render viewport
  int renderViewX;
  int renderViewY;
  int renderViewWidth;
  int renderViewHeight;
  // Camera position
  float cameraX;
  float cameraY;
  float cameraZ;
  // Camera rotation
  float cameraXRotation;
  float cameraYRotation;
  float cameraZRotation;
  // Renderer settings
  boolean wireFrame; // Enables wireframe rendering if set to true
  boolean showDebugInfo; // Shows a bunch of info on screen, only meant for debugging
  // Used for calculating frame render times
  private long startTime;
  private long zSortTime;
  private long processingDrawTime;
  
  // Constructor
  renderer(int renderViewX, int renderViewY, int renderViewWidth, int renderViewHeight) {
    // Set given values
    this.renderViewX = renderViewX;
    this.renderViewY = renderViewY;
    this.renderViewWidth = renderViewWidth;
    this.renderViewHeight = renderViewHeight;
    // Set other values to default values that can be changed later
    // These are not set in the constructor because that would make the constructor a huge mess
    this.wireFrame = false;
    this.showDebugInfo = false;
    this.cameraX = 0;
    this.cameraY = 0;
    this.cameraZ = 0;
    this.cameraXRotation = 0;
    this.cameraYRotation = 0;
    this.cameraZRotation = 0;
  }
  
  // Method for rendering objects to screen
  void renderToScreen(model[] models, int backgroundR, int backgroundG, int backgroundB) {
    this.startTime = rb.getUptime();
    
    // Fill render viewport with background color
    fill(backgroundR, backgroundG, backgroundB);
    rect(this.renderViewX, this.renderViewY, this.renderViewWidth, this.renderViewHeight);
    
    // Array to contain triangles [[x1, y1, z1, x2, y2, z2, x3, y3, z3, r, g, b, a],...]
    ArrayList<float[]> unsortedTriangles = new ArrayList<float[]>();
    
    // Choose triangles to sort
    for (int m = 0; m < models.length; m++) {
      for (int f = 0; f < models[m].faces.length; f++) {
        // Dont draw the triangle if it is either behind or too close to the camera
        float z1 = models[m].verticies[models[m].faces[f][0] - 1][2];
        float z2 = models[m].verticies[models[m].faces[f][1] - 1][2];
        float z3 = models[m].verticies[models[m].faces[f][2] - 1][2];
        if (z1 > -1 && z2 > -1 && z3 > -1) {
          continue;
        }
        // Dont draw the triangle if it is off screen
        float x1 = models[m].verticies[models[m].faces[f][0] - 1][0] / -z1 * this.renderViewHeight + this.renderViewX + this.renderViewWidth / 2;
        float x2 = models[m].verticies[models[m].faces[f][1] - 1][0] / -z2 * this.renderViewHeight + this.renderViewX + this.renderViewWidth / 2;
        float x3 = models[m].verticies[models[m].faces[f][2] - 1][0] / -z3 * this.renderViewHeight + this.renderViewX + this.renderViewWidth / 2;
        if (x1 < renderViewX || x1 > renderViewX + renderViewWidth) {
          if (x2 < renderViewX || x2 > renderViewX + renderViewWidth) {
            if (x3 < renderViewX || x3 > renderViewX + renderViewWidth) {
              continue;
            }
          }
        }
        float y1 = models[m].verticies[models[m].faces[f][0] - 1][1] / -z1 * this.renderViewHeight + this.renderViewY + this.renderViewHeight / 2;
        float y2 = models[m].verticies[models[m].faces[f][1] - 1][1] / -z2 * this.renderViewHeight + this.renderViewY + this.renderViewHeight / 2;
        float y3 = models[m].verticies[models[m].faces[f][2] - 1][1] / -z3 * this.renderViewHeight + this.renderViewY + this.renderViewHeight / 2;
        if (y1 < renderViewY || y1 > renderViewY + renderViewHeight) {
          if (y2 < renderViewY || y2 > renderViewY + renderViewHeight) {
            if (y3 < renderViewY || y3 > renderViewY + renderViewHeight) {
              continue;
            }
          }
        }
        unsortedTriangles.add(new float[]{x1, y1, z1, x2, y2, z2, x3, y3, z3, models[m].r, models[m].g, models[m].b, models[m].a});
      }
    }
    
    // Sort triangles by z
    float[][] triangles = new float[unsortedTriangles.size()][13];
    triangles = unsortedTriangles.toArray(triangles);
    zSort(triangles, triangles.length);
    this.zSortTime = rb.getUptime() - this.startTime;
    
    
    // Draw triangles
    for (int t = 0; t < triangles.length; t++) {
      if (wireFrame) {
        stroke(triangles[t][9], triangles[t][10], triangles[t][11]);
        strokeWeight(0);
        noFill();
      } else {
        noStroke();
        fill(triangles[t][9], triangles[t][10], triangles[t][11], triangles[t][12]);
      }
      triangle(triangles[t][0], triangles[t][1], triangles[t][3], triangles[t][4], triangles[t][6], triangles[t][7]);
    }
    
    // Draw debug info if enabled
    if (showDebugInfo) {
      fill(255, 255, 255);
      textFont(f, textSize);
      textAlign(LEFT, TOP);
      
      // Calculate current frame rate
      currentFPS = (float)1000 / totalFrameRenderTime;
      if (currentFPS > fps) {
        currentFPS = fps;
      }
      
      // List of text to show
      String[] debugText = new String[]{
        "----- RENDER DATA -----",
        "Window size: " + Integer.toString(width) + "x" + Integer.toString(height),
        "Render viewport size: " + Integer.toString(this.renderViewWidth) + "x" + Integer.toString(this.renderViewHeight),
        "FPS target: " + Integer.toString(fps),
        "Current FPS: " + Float.toString(currentFPS),
        "Total frame render time (all renderers) (ms): " + Long.toString(totalFrameRenderTime),
        "Z sorting/other stuff time (this renderer) (ms): " + Long.toString(this.zSortTime),
        "Processing draw time (this renderer) (ms): " + Long.toString(this.processingDrawTime),
        "----- RENDER SETTINGS -----",
        "Wireframe rendering: " + Boolean.toString(this.wireFrame),
        "----- POSITION/ROTATION DATA -----",
        "X position: " + Float.toString(this.cameraX),
        "Y position: " + Float.toString(this.cameraY),
        "Z position: " + Float.toString(this.cameraZ),
        "X rotation: " + Float.toString(degrees(this.cameraXRotation)),
        "Y rotation: " + Float.toString(degrees(this.cameraYRotation)),
        "Z rotation: " + Float.toString(degrees(this.cameraZRotation)),
      };
      
      // Draw debug text
      for (int i = 0; i < debugText.length; i++) {
        text(debugText[i], this.renderViewX, this.renderViewY + textSize * i);
      }
      
      // Draw outline around render viewport
      stroke(255, 255, 0);
      noFill();
      rect(this.renderViewX, this.renderViewY, this.renderViewWidth, this.renderViewHeight);
      // Draw number of triangles on screen
      textAlign(LEFT, BOTTOM);
      fill(255, 255, 0);
      text("Triangles on screen: " + Integer.toString(triangles.length), this.renderViewX, this.renderViewY + this.renderViewHeight);
    } else if (showFPSCounter) {
      fill(255, 255, 255);
      textFont(f, textSize);
      textAlign(LEFT, TOP);
      
      // Calculate current frame rate
      float currentFPS = (float)1000 / totalFrameRenderTime;
      if (currentFPS > fps) {
        currentFPS = fps;
      }
      
      // Show FPS counter
      text("Current FPS: " + Float.toString(currentFPS), this.renderViewX, this.renderViewY);
    }
    
    this.processingDrawTime = rb.getUptime() - this.startTime;
  }
  
  // Methods for sorting triangles
  private void zSort(float[][] triangles, int n) {
    if (n < 2) {
      return;
    }
    int mid = n / 2;
    float[][] l = new float[mid][13];
    float[][] r = new float[n - mid][13];
    for (int i = 0; i < mid; i++) {
      l[i] = triangles[i];
    }
    for (int i = mid; i < n; i++) {
      r[i - mid] = triangles[i];
    }
    zSort(l, mid);
    zSort(r, n - mid);
    merge(triangles, l, r, mid, n - mid);
  }
  private void merge(float[][] triangles, float[][] l, float[][] r, int left, int right) {
    int i = 0;
    int j = 0;
    int k = 0;
    while (i < left && j < right) {
      // All points of triangle 1
      float t1_z1 = l[i][2];
      float t1_z2 = l[i][5];
      float t1_z3 = l[i][8];
      // All points of triangle 2
      float t2_z1 = r[j][2];
      float t2_z2 = r[j][5];
      float t2_z3 = r[j][8];
      // Compare average z coordinates
      if (t1_z1 + t1_z2 + t1_z3 <= t2_z1 + t2_z2 + t2_z3) {
        triangles[k++] = l[i++];
      } else {
        triangles[k++] = r[j++];
      }
    }
    while (i < left) {
      triangles[k++] = l[i++];
    }
    while (j < right) {
      triangles[k++] = r[j++];
    }
  }
}


// Function for matrix multiplication
float[][] matMul(float[][] a, float[][] b) {
  float result[][] = new float[a.length][b[0].length];
  for (int i = 0; i < a.length; i++) {
    for (int j = 0; j < b[0].length; j++) {
      for (int k = 0; k < b.length; k++) {
        result[i][j] += a[i][k] * b[k][j];
      }
    }
  }
  return result;
}
