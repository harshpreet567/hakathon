# Eunoia
It ia an Ambient Intelligence Platform

Making Your Workspace Smarter with AI

# What is Eunoia?

Eunoia is an AI-powered smart workspace that helps take care of your desk even when you're not there.

Imagine you're working on an Arduino project. You leave your room for dinner and accidentally forget to switch off your prototype. Normally, it would keep running, waste electricity, and might even overheat.

Eunoia notices what's happening, understands the situation, and helps prevent problems before they become serious.

Instead of waiting for you to give commands, Eunoia continuously observes the workspace and makes smart decisions.

---

# The Problem

Students and engineers often get busy while working on projects.

Sometimes we:

- Forget to switch off our prototype.
- Leave the laptop unlocked.
- Leave chargers or electronic devices running.
- Don't notice when a device is getting too hot.

These small mistakes can waste electricity, damage hardware, or even become safety risks.

---

# Our Solution

Eunoia connects your Arduino Smart Desk Node, Snapdragon PC, and smartphone into one intelligent system.

Each device has a different job:

- Arduino collects information from sensors.
- Sensors monitor the environment.
- Snapdragon PC acts as the brain and decides what should happen.
- Phone tells the system whether you're present or have left.
- Cloud stores previous events and system history.

All these devices work together to make your workspace safer and smarter.

---

# How Eunoia Works

1. The sensors keep checking the workspace all the time.
2. Arduino collects the sensor readings.
3. Your phone tells the system whether you're near your desk or have left.
4. The Snapdragon PC receives all this information.
5. The AI understands the complete situation.
6. It decides the best action.
7. If needed, it sends you a notification.
8. Arduino performs the action, such as turning OFF a relay or changing an LED.
9. The event is saved to the cloud.

---

# Main Features

1. Forgotten Prototype Detection

Suppose you leave your room while your Arduino project is still running.

Eunoia notices that:

- There is no movement near the desk.
- Your phone has left the room.
- The prototype is still consuming power.

It sends you a notification asking whether you'd like to turn it off. If you agree, the relay automatically disconnects the power.

---

2. Hardware Emergency

If the temperature becomes too high or the current suddenly increases, Nexus detects that something may be wrong.

The system immediately turns off the power using the relay and alerts the user to help prevent damage.

---

3. Deep Work Mode

When you start coding on your laptop, Eunoia can recognize that you're working.

It can:

- Enable Focus Mode on your phone.
- Reduce distractions.
- Change the desk LED to show you're in work mode.

---

4. Night Protection

If it's late at night, nobody is near the desk, but electronics are still running, Nexus automatically switches them off to save power and improve safety.

---

# System Architecture


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

# Softtware Used

- Arduino IDE
- Python
- GitHub
- AI Decision Engine
- Wi-Fi/Bluetooth Communication

---

# Future Improvements

In the future, Eunoia can be expanded to:

- Smart laboratories
- Multiple smart desks
- Predictive maintenance
- Voice control
- Better energy management

---

# Team Members

Akshita: vermaakshita856@gmail.com

Ashwikka: ashwikkasingh@gmail.comName 

Harshpreet: harshpreetsajjan@gmail.com

Saanvi: Saanvidheer12@gmail.com

---

# Setup

1. Clone this repository.
2. Upload the Arduino code.
3. Install the required software and libraries.
4. Connect the Arduino to the PC.
5. Run the AI application.
6. Test the demo scenarios.

---
# License

This project is licensed under the MIT License.
