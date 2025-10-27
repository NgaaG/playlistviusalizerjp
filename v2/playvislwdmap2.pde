// LEADUWARDEN - Interactive Playlist Animation
// Location-based mood visualization for mindful exploration
// Simulates University Mode and Spare Time Mode playlists

// Animation variables
int numDots = 20;                    // Dots representing discovery spots
float[] dotX = new float[numDots];   // X positions (map locations)
float[] dotY = new float[numDots];   // Y positions  
float[] dotSize = new float[numDots]; // Current sizes (activity level)
float[] baseDotSize = new float[numDots]; // Base sizes
float[] pulseSpeed = new float[numDots];  // Beat rates matching location vibes
boolean paused = false;              // Pause state

// LEADUWARDEN App Settings
String appMode = "University";       // "University" or "SpareTime"
String currentLocation = "Library Courtyard";
String currentMood = "peaceful";     // peaceful, lively, social, scenic, greenery
String playlistName = "Study Break Vibes";

// LEADUWARDEN Mood Colors (matching app design)
color peacefulColor = color(115, 158, 115);    // Soft green for peaceful spots
color livelyColor = color(255, 165, 87);       // Warm orange for lively areas
color socialColor = color(158, 115, 201);      // Purple for social spaces  
color scenicColor = color(87, 158, 201);       // Blue for scenic views
color greeneryColor = color(67, 176, 42);      // Fresh green for nature

// Discovery spot icons (using different shapes)
String[] spotTypes = {"🌳", "💧", "🏛️", "☕", "📚", "🌸"};
int[] spotTypeIndex = new int[numDots];

void setup() {
  size(900, 700);
  
  // Initialize discovery spots in map-like formation
  for (int i = 0; i < numDots; i++) {
    // Scatter spots across "campus/city map"
    dotX[i] = random(100, width-100);
    dotY[i] = random(150, height-100);
    baseDotSize[i] = random(12, 28);
    dotSize[i] = baseDotSize[i];
    pulseSpeed[i] = random(0.015, 0.065); // Different vibe speeds
    spotTypeIndex[i] = int(random(spotTypes.length));
  }
  
  textAlign(CENTER, CENTER);
}

void draw() {
  // Set background based on current mood/location type
  setLocationMoodBackground();
  
  // Draw LEADUWARDEN app header
  drawAppHeader();
  
  // Draw discovery spots (pulsing dots)
  drawDiscoverySpots();
  
  // Show current location info
  drawLocationInfo();
  
  // Show mode indicators
  drawModeIndicator();
  
  // Show pause state
  if (paused) {
    drawPauseIndicator();
  }
  
  // Only animate if not paused (music playing)
  if (!paused) {
    animateSpots();
  }
}

void setLocationMoodBackground() {
  // Background changes based on location mood (like LEADUWARDEN filters)
  switch(currentMood) {
    case "peaceful":
      background(peacefulColor);
      break;
    case "lively":
      background(livelyColor);
      break;
    case "social":
      background(socialColor);
      break;
    case "scenic":
      background(scenicColor);
      break;
    case "greenery":
      background(greeneryColor);
      break;
    default:
      background(120); // Default neutral
  }
}

void drawAppHeader() {
  // LEADUWARDEN app title
  fill(255, 220);
  textSize(28);
  textAlign(CENTER);
  text("LEADUWARDEN", width/2, 35);
  
  // Subtitle with current mode
  textSize(16);
  text("🎓 " + appMode + " Mode", width/2, 65);
}

void drawDiscoverySpots() {
  // Draw each discovery spot as animated dot
  for (int i = 0; i < numDots; i++) {
    // Main spot circle
    fill(255, 200); // Semi-transparent white
    stroke(255, 100);
    strokeWeight(1);
    ellipse(dotX[i], dotY[i], dotSize[i], dotSize[i]);
    
    // Spot type indicator (emoji-style)
    fill(255);
    textSize(dotSize[i] * 0.4);
    textAlign(CENTER);
    text(spotTypes[spotTypeIndex[i]], dotX[i], dotY[i]);
    
    // Pulse ring for active spots
    if (dotSize[i] > baseDotSize[i] * 1.3) {
      noFill();
      stroke(255, 80);
      strokeWeight(2);
      ellipse(dotX[i], dotY[i], dotSize[i] * 1.8, dotSize[i] * 1.8);
    }
  }
}

void animateSpots() {
  // Animate spots based on location activity and playlist beat
  for (int i = 0; i < numDots; i++) {
    // Create pulsing effect matching playlist vibe
    float pulse = sin(frameCount * pulseSpeed[i] + i * 0.3);
    
    // Scale pulse intensity based on location type
    float intensity = getLocationIntensity(spotTypeIndex[i]);
    float sizeMultiplier = 1 + pulse * intensity;
    dotSize[i] = baseDotSize[i] * sizeMultiplier;
    
    // Ensure minimum visibility
    if (dotSize[i] < 8) {
      dotSize[i] = 8;
    }
  }
}

float getLocationIntensity(int spotType) {
  // Different spot types have different activity levels
  switch(spotType) {
    case 0: return 0.3; // 🌳 Trees - gentle
    case 1: return 0.5; // 💧 Water - flowing
    case 2: return 0.4; // 🏛️ Buildings - moderate  
    case 3: return 0.7; // ☕ Cafes - lively
    case 4: return 0.2; // 📚 Study - quiet
    case 5: return 0.6; // 🌸 Gardens - vibrant
    default: return 0.4;
  }
}

void drawLocationInfo() {
  // Show current location and playlist (like LEADUWARDEN spot detail card)
  fill(255, 180);
  textAlign(LEFT);
  textSize(14);
  text("📍 " + currentLocation, 20, height - 80);
  text("🎵 " + playlistName, 20, height - 60);
  text("🎨 Mood: " + currentMood.toUpperCase(), 20, height - 40);
  text("💭 " + getReflectionPrompt(), 20, height - 20);
}

String getReflectionPrompt() {
  // Reflection prompts matching LEADUWARDEN's mindful approach
  switch(currentMood) {
    case "peaceful": return "What brings you calm in this moment?";
    case "lively": return "How does this energy affect your mood?";
    case "social": return "What connections do you notice around you?";
    case "scenic": return "What details catch your eye?";
    case "greenery": return "How does nature make you feel?";
    default: return "What are you grateful for right now?";
  }
}

void drawModeIndicator() {
  // Mode toggle (like LEADUWARDEN's dual mode system)
  fill(255, 150);
  textAlign(RIGHT);
  textSize(12);
  text("Press M to switch modes", width - 20, height - 60);
  text("Press 1-5 for mood filters", width - 20, height - 40);
  text("Click to pause/resume playlist", width - 20, height - 20);
}

void drawPauseIndicator() {
  // Show when playlist is paused
  fill(255, 200);
  textSize(24);
  textAlign(CENTER);
  text("⏸️ PLAYLIST PAUSED", width/2, height/2 + 100);
  textSize(14);
  text("Click to resume your mindful journey", width/2, height/2 + 125);
}

// Click to pause/resume playlist (like Spotify integration)
void mousePressed() {
  paused = !paused;
  
  if (paused) {
    println("🎵 Playlist paused - Take a mindful moment");
  } else {
    println("🎵 Resuming " + playlistName);
  }
}

// LEADUWARDEN-style interactions
void keyPressed() {
  switch(key) {
    case '1':
      currentMood = "peaceful";
      playlistName = "Quiet Study Sessions";
      println("🌿 Filter: Peaceful locations");
      break;
    case '2':
      currentMood = "lively";
      playlistName = "Campus Energy Mix";
      println("⚡ Filter: Lively spots");
      break;
    case '3':
      currentMood = "social";
      playlistName = "Social Hangout Beats";
      println("👥 Filter: Social spaces");
      break;
    case '4':
      currentMood = "scenic";
      playlistName = "Scenic Walk Soundtrack";
      println("🌅 Filter: Scenic views");
      break;
    case '5':
      currentMood = "greenery";
      playlistName = "Nature Connection";
      println("🌳 Filter: Green spaces");
      break;
    case 'm':
    case 'M':
      // Toggle between University and Spare Time modes
      if (appMode.equals("University")) {
        appMode = "SpareTime";
        currentLocation = "Riverside Park";
        playlistName = "City Exploration Vibes";
        println("🌿 Switched to Spare Time Mode");
      } else {
        appMode = "University";
        currentLocation = "Library Courtyard";
        playlistName = "Study Break Vibes";
        println("🎓 Switched to University Mode");
      }
      // Regenerate spots for new mode
      generateNewSpots();
      break;
    case 'r':
    case 'R':
      // Reset discovery (like exploring new areas)
      generateNewSpots();
      println("🗺️ Discovering new locations...");
      break;
  }
}

void generateNewSpots() {
  // Generate new spot layout (simulating map exploration)
  for (int i = 0; i < numDots; i++) {
    dotX[i] = random(100, width-100);
    dotY[i] = random(150, height-100);
    pulseSpeed[i] = random(0.015, 0.065);
    spotTypeIndex[i] = int(random(spotTypes.length));
  }
}

// Mouse hover shows spot details (like LEADUWARDEN spot cards)
void mouseMoved() {
  // Check if hovering over a discovery spot
  for (int i = 0; i < numDots; i++) {
    float distance = dist(mouseX, mouseY, dotX[i], dotY[i]);
    if (distance < dotSize[i]/2) {
      // Highlight hovered spot
      pulseSpeed[i] = 0.1; // Faster pulse when hovering
    } else {
      // Normal speed
      pulseSpeed[i] = random(0.015, 0.065);
    }
  }
}
