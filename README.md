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
