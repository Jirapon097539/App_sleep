#include <Wire.h>
#include <SparkFun_Bio_Sensor_Hub_Library.h>
#include <BLEDevice.h>
#include <BLEServer.h>
#include <BLEUtils.h>
#include <BLE2902.h>

int resPin = -1;
int mfioPin = 21;
SparkFun_Bio_Sensor_Hub bioHub(resPin, mfioPin);
bioData body;
float prev_heartRate = 0;
float prev_oxygen = 0;

bool deviceConnected = false;
BLEServer* pServer = NULL;
BLECharacteristic* pCharacteristic = NULL;

#define SERVICE_UUID        "4fafc201-1fb5-459e-8fcc-c5c9c331914b"
#define CHARACTERISTIC_UUID "beb5483e-36e1-4688-b7f5-ea07361b26a8"

class MyServerCallbacks : public BLEServerCallbacks {
    void onConnect(BLEServer* pServer) {
        deviceConnected = true;
        Serial.println("BLE connected");
    }

    void onDisconnect(BLEServer* pServer) {
        deviceConnected = false;
        Serial.println("BLE disconnected");
    }
};

void setup() {
    Serial.begin(115200);
    Wire.begin(19, 20);

    int result = bioHub.begin();
    Serial.println(result);

    Serial.println("Configuring Sensor....");
    int error = bioHub.configBpm(MODE_ONE);
    if (error == 0)
        Serial.println("Sensor configured.");
    else {
        Serial.println("Error configuring sensor.");
        Serial.print("Error: ");
        Serial.println(error);
        while (1); // Stop the program if the sensor configuration fails
    }

    BLEDevice::init("ESP32_Test");

    pServer = BLEDevice::createServer();
    pServer->setCallbacks(new MyServerCallbacks());

    BLEService* pService = pServer->createService(SERVICE_UUID);

    pCharacteristic = pService->createCharacteristic(
        CHARACTERISTIC_UUID,
        BLECharacteristic::PROPERTY_READ |
        BLECharacteristic::PROPERTY_NOTIFY
    );

    pCharacteristic->addDescriptor(new BLE2902());

    pService->start();

    BLEAdvertising* pAdvertising = BLEDevice::getAdvertising();
    pAdvertising->addServiceUUID(SERVICE_UUID);
    pAdvertising->setScanResponse(false);
    pAdvertising->setMinPreferred(0x0);
    BLEDevice::startAdvertising();

    Serial.println("Waiting for a BLE client connection...");
}

unsigned long fingerDetectedTimestamp = 0;  // Timestamp when finger was last detected
void loop() {
    if (deviceConnected) {
        body = bioHub.readBpm();
        if (body.heartRate > 0 && body.oxygen > 0 && body.status == 3) {
            fingerDetectedTimestamp = millis();
            if (prev_heartRate != body.heartRate || prev_oxygen != body.oxygen) {
                prev_heartRate = body.heartRate;
                prev_oxygen = body.oxygen;
                String str = String(prev_heartRate) + "," + String(prev_oxygen);
                pCharacteristic->setValue(str.c_str());
                pCharacteristic->notify();

                Serial.println("Sending data over BLE:");
                Serial.print("Heart Rate: ");
                Serial.print(prev_heartRate);
                Serial.print(" bpm, Oxygen: ");
                Serial.print(prev_oxygen);
                Serial.println("%");
            }
        }

        if (millis() - fingerDetectedTimestamp >= 5000) {
            Serial.println("Hand has been still for 5 seconds.");
        }
    }

    delay(1000);
}
