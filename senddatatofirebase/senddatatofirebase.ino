#include <ESP8266WiFi.h>    //esp8266 library
#include <FirebaseArduino.h>     //firebase library
#include <DHT.h>         // dht11 temperature and humidity sensor library
#define FIREBASE_HOST "esp8266-flutter-firebase-eab77.firebaseio.com"  // the project name address from firebase id
#define FIREBASE_AUTH "Rd7DfH1tTSNRkClgtRFqw4eWADm6M0sQgaTYxYk4"  // the secret key generated from firebase

#define WIFI_SSID "FAMILY"                  // wifi name 
#define WIFI_PASSWORD "mamasulami"                 //password of wifi 
 
#define DHTPIN D4                // what digital pin we're connected to
#define DHTTYPE DHT11              // select dht type as DHT 11 or DHT22
DHT dht(DHTPIN, DHTTYPE);                                                     

void setup() {
  Serial.begin(115200);
  //delay(1000);                
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);    
  Serial.print("Connecting to ");
  Serial.print(WIFI_SSID);
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected to ");
  Serial.println(WIFI_SSID);
  Serial.print("IP Address is : ");
  Serial.println(WiFi.localIP());                  //print local IP address
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);     // connect to firebase
  dht.begin();                            //Start reading dht sensor
}

void loop() { 
  int h = dht.readHumidity();       // Reading temperature or humidity 
  int t = dht.readTemperature();   // Read temperature as Celsius (the default)
    
  if (isnan(h) || isnan(t)) {  // Check if any reads failed and exit early (to try again).
    Serial.println(F("Failed to read from DHT sensor!"));
    return;
  }

  if (Firebase.failed())
  {
    //Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
    Serial.print("pushing /logs failed: ");
    Serial.println(Firebase.error());
    return;
  }
  
  Serial.print("Humidity: ");  Serial.print(h);
  String fireHumid = String(h) + String("%");    //convert integer humidity to string humidity 
  Serial.print("%  Temperature: ");  Serial.print(t);  Serial.println("Â°C ");
  String fireTemp = String(t) + String("Â°C"); //convert integer temperature to string temperature
  //delay(1000);
  
  Firebase.setInt("/DHT11/Humidity", h);         //setup path and send readings
  Firebase.setInt("/DHT11/Temperature", t);        //setup path and send readings
   
}
