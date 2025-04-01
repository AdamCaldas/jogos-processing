// Declaração das variáveis globais
String[] frutas = {"maça", "banana", "laranja", "uva", "manga"};
String[] cidades = {"recife", "são paulo", "rio", "manaus", "belém"};
String[] objetos = {"mesa", "cadeira", "lápis", "caneta", "livro"};
String[] palavras;
String palavraSecreta;
String palavraAtual;
int tentativasRestantes = 6;
boolean jogoAcabou = false;
String mensagem = "";
char[] letrasUsadas = new char[26];
int letrasUsadasCount = 0;
int tela = 0;

void setup() {
  size(800, 600);
  textAlign(CENTER, CENTER);
}

void draw() {
  if (tela == 0) {
    desenharTelaInicial();
  } else if (tela == 1) {
    desenharMenu();
  } else if (tela == 2) {
    desenharJogo();
  }
}

void desenharTelaInicial() {
  background(50, 150, 200);
  fill(255);
  textSize(40); // Tamanho reduzido para caber no círculo
  text("Jogo da Forca", width/2, height/3);
  fill(0, 200, 0);
  rect(width/2 - 100, height/2, 200, 80, 20);
  fill(255);
  textSize(30);
  text("Iniciar", width/2, height/2 + 40);
  stroke(255);
  strokeWeight(2);
  noFill();
  ellipse(width/2, height/3, 300, 100); // Círculo maior que o texto
}

void desenharMenu() {
  background(200, 220, 255);
  fill(0);
  textSize(40);
  text("Escolha um Tema", width/2, 100);
  desenharBotao("Frutas", width/2 - 150, 200, 300, 80);
  desenharBotao("Cidades", width/2 - 150, 300, 300, 80);
  desenharBotao("Objetos", width/2 - 150, 400, 300, 80);
}

void desenharBotao(String texto, float x, float y, float w, float h) {
  fill(100, 150, 255);
  rect(x, y, w, h, 20);
  fill(255);
  textSize(30);
  text(texto, x + w/2, y + h/2);
}

void desenharJogo() {
  background(240);
  
  // Botão de voltar ao menu (canto superior esquerdo)
  fill(200);
  rect(10, 10, 100, 50, 10);
  fill(0);
  textSize(20);
  text("Voltar", 60, 35);
  stroke(0);
  strokeWeight(2);
  
  // Forca maior e mais alta
  desenharForca(6 - tentativasRestantes);
  
  // Área à direita para a palavra (fundo azul)
  fill(100, 150, 255);
  rect(400, 200, 350, 100, 20);
  fill(255);
  textSize(32);
  text(palavraAtual, 575, 250);
  
  // Letras usadas acima da palavra
  String usadas = "Letras usadas: ";
  for (int i = 0; i < letrasUsadasCount; i++) {
    usadas += letrasUsadas[i] + " ";
  }
  fill(0);
  textSize(20);
  text(usadas, 575, 150);
  
  // Tentativas restantes acima da palavra
  text("Tentativas: " + tentativasRestantes, 575, 180);
  
  // Mensagem de fim de jogo
  if (jogoAcabou) {
    fill(0, 0, 255);
    textSize(28);
    if (tentativasRestantes > 0) {
      text("Você venceu! Palavra: " + palavraSecreta, 575, 100);
    } else {
      text("Você perdeu! Palavra: " + palavraSecreta, 575, 100);
    }
    text("Pressione 'R' para recomeçar", 575, 500);
  }
}

void mousePressed() {
  if (tela == 0) {
    if (mouseX > width/2 - 100 && mouseX < width/2 + 100 && 
        mouseY > height/2 && mouseY < height/2 + 80) {
      tela = 1;
    }
  } else if (tela == 1) {
    if (mouseX > width/2 - 150 && mouseX < width/2 + 150) {
      if (mouseY > 200 && mouseY < 280) {
        palavras = frutas;
        iniciarJogo();
      } else if (mouseY > 300 && mouseY < 380) {
        palavras = cidades;
        iniciarJogo();
      } else if (mouseY > 400 && mouseY < 480) {
        palavras = objetos;
        iniciarJogo();
      }
    }
  } else if (tela == 2) {
    if (mouseX > 10 && mouseX < 110 && mouseY > 10 && mouseY < 60) {
      tela = 1;
    }
  }
}

void keyPressed() {
  if (tela == 2 && !jogoAcabou && key >= 'a' && key <= 'z') {
    char letra = key;
    boolean jaUsada = false;
    for (int i = 0; i < letrasUsadasCount; i++) {
      if (letrasUsadas[i] == letra) {
        jaUsada = true;
        break;
      }
    }
    
    if (!jaUsada) {
      letrasUsadas[letrasUsadasCount] = letra;
      letrasUsadasCount++;
      
      boolean acertou = false;
      String novaPalavraAtual = "";
      for (int i = 0; i < palavraSecreta.length(); i++) {
        if (palavraSecreta.charAt(i) == letra) {
          novaPalavraAtual += letra;
          acertou = true;
        } else {
          novaPalavraAtual += palavraAtual.charAt(i);
        }
      }
      
      palavraAtual = novaPalavraAtual;
      
      if (!acertou) {
        tentativasRestantes--;
      }
      
      if (tentativasRestantes <= 0) {
        jogoAcabou = true;
      } else if (!palavraAtual.contains("_")) {
        jogoAcabou = true;
      }
    }
  }
  
  if (tela == 2 && jogoAcabou && key == 'r') {
    iniciarJogo();
  }
}

void iniciarJogo() {
  palavraSecreta = palavras[int(random(palavras.length))];
  palavraAtual = "";
  for (int i = 0; i < palavraSecreta.length(); i++) {
    palavraAtual += "_";
  }
  tentativasRestantes = 6;
  jogoAcabou = false;
  mensagem = "";
  letrasUsadasCount = 0;
  tela = 2;
}

void desenharForca(int erros) {
  stroke(139, 69, 19); // Marrom
  strokeWeight(6); // Linhas mais grossas para parecer maior
  
  // Forca maior e alinhada com a área da palavra
  float xBase = 150; // Posição base
  float yBase = 300; // Alinhada com a palavra (y = 200 a 300)
  line(xBase - 75, yBase + 100, xBase + 75, yBase + 100); // Chão maior
  line(xBase, yBase + 100, xBase, yBase - 100); // Poste vertical maior
  line(xBase, yBase - 100, xBase + 75, yBase - 100); // Poste horizontal maior
  line(xBase + 75, yBase - 100, xBase + 75, yBase - 80); // Corda
  
  if (erros >= 1) {
    noFill();
    ellipse(xBase + 75, yBase - 50, 80, 80); // Cabeça maior
  }
  if (erros >= 2) {
    line(xBase + 75, yBase - 10, xBase + 75, yBase + 50); // Corpo maior
  }
  if (erros >= 3) {
    line(xBase + 75, yBase, xBase + 35, yBase - 40); // Braço esquerdo
  }
  if (erros >= 4) {
    line(xBase + 75, yBase, xBase + 115, yBase - 40); // Braço direito
  }
  if (erros >= 5) {
    line(xBase + 75, yBase + 50, xBase + 35, yBase + 90); // Perna esquerda
  }
  if (erros >= 6) {
    line(xBase + 75, yBase + 50, xBase + 115, yBase + 90); // Perna direita
  }
}
