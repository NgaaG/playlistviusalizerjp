# REAL-TIME DATA: EMOTION MAPPING (No API Required) - plutchik emotion wheel

## Based on  Actual Mood Beat Maps Prototype Data (mood journal entries)

Since you I can't modify my Lovable app further (no credits) and it doesn't have API endpoints (free plan), here's how to get my Processing visualization working with **manual data extraction**:

---


## Step 2: Create Your Project (1 minute)
1. In Processing: **File → Save As...**
2. Name it: `MoodBeatMaps`
3. Click **Save**
4. Processing creates a folder with your project

---

## Step 3: Create  Data File in Processing folder
**This is the key step since I have no API**

1. mood_export.json
```json
{
  "mood_entries": [
    {
      "timestamp": "2025-10-17T14:30:00Z",
      "location": {
        "name": "Windmill Building Garden",
        "latitude": 53.2012,
        "longitude": 5.7979
      },
      "emotion": {
        "primary": "content",
        "intensity": 0.8,
        "secondary": ["happy", "curious"]
      },
      "playlist": {
        "name": "Epic Views"
      },
      "note": "Scenic spot with windmill views, ideal for contemplative breaks between classes"
    },
    {
      "timestamp": "2025-10-17T13:15:00Z",
      "location": {
        "name": "Shopping Beats",
        "latitude": 53.2045,
        "longitude": 5.7856
      },
      "emotion": {
        "primary": "neutral",
        "intensity": 0.6,
        "secondary": ["content"]
      },
      "playlist": {
        "name": "Shopping Beats"
      },
      "note": "Neutral mood while running errands"
    },
    {
      "timestamp": "2025-10-17T12:00:00Z",
      "location": {
        "name": "Coffeeshop Vibes",
        "latitude": 53.2023,
        "longitude": 5.7891
      },
      "emotion": {
        "primary": "happy",
        "intensity": 0.9,
        "secondary": ["curious"]
      },
      "playlist": {
        "name": "Coffeeshop Vibes"
      },
      "note": "Great coffee and atmosphere for studying"
    },
    {
      "timestamp": "2025-10-17T10:45:00Z",
      "location": {
        "name": "Epic Views",
        "latitude": 53.2067,
        "longitude": 5.7834
      },
      "emotion": {
        "primary": "curious",
        "intensity": 0.7,
        "secondary": ["happy"]
      },
      "playlist": {
        "name": "Epic Views"
      },
      "note": "Amazing scenery for morning reflection"
    },
    {
      "timestamp": "2025-10-16T16:20:00Z",
      "location": {
        "name": "Campus Library",
        "latitude": 53.2058,
        "longitude": 5.7825
      },
      "emotion": {
        "primary": "content",
        "intensity": 0.75,
        "secondary": ["trust"]
      },
      "playlist": {
        "name": "Study Focus"
      },
      "note": "Productive study session"
    }
  ]
}
```



## Step 4:Code Brreakdown

```java
// MOOD BEAT MAPS - Simple Offline Version
// Works without API endpoints - uses local JSON file

import java.text.SimpleDateFormat;
import java.util.*;

// Data storage
JSONObject dataset;
JSONArray entries;
ArrayList<MoodEntry> moodEntries = new ArrayList<MoodEntry>();

// UI State
int timeframeDays = 30;
String locationFilter = "all";
boolean dataLoaded = false;

// Layout
float wheelCenterX, wheelCenterY, wheelRadius = 150;

// Plutchik colors (matching your app's mood system)
HashMap<String, Integer> emotionColors = new HashMap<String, Integer>();
HashMap<String, Integer> emotionCounts = new HashMap<String, Integer>();
String[] emotions = {"happy", "content", "curious", "neutral", "sad", "angry", "excited", "calm"};

class MoodEntry {
  Date timestamp;
  String locationName;
  float latitude, longitude;
  String primaryEmotion;
  float intensity;
  String playlistName;
  String note;
  
  MoodEntry(JSONObject json) {
    try {
      String timeStr = json.getString("timestamp");
      SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
      this.timestamp = sdf.parse(timeStr);
      
      JSONObject location = json.getJSONObject("location");
      this.locationName = location.getString("name");
      this.latitude = location.getFloat("latitude");
      this.longitude = location.getFloat("longitude");
      
      JSONObject emotion = json.getJSONObject("emotion");
      this.primaryEmotion = emotion.getString("primary");
      this.intensity = emotion.getFloat("intensity");
      
      JSONObject playlist = json.getJSONObject("playlist");
      this.playlistName = playlist.getString("name");
      
      this.note = json.getString("note");
      
    } catch (Exception e) {
      println("Error parsing entry: " + e.getMessage());
      // Set defaults
      this.timestamp = new Date();
      this.locationName = "Unknown";
      this.primaryEmotion = "neutral";
      this.intensity = 0.5;
      this.playlistName = "No Playlist";
      this.note = "";
    }
  }
}

void setup() {
  size(1000, 700);
  surface.setTitle("Mood Beat Maps - Visualization");
  
  wheelCenterX = width * 0.3;
  wheelCenterY = height * 0.5;
  
  // Initialize colors to match your app
  emotionColors.put("happy", color(255, 193, 7));      // Yellow like your happy emoji
  emotionColors.put("content", color(139, 195, 74));   // Green like your content emoji
  emotionColors.put("curious", color(255, 152, 0));    // Orange like your curious emoji
  emotionColors.put("neutral", color(158, 158, 158));  // Gray for neutral
  emotionColors.put("sad", color(63, 81, 181));        // Blue for sad
  emotionColors.put("angry", color(244, 67, 54));      // Red for angry
  emotionColors.put("excited", color(233, 30, 99));    // Pink for excited
  emotionColors.put("calm", color(76, 175, 80));       // Calm green
  
  // Load your mood data
  loadMoodData();
  
  if (dataLoaded) {
    println("✅ Successfully loaded " + moodEntries.size() + " mood entries!");
    aggregateEmotions();
  } else {
    println("❌ Could not load data. Check that mood_export.json exists in the data folder.");
  }
}

void loadMoodData() {
  try {
    dataset = loadJSONObject("mood_export.json");  // Loads from data folder
    if (dataset != null) {
      entries = dataset.getJSONArray("mood_entries");
      
      for (int i = 0; i < entries.size(); i++) {
        MoodEntry entry = new MoodEntry(entries.getJSONObject(i));
        moodEntries.add(entry);
      }
      
      dataLoaded = true;
    }
  } catch (Exception e) {
    println("Failed to load mood data: " + e.getMessage());
    println("Make sure mood_export.json exists in your data folder!");
    dataLoaded = false;
  }
}

void aggregateEmotions() {
  // Reset counts
  for (String emotion : emotions) {
    emotionCounts.put(emotion, 0);
  }
  
  // Count each emotion
  for (MoodEntry entry : moodEntries) {
    String emotion = entry.primaryEmotion;
    if (emotionCounts.containsKey(emotion)) {
      emotionCounts.put(emotion, emotionCounts.get(emotion) + 1);
    }
  }
}

void draw() {
  background(250, 248, 245);  // Light background like your app
  
  drawHeader();
  
  if (dataLoaded) {
    drawEmotionWheel();
    drawLocationMap();
    drawJournalList();
  } else {
    drawErrorMessage();
  }
  
  drawInstructions();
}

void drawHeader() {
  fill(0);
  textAlign(LEFT);
  textSize(24);
  text("Your Mood Beat Maps - Visualization", 30, 40);
  
  textSize(14);
  fill(100);
  if (dataLoaded) {
    text("Showing " + moodEntries.size() + " mood journal entries", 30, 65);
  } else {
    text("No data loaded - check setup instructions below", 30, 65);
  }
}

void drawEmotionWheel() {
  // Background circle
  fill(255);
  stroke(200);
  strokeWeight(1);
  ellipse(wheelCenterX, wheelCenterY, wheelRadius * 2.5, wheelRadius * 2.5);
  
  // Title
  fill(0);
  textAlign(CENTER);
  textSize(16);
  text("Your Emotional Profile", wheelCenterX, wheelCenterY - wheelRadius - 40);
  
  // Find max count for scaling
  int maxCount = 0;
  for (int count : emotionCounts.values()) {
    if (count > maxCount) maxCount = count;
  }
  
  if (maxCount == 0) {
    fill(150);
    textSize(14);
    text("No emotion data", wheelCenterX, wheelCenterY);
    return;
  }
  
  // Draw emotion petals
  float angleStep = TWO_PI / emotions.length;
  
  for (int i = 0; i < emotions.length; i++) {
    String emotion = emotions[i];
    int count = emotionCounts.get(emotion);
    
    if (count == 0) continue;  // Skip emotions with no data
    
    // Calculate petal size
    float petalScale = map(count, 0, maxCount, 0.3, 1.0);
    float petalRadius = wheelRadius * petalScale;
    
    float startAngle = -HALF_PI + i * angleStep;
    float endAngle = startAngle + angleStep;
    
    // Draw petal
    fill(emotionColors.get(emotion), 180);
    stroke(0, 50);
    strokeWeight(1);
    
    beginShape();
    vertex(wheelCenterX, wheelCenterY);
    for (float angle = startAngle; angle <= endAngle; angle += 0.1) {
      float x = wheelCenterX + cos(angle) * petalRadius;
      float y = wheelCenterY + sin(angle) * petalRadius;
      vertex(x, y);
    }
    vertex(wheelCenterX, wheelCenterY);
    endShape(CLOSE);
    
    // Draw label
    float labelAngle = startAngle + angleStep / 2;
    float labelRadius = petalRadius + 30;
    float labelX = wheelCenterX + cos(labelAngle) * labelRadius;
    float labelY = wheelCenterY + sin(labelAngle) * labelRadius;
    
    fill(0);
    textAlign(CENTER);
    textSize(12);
    text(emotion, labelX, labelY);
    text("(" + count + ")", labelX, labelY + 15);
  }
}

void drawLocationMap() {
  // Map panel
  float mapX = width * 0.6;
  float mapY = 100;
  float mapW = width * 0.35;
  float mapH = height * 0.4;
  
  fill(255);
  stroke(200);
  rect(mapX, mapY, mapW, mapH, 10);
  
  fill(0);
  textAlign(LEFT);
  textSize(16);
  text("Your Mood Locations", mapX + 15, mapY + 25);
  
  // Draw mood points
  for (MoodEntry entry : moodEntries) {
    // Simple projection (adjust these bounds to match your area)
    float screenX = map(entry.longitude, 5.78, 5.81, mapX + 20, mapX + mapW - 20);
    float screenY = map(entry.latitude, 53.21, 53.19, mapY + 50, mapY + mapH - 20);
    
    if (screenX < mapX || screenX > mapX + mapW || screenY < mapY || screenY > mapY + mapH) {
      continue;  // Skip points outside bounds
    }
    
    color emotionColor = emotionColors.get(entry.primaryEmotion);
    float pointSize = map(entry.intensity, 0, 1, 8, 20);
    
    fill(emotionColor, 200);
    noStroke();
    ellipse(screenX, screenY, pointSize, pointSize);
    
    // Show location name on hover
    if (dist(mouseX, mouseY, screenX, screenY) < pointSize/2 + 5) {
      fill(0);
      textAlign(CENTER);
      textSize(10);
      text(entry.locationName, screenX, screenY - pointSize/2 - 5);
    }
  }
}

void drawJournalList() {
  // Journal panel
  float journalX = width * 0.6;
  float journalY = height * 0.55;
  float journalW = width * 0.35;
  float journalH = height * 0.3;
  
  fill(255);
  stroke(200);
  rect(journalX, journalY, journalW, journalH, 10);
  
  fill(0);
  textAlign(LEFT);
  textSize(16);
  text("Recent Journal Entries", journalX + 15, journalY + 25);
  
  // List recent entries
  float yPos = journalY + 50;
  int maxShow = min(6, moodEntries.size());
  
  for (int i = moodEntries.size() - 1; i >= moodEntries.size() - maxShow; i--) {
    MoodEntry entry = moodEntries.get(i);
    
    // Emotion color indicator
    fill(emotionColors.get(entry.primaryEmotion));
    rect(journalX + 15, yPos, 4, 15);
    
    // Entry text
    fill(0);
    textSize(11);
    SimpleDateFormat timeFormat = new SimpleDateFormat("MMM dd, HH:mm");
    String timeStr = timeFormat.format(entry.timestamp);
    
    text(timeStr + " • " + entry.locationName, journalX + 25, yPos + 7);
    text("♪ " + entry.playlistName, journalX + 25, yPos + 20);
    
    yPos += 35;
  }
}

void drawErrorMessage() {
  fill(200, 0, 0);
  textAlign(CENTER);
  textSize(20);
  text("⚠️ No Data Loaded", width/2, height/2 - 40);
  
  fill(0);
  textSize(14);
  text("Create mood_export.json in your data folder", width/2, height/2);
  text("See instructions at the bottom", width/2, height/2 + 20);
}

void drawInstructions() {
  // Instructions panel
  fill(240);
  stroke(200);
  rect(10, height - 120, width - 20, 110, 5);
  
  fill(0);
  textAlign(LEFT);
  textSize(12);
  text("📁 SETUP: Create 'data' folder in your Processing sketch folder", 20, height - 100);
  text("📄 ADD: mood_export.json file with your mood data (see sample above)", 20, height - 85);
  text("▶️ RUN: Press play button to visualize your moods", 20, height - 70);
  text("💾 EXPORT: Press 'e' to save mood analysis as CSV file", 20, height - 55);
  text("🔄 REFRESH: Press 'r' to reload data after adding more entries", 20, height - 40);
  
  fill(100);
  textSize(10);
  text("Status: " + (dataLoaded ? "✅ Data loaded successfully" : "❌ No data file found"), 20, height - 20);
}

// Keyboard shortcuts
void keyPressed() {
  switch(key) {
    case 'e':
    case 'E':
      exportToCSV();
      break;
    case 'r':
    case 'R':
      loadMoodData();
      if (dataLoaded) aggregateEmotions();
      break;
  }
}

void exportToCSV() {
  if (!dataLoaded) {
    println("❌ No data to export");
    return;
  }
  
  Table table = new Table();
  table.addColumn("emotion");
  table.addColumn("count");
  table.addColumn("percentage");
  
  int total = 0;
  for (int count : emotionCounts.values()) {
    total += count;
  }
  
  for (String emotion : emotions) {
    int count = emotionCounts.get(emotion);
    if (count > 0) {
      TableRow row = table.addRow();
      row.setString("emotion", emotion);
      row.setInt("count", count);
      row.setFloat("percentage", (float)count / total * 100);
    }
  }
  
  String filename = "mood_analysis_" + year() + nf(month(), 2) + nf(day(), 2) + ".csv";
  saveTable(table, filename);
  
  println("✅ Exported mood analysis to: " + filename);
}
```

---

## Step 5: Test It (1 minute)
1. Click the **▶️ Play button** in Processing
2. You should see:
   - **Emotion wheel** with colored petals for each mood
   - **Location map** with colored dots for your journal entries  
   - **Journal list** showing recent entries with playlists
   - **Status message** at bottom showing if data loaded

**If you see "No Data Loaded":**
- Check that the `data` folder exists in your Processing sketch folder
- Check that `mood_export.json` exists inside the data folder
- The JSON must have the exact structure shown above

---

## Step 6: Add Your Real Data (10 minutes)
Look at your Lovable app screenshots and manually create entries:

1. Open each of your journal cards in the app
2. Note down: location name, emotion, playlist, date
3. Add each as a new entry in your `mood_export.json` file
4. Press **'r'** in Processing to reload the data

**Example based on your screenshots:**
```json
{
  "timestamp": "2025-10-17T14:00:00Z",
  "location": {
    "name": "Windmill Building Garden", 
    "latitude": 53.2012,
    "longitude": 5.7979
  },
  "emotion": {
    "primary": "content",
    "intensity": 0.8
  },
  "playlist": {
    "name": "Epic Views"
  },
  "note": "Scenic spot with windmill views"
}
```

---

## Step 7: Export Analysis (30 seconds)
- Press **'e'** in Processing
- This saves a CSV file with your emotion analysis
- Open in Excel/Google Sheets for further research

---

## Troubleshooting

**"Could not load mood data" error?**
- Make sure the `data` folder is inside your Processing sketch folder
- Check the JSON syntax - use a JSON validator online
- Make sure the file is named exactly `mood_export.json`

**Empty visualization?**
- Check that your JSON has the right structure
- Make sure emotion names match exactly: "happy", "content", "curious", etc.
- Check the console (black area) for error messages

**Want to add more entries?**
- Edit the `mood_export.json` file
- Add more entries following the same format
- Press 'r' in Processing to reload

---

This approach **works immediately** without needing any API endpoints or Lovable credits. You can visualize your actual mood data and export it for research analysis!
