#define LED_PIN 12

int state = 1; 
unsigned long old;
unsigned long tempo_but1;
unsigned long tempo_but2;
unsigned long range = 500; 
void setup() {
  pinMode(LED_PIN, OUTPUT);
  old = tempo_but1 =tempo_but2 = millis(); 
  pinMode(A1,INPUT_PULLUP);
  pinMode(A2,INPUT_PULLUP);
  pinMode(A3,INPUT_PULLUP);
}
 
void loop() {
  unsigned long now = millis();
  //unsigned range = 500;
  if(now >= old + range)
  {
    old = now;
    state = !state;
    digitalWrite(LED_PIN, state);
  }
  int but1 = digitalRead(A1);
  if(!but1 && now >= tempo_but1 + 500)
  {
    tempo_but1 = millis();
    if(tempo_but1 - tempo_but2 < 500)
    {
      digitalWrite(LED_PIN, HIGH);
      while(1);
    }
    range = range - 100;
  }
  int but2 = digitalRead(A2);
  if(!but2 && now >= tempo_but2 + 500)
  {
    tempo_but2 = millis();
    if(tempo_but2 - tempo_but1 < 500)
    {
      digitalWrite(LED_PIN, HIGH);
      while(1);  
    }
    range = range + 100;
    tempo_but2 = millis();
  }
}
