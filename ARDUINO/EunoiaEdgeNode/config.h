#ifndef COMMANDS_H
#define COMMANDS_H

#include <Arduino.h>
#include "config.h"

/**
 * Handles the logic state of the relay module.
 * @param activate Pass true to close the relay contacts, false to cut power.
 */
void setRelayState(bool activate) {
    if (activate) {
        digitalWrite(PIN_RELAY, HIGH); // Engages the driver coil
    } else {
        digitalWrite(PIN_RELAY, LOW);  // Drops out the driver coil
    }
}

/**
 * Gets the current physical execution status of the relay pin wrapper.
 * @return bool True if energized, false if open.
 */
bool getRelayStatus() {
    return (digitalRead(PIN_RELAY) == HIGH);
}

/**
 * Checks the Serial RX ring buffer for incoming configuration strings from the FastAPI backend.
 * Parses commands and outputs instant confirmation receipts.
 */
void processIncomingCommands() {
    if (Serial.available() > 0) {
        String command = Serial.readStringUntil('\n');
        command.trim(); // Clears trailing carriages or whitespace noise
        
        if (command == "TURN_ON") {
            setRelayState(true);
            Serial.print("{\"receipt\":\"CMD_EXEC\",\"relayActive\":true,\"msg\":\"Relay bus closed.\"}");
            Serial.println();
        } 
        else if (command == "TURN_OFF") {
            setRelayState(false);
            Serial.print("{\"receipt\":\"CMD_EXEC\",\"relayActive\":false,\"msg\":\"Relay bus open.\"}");
            Serial.println();
        }
    }
}

#endif
