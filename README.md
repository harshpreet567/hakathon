# Eunoia
An Ambient Intelligence Platform, AI - powered smart workspace that understands situations and coordinates your devices automatically.

# Project Overview
Eunoia is an Ambient Intelligence platform designed to create a smart and responsive workspace. Instead of waiting for user commands, Eunoia continuously monitors the environment using sensors, understands the current situation with AI and coordinates connected devices to improve safety, productivity and convenience.
The system integrates an arduino-based Smart Desk Node, a Snapdragon-powered PC as the AI Decision Engine, a smartphone for user context and cloud storage for history and synchronization.

# Problem Statement
Students and professionals often leave prototypes, charges or electronic devices running unattended. This can Lead to:
1. Power wastage
2. Overheating
3. Hardware damage
4. Safety risks
5. Reduced productivity

Current assistants require manual commands and do not understand real-world situations.

# Solution

Nexus enables Ambient Intelligence by continuously collecting information from multiple sources and making intelligent decisions automatically.

The AI combines:
- Sensor data from the Smart Desk Node
- User context from the smartphone
- Workspace activity from the PC

Based on this information, Nexus detects situations and responds appropriately.

---

## System Architecture


              Smartphone
        (Location & Context)
                 |
                 |
                 ▼
   Snapdragon PC (AI Decision Engine)
                 ▲
                 |
                 |
 Arduino Smart Desk Node
(Sensors + Relay + LEDs)
                 |
                 ▼
          Physical Workspace


---

## Hardware Components

| Component | Purpose |
|----------|---------|
| Arduino Uno | Reads sensor data and controls hardware |
| Temperature Sensor | Detects overheating |
| Motion Sensor | Detects human presence |
| Light Sensor | Measures ambient light |
| Current Sensor | Measures power consumption |
| Relay Module | Turns electrical devices ON/OFF |
| LEDs | Indicates system status |

---

# Software & Technologies

- Arduino IDE
- Python
- Git & GitHub
- AI Decision Engine
- Wi-Fi / Bluetooth Communication
- Cloud Storage

# Working

1. Sensors monitor the workspace.
2. Arduino collects sensor readings.
3. Smartphone provides user context.
4. Arduino sends data to the Snapdragon PC.
5. AI analyzes all available information.
6. AI identifies the current situation.
7. The appropriate action is selected.
8. Arduino executes the command using the relay or LEDs.
9. The user receives a notification.
10. Event history is stored in the cloud.

---

## Features

### Forgotten Prototype Detection

- Detects when the user leaves while the prototype is still running.
- Sends a notification.
- Turns OFF the prototype through the relay after confirmation.

### Hardware Emergency Detection

- Detects abnormal temperature or current.
- Predicts possible hardware failure.
- Disconnects power automatically.

### Deep Work Mode

- Detects coding activity.
- Enables Focus Mode on the phone.
- Changes desk LED status.

### Night Protection

- Detects unattended electronics during late hours.
- Automatically disconnects unnecessary power.

---

## Demo Scenarios

### Demo 1
Forgotten Prototype Detection

### Demo 2
Hardware Emergency Detection

### Demo 3
Deep Work Mode

---

## Setup Instructions

1. Clone this repository.
2. Install Arduino IDE.
3. Upload the Arduino program.
4. Install required Python dependencies.
5. Connect the Arduino to the PC.
6. Run the AI application.
7. Connect the smartphone to the same network.

---

## Future Scope

- Smart laboratories
- Multi-desk coordination
- Predictive maintenance
- Voice assistant integration
- Energy optimization

---

## Team Members

Akshita: vermaakshita856@gmail.com
Harshpreet: harshpreetsajjan@gmail.com
Saanvi: Saanvidheer12@gmail.com
Ashwikka: ashwikkasingh@gmail.comName 

---

## License

This project is licensed under the MIT License.
