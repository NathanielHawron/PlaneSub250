#include <WiFi.h>
#include <WebServer.h>

WebServer server(80);

void setup(){
    Serial.begin(115200);

    const char *ap_ssid = "ESP32-Flight-Controller";
    const char *ap_password = "password";

    WiFi.softAP(ap_ssid, ap_password);

    IPAddress myIP = WiFi.softAPIP();
    
    server.on("/",[](){
        server.send(200,"text/html","<p>test</p>");
    });
    server.begin();
}
void loop(){
    server.handleClient();
}