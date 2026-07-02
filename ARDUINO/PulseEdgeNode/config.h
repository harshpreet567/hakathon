#ifndef CONFIG_H
#define CONFIG_H

// --- HARDWARE PIN ASSIGNMENTS ---
#define PIN_TEMP_SENSOR    A0   // Analog input for Temperature Sensor (LM35 / NTC Thermistor)
#define PIN_CURRENT_SENSOR A1   // Analog input for Current Sensor (ACS712)
#define PIN_PIR_MOTION     2    // Digital input for PIR Motion Sensor
#define PIN_RELAY          3    // Digital output to control the Relay Module

// --- CALIBRATION PARAMETERS ---
#define ADC_RESOLUTION     1023.0
#define SYSTEM_VOLTAGE     5.0
#define CURRENT_SENSITIVITY 0.185 // Sensitivity for ACS712-05B (185mV/A)

// --- TIMING INTERVALS (Milliseconds) ---
#define INTERVAL_TELEMETRY 1000   // Read and transmit sensor data every 1 second
#define INTERVAL_HEARTBEAT 5000   // Send status heartbeat every 5 seconds

#endif
