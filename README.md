# 🎧 Audio Notes X  
### Voice Notes + Smart TaskFlow in One Powerful App

Audio Notes X is a modern productivity app that combines **voice notes**, **text notes**, **task management**, and **smart reminders** — all in a clean, intuitive Flutter interface.  
Built with **Hive**, **GetX**, **Local Notifications**, **STT** and **TTS**, it gives users a seamless experience for capturing ideas and managing daily tasks.

---

## 🚀 Features

### 🎙️ Voice Notes
- Record high-quality audio notes  
- Waveform-style UI (planned)  
- Text-To-Speech (TTS) playback  
- View, edit, delete, and search notes  

### 📝 Text Notes
- Create, edit, search, and organize text notes  
- Instant filtering via a custom SearchController  
- Offline access with Hive storage  

### ✅ Smart TaskFlow (To-Do System)
- Add, edit, and schedule tasks  
- Notification-based reminders  
- Date-based filtering  
- Minimal and intuitive UI  

### 🔔 Notifications
- Exact alarm support (Android 13+)  
- Timezone-aware scheduling  
- Handles permissions with fallback  

### 👤 Login System
- Local authentication using SharedPreferences  
- Saves and restores user session  

---

## 🏗️ Project Structure


lib/
├── Controllers/
│ ├── NotesControllers/
│ └── TasksControllers/
├── Data/
│ ├── NotesModels/
│ └── TasksModels/
├── Views/
│ ├── NotesPages/
│ └── TasksPages/
├── Services/
│ └── NotificationService.dart
├── Authentication/
├── Widgets/
└── main.dart



