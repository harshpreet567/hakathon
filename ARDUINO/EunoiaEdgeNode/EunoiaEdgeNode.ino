/**
 * Pulse Embedded Safety Infrastructure Node Firmware.
 * Target MCU Architecture: Microchip ATmega328P (Arduino UNO)
 * * Compiles non-blocking execution timelines to poll sensors and 
 * interface cleanly with downstream FastAPI backend servers using standardized JSON schemas.
 */

#include "config.h"
#include "sensors.h"
#include "commands.h"

// --- NON-BLOCKING SCHEDULER TIMESTAMP VARIABLES ---
unsigned long previousTelemetryTime = 0;
unsigned long previousHeartbeatTime = 0;

/**
 * Microcontroller Boot Configuration Initialization Block.
 */
void setup() {
    // Open high-speed industrial serial bus channel pipeline
    Serial.begin(115200);
    
    // Define pin directions for internal register maps
    pinMode(PIN_PIR_MOTION, INPUT);
    pinMode(PIN_RELAY, OUTPUT);
    
    // Boot safety baseline: Force safe closed-loop state on line relays
    setRelayState(true);
    
    // Print boot confirmation signature block
    Serial.println("{\"system\":\"PULSE_EDGE_NODE\",\"status\":\"BOOT_COMPLETE\",\"firmware\":\"1.0.0\"}");
}

/**
 * Core Application Superloop execution pipeline.
 */
void loop() {
    unsigned long currentTime = millis();

    // Task 1: Continuously listen for remote commands from the API
    processIncomingCommands();

    // Task 2: Standardized Telemetry Data Frame Transmission Vector (Every 1 Second)
    if (currentTime - previousTelemetryTime >= INTERVAL_TELEMETRY) {
        previousTelemetryTime = currentTime;
        
        // Sample all data tracks from hardware layers
        float currentTemp = readTemperature();
        float currentLoad = readCurrent();
        bool motionActive = readMotion();
        bool relayActive  = getRelayStatus();
        
        // Output serialized telemetry packets for FastAPI backend ingestion
        Serial.print("{");
        Serial.print("\"temperature\":");   Serial.print(currentTemp, 2);  Serial.print(",");
        Serial.print("\"current\":");       Serial.print(currentLoad, 2);  Serial.print(",");
        Serial.print("\"motion_detected\":"); Serial.print(motionActive ? "true" : "false"); Serial.print(",");
        Serial.print("\"relay_active\":");    Serial.print(relayActive ? "true" : "false");
        Serial.println("}");
    }

    // Task 3: Infrastructure Heartbeat Metric Logging Vector (Every 5 Seconds)
    if (currentTime - previousHeartbeatTime >= INTERVAL_HEARTBEAT) {
        previousHeartbeatTime = currentTime;
        
        // Output lightweight network diagnostic signals to announce node availability
        Serial.print("{\"heartbeat\":\"PING\",\"uptime_ms\":");
        Serial.print(currentTime);
        Serial.print(",\"relay_status\":");
        Serial.print(getRelayStatus() ? "\"ENGAGED\"" : "\"LOCKED_OUT\"");
        Serial.println("}");
    }
}
