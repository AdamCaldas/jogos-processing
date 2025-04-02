import java.util.ArrayList;
import java.util.Collections;

// Variáveis globais
int numeroSecreto;
int tentativas;
int limiteTentativas = 15;
boolean acertou = false;
String entrada = "";
String mensagem = "";
ArrayList<Integer> recordes = new ArrayList<Integer>();
boolean jogoAtivo = true;
boolean introducaoAtiva = true;

void setup() {
  size(400, 600); 
  background(0);
  textAlign(CENTER, CENTER);
  reiniciarJogo();
}

void draw() {
  background(20, 20, 50); 
  
  if (introducaoAtiva) {
    // Tela de introdução
    fill(255, 215, 0); 
    textSize(24); 
    text("Jogo do Marciano", width/2, 50);
    fill(255);
    textSize(16);
    text("Um marciano escondeu um número entre 1 e 100.\n" +
         "Ache-o em até " + limiteTentativas + " tentativas!\n" +
         "Pressione qualquer tecla para começar.", width/2, height/2 - 50);
  } else {
    // Tela do jogo
    fill(255);
    textSize(20);
    text("Tentativas restantes: " + (limiteTentativas - tentativas), width/2, 50);
    
    textSize(18);
    text("Digite sua tentativa (1-100):", width/2, height/2 - 80);
    fill(200, 255, 200); // Verde claro
    text(entrada, width/2, height/2 - 50);
    
    fill(255, 165, 0); // Laranja
    textSize(20);
    text(mensagem, width/2, height/2);
    
    // Recordes
    if (!recordes.isEmpty()) {
      fill(255);
      textSize(16);
      text("Melhores Jogadas:", width/2, height - 120); 
      Collections.sort(recordes);
      for (int i = 0; i < min(3, recordes.size()); i++) {
        fill(173, 216, 230); // Azul claro
        text((i + 1) + "º: " + recordes.get(i) + " tentativas", width/2, height - 100 + i * 20);
      }
    }
    
    // Instruções no rodapé
    fill(255);
    textSize(14);
    if (jogoAtivo) {
      text("Pressione 'Z' para voltar ao início", width/2, height - 20);
    } else {
      text("Pressione 'R' para jogar novamente", width/2, height - 20);
    }
  }
}

void keyPressed() {
  if (introducaoAtiva) {
    // Qualquer tecla sai da introdução
    introducaoAtiva = false;
    jogoAtivo = true;
  } else if (jogoAtivo) {
    // Entrada de números
    if (key >= '0' && key <= '9') {
      entrada += key;
    }
    // Apagar com Backspace
    else if (key == BACKSPACE && entrada.length() > 0) {
      entrada = entrada.substring(0, entrada.length() - 1);
    }
    // Processar tentativa com Enter
    else if (key == ENTER || key == RETURN) {
      if (entrada.length() > 0) {
        int tentativa = int(entrada);
        tentativas++;
        
        if (tentativa == numeroSecreto) {
          mensagem = "Parabéns! Acertou em " + tentativas + " tentativas!";
          recordes.add(tentativas);
          acertou = true;
          jogoAtivo = false;
        } else if (tentativa < numeroSecreto) {
          mensagem = "O número é MAIOR!";
        } else {
          mensagem = "O número é MENOR!";
        }
        
        if (tentativas >= limiteTentativas && !acertou) {
          mensagem = "Fim! O número era " + numeroSecreto;
          jogoAtivo = false;
        }
        
        entrada = "";
      }
    }
    // Voltar à introdução com 'Z'
    else if (key == 'z' || key == 'Z') {
      introducaoAtiva = true;
      jogoAtivo = false;
      reiniciarJogo();
    }
  } else if (key == 'r' || key == 'R') {
    // Reinicia o jogo diretamente
    reiniciarJogo();
    introducaoAtiva = false;
    jogoAtivo = true;
  }
}

void reiniciarJogo() {
  numeroSecreto = int(random(1, 101)); 
  tentativas = 0;
  acertou = false;
  entrada = "";
  mensagem = "";
}
