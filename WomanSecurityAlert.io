// Woman security alert


//Bibliotecas utilizadas
#include <SoftwareSerial.h>
#include <TinyGPS.h>

//Definindo os números das portas do arduino
#define GPS_RX 5
#define GPS_TX 4
#define GSM_RX 2
#define GSM_TX 3

//Inicializando a biblitoeca TinyGPS e setando os pinos de comunicação dos módulos
TinyGPS gps;
SoftwareSerial Mod_gps(GPS_RX, GPS_TX); 
SoftwareSerial Mod_gsm(GSM_RX , GSM_TX);

void setup()
{
  Mod_gsm.begin(9600);
  Mod_gps.begin(9600);
  Serial.begin(9600);
  digitalWrite(9,HIGH);
}
     
void loop()
{  
    float flat, flon;     //Variáveis para armazenar latitude e longitude
    bool newData = false; //Variável para atualização dos dados do gps
    int statebutton = analogRead(A1);
   

    //Atualiza os dados a cada 1 segundo
    for (unsigned long start = millis(); millis() - start < 1000;){
      while (Mod_gps.available()){
         char c = Mod_gps.read(); //Lendo os dados do gps
      if (gps.encode(c)) // Atribui true para newData caso novos dados sejam recebidos
          newData = true;}}

      //Caso o botão seja pressionado 
      if(statebutton > 1000){
        Mod_gsm.println("AT");
        delay(1000);
        Mod_gsm.println("AT+CMGF=1");//Comando para habilitar o modo SMS
        delay(1000); 
        Mod_gsm.println("AT+CMGS=\"+554599999999\"\r\n"); //Setando o número de telefone para o qual será enviado(+55(DDD)(numero) sem os parentêses)
        delay(1000);
  
        gps.f_get_position(&flat, &flon); //Pegando a posição do GPS

       
        Mod_gsm.println("Preciso de ajuda! Por favor, me encontre! "); //Texto para o inicio da mensagem
        
        //Link do google maps com a latitude e a longitude
        Mod_gsm.print("https://www.google.com/maps/?q=");
        Mod_gsm.print(flat == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flat, 6);
        Mod_gsm.print(",");
        Mod_gsm.print(flon == TinyGPS::GPS_INVALID_F_ANGLE ? 0.0 : flon, 6);
        delay(1000);
        Mod_gsm.print((char)26); //Para enviar a mensagem
        delay(1000);
        
        delay(6000); // Tempo de espera entre as mensagens(em ms)
      }
}
