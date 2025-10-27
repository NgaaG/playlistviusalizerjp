// Interactive Playlist Animation
// Dots pulse to simulated beats, click to pause/resume
// Background changes based on mood selection

// Animation variables
int numDots = 16;                    // Number of pulsing dots
float[] dotX = new float[numDots];   // X positions
float[] dotY = new float[numDots];   // Y positions  
float[] dotSize = new float[numDots]; // Current sizes
float[] baseDotSize = new float[numDots]; // Base sizes
float[] pulseSpeed = new float[numDots];  // Individual pulse rates
boolean paused = false;              // Pause state

// Playlist and mood settings
String playlistTitle = "Happy Beats Playlist";
String currentMood = "energetic";    // Options: calm, energetic, sad, happy

// Colors for different moods
color calmColor = color(70, 130, 180);      // Steel blue
color energeticColor = color(255, 140, 0);  // Dark orange
color sadColor = color(100, 100, 140);      // Muted blue-gray
color happyColor = color(255, 215, 0);      // Golden yellow

void setup() {
  size(800, 600);
  
  // Initialize dots in circular formation
  for (int i = 0; i < numDots; i++) {
    float angle = map(i, 0, numDots, 0, TWO_PI);
    float radius = 180;
    dotX[i] = width/2 + cos(angle) * radius;
    dotY[i] = height/2 + sin(angle) * radius + 40; // Offset for title
    baseDotSize[i] = random(15, 25);
    dotSize[i] = baseDotSize[i];
    pulseSpeed[i] = random(0.02, 0.08); // Randomized beat speeds
  }
  
  textAlign(CENTER, CENTER);
}

void draw() {
  // Set background based on current mood
  setMoodBackground();
  
  // Display playlist title
  drawPlaylistTitle();
  
  // Draw pulsing dots
  drawPulsingDots();
  
  // Show pause indicator
  if (paused) {
    drawPauseIndicator();
  }
  
  // Only animate if not paused
  if (!paused) {
    animateDots();
  }
}

void setMoodBackground() {
  // Change background color based on selected mood
  switch(currentMood) {
    case "calm":
      background(calmColor);
      break;
    case "energetic":
      background(energeticColor);
      break;
    case "sad":
      background(sadColor);
      break;
    case "happy":
      background(happyColor);
      break;
    default:
      background(100); // Default gray
  }
}

void drawPlaylistTitle() {
  // Set title text properties
  fill(255, 200); // Semi-transparent white
  textSize(32);
  textAlign(CENTER);
  
  // Draw title at top of screen
  text(playlistTitle, width/2, 60);
  
  // Draw mood indicator
  textSize(16);
  text("Mood: " + currentMood.toUpperCase(), width/2, 100);
}

void drawPulsingDots() {
  // Draw each animated dot
  for (int i = 0; i < numDots; i++) {
    // Set dot appearance
    fill(255, 180); // Semi-transparent white
    noStroke();
    
    // Draw dot with current size
    ellipse(dotX[i], dotY[i], dotSize[i], dotSize[i]);
    
    // Add subtle glow effect
    fill(255, 60);
    ellipse(dotX[i], dotY[i], dotSize[i] * 1.5, dotSize[i] * 1.5);
  }
}

void animateDots() {
  // Update each dot's pulsing animation
  for (int i = 0; i < numDots; i++) {
    // Create pulsing effect using sine wave
    float pulse = sin(frameCount * pulseSpeed[i] + i * 0.5);
    
    // Scale pulse to create size variation
    float sizeMultiplier = 1 + pulse * 0.6; // Pulse between 40% and 160% of base size
    dotSize[i] = baseDotSize[i] * sizeMultiplier;
    
    // Ensure minimum size
    if (dotSize[i] < 5) {
      dotSize[i] = 5;
    }
  }
}

void drawPauseIndicator() {
  // Draw pause symbol in corner
  fill(255, 150);
  textSize(20);
  textAlign(LEFT);
  text("PAUSED - Click to Resume", 20, height - 30);
}

// Click to toggle pause/resume
void mousePressed() {
  paused = !paused;
  
  // Print status to console
  if (paused) {
    println("Animation PAUSED");
  } else {
    println("Animation RESUMED");
  }
}

// Press keys to change mood
void keyPressed() {
  switch(key) {
    case '1':
      currentMood = "calm";
      println("Mood changed to: Calm");
      break;
    case '2':
      currentMood = "energetic";
      println("Mood changed to: Energetic");
      break;
    case '3':
      currentMood = "sad";
      println("Mood changed to: Sad");
      break;
    case '4':
      currentMood = "happy";
      println("Mood changed to: Happy");
      break;
    case 'r':
    case 'R':
      // Reset dot positions and speeds
      setup();
      println("Animation reset");
      break;
  }
}

// Optional: Mouse hover effects
void mouseMoved() {
  // Change pulse speed based on mouse position
  float mouseInfluence = map(mouseX, 0, width, 0.5, 2.0);
  
  for (int i = 0; i < numDots; i++) {
    // Slightly adjust pulse speed based on mouse X position
    if (!paused) {
      pulseSpeed[i] = random(0.02, 0.08) * mouseInfluence;
    }
  }
}
