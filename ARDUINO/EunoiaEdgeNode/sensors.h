#ifndef SENSORS_H
#define SENSORS_H

#include <Arduino.h>
#include "config.h"

/**
 * Reads the analog voltage from the temperature sensor and converts it to Celsius.
 * Assumes a standard LM35 linear temperature sensor (10mV per degree Celsius).
 * @return float Calculated temperature in Celsius.
 */
float readTemperature() {
    int rawADC = analogRead(PIN_TEMP_SENSOR);
    float voltage = (rawADC / ADC_RESOLUTION) * SYSTEM_VOLTAGE;
    float temperatureC = voltage * 100.0; 
    return temperatureC;
}

/**
 * Reads the ACS712 current sensor by sampling the AC/DC waveform to find its offset.
 * Calculates the Root Mean Square (RMS) or steady DC current draw.
 * @return float Calculated current in Amperes.
 */
float readCurrent() {
    int samples = 10;
    float totalVoltage = 0.0;
    
    for (int i = 0; i < samples; i++) {
        int rawADC = analogRead(PIN_CURRENT_SENSOR);
        // ACS712 sits at VCC / 2 (2.5V) when there is zero current passing through it
        float voltage = (rawADC / ADC_RESOLUTION) * SYSTEM_VOLTAGE - (SYSTEM_VOLTAGE / 2.0);
        totalVoltage += voltage;
        delay(1);
    }
    
    float averageVoltage = totalVoltage / samples;
    float currentA = abs(averageVoltage / CURRENT_SENSITIVITY);
    return currentA;
}

/**
 * Checks the digital logic state of the passive infrared sensor.
 * @return bool True if physical movement is detected in the workspace area.
 */
bool readMotion() {
    return (digitalRead(PIN_PIR_MOTION) == HIGH);
}

#endif
