// Estados do jogo
int tela = 1; // 1: início, 2: menu, 3: jogo, 4: vitória

// Jogo
int cols, rows, totalCards;
int[] cartas;
boolean[] reveladas;
boolean[] acertadas;
int primeiraCarta = -1;
int segundaCarta = -1;
int tempoVirar = 0;
boolean podeClicar = true;

// Placar
int tempoInicio;
int tempoFinal = 0;
int recorde = -1;

// Cores
color fundo = color(255, 240, 220);

void setup() {
  size(700, 600);
}

void draw() {
  background(fundo);

  if (tela == 1) {
    telaInicial();
  } else if (tela == 2) {
    telaMenu();
  } else if (tela == 3) {
    telaJogo();
  } else if (tela == 4) {
    telaVitoria();
  }
}

// --- TELA 1: INÍCIO ---
void telaInicial() {
  background(255, 210, 180);
  fill(255, 100, 100);
  stroke(255, 50, 50);
  strokeWeight(8);
  ellipse(width/2, height/2, 300, 300);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(36);
  text("Jogo da Memória", width/2, height/2);

  textSize(20);
  fill(50);
  text("Clique para começar", width/2, height - 50);
}

// --- TELA 2: MENU DE NÍVEL ---
void telaMenu() {
  background(255, 240, 220);
  textAlign(CENTER, CENTER);
  textSize(30);
  fill(50);
  text("Selecione a dificuldade", width/2, 100);

  desenhaBotao(width/2 - 100, 200, 200, 50, "Fácil (4x4)");
  desenhaBotao(width/2 - 100, 300, 200, 50, "Médio (5x4)");
  desenhaBotao(width/2 - 100, 400, 200, 50, "Difícil (6x4)");
}

void desenhaBotao(float x, float y, float w, float h, String texto) {
  fill(255, 200, 150);
  stroke(100);
  rect(x, y, w, h, 12);
  fill(0);
  textSize(18);
  text(texto, x + w/2, y + h/2);
}

// --- TELA 3: JOGO ---
void telaJogo() {
  int w = width / cols;
  int h = height / rows;

  for (int i = 0; i < totalCards; i++) {
    int x = (i % cols) * w;
    int y = (i / cols) * h;

    if (acertadas[i] || reveladas[i]) {
      desenhaFruta(cartas[i], x, y, w, h);
    } else {
      desenhaVerso(x, y, w, h);
    }
  }

  // Temporizador de virada
  if (!podeClicar && millis() > tempoVirar) {
    if (cartas[primeiraCarta] == cartas[segundaCarta]) {
      acertadas[primeiraCarta] = true;
      acertadas[segundaCarta] = true;
    } else {
      reveladas[primeiraCarta] = false;
      reveladas[segundaCarta] = false;
    }
    primeiraCarta = -1;
    segundaCarta = -1;
    podeClicar = true;
  }

  // Placar
  fill(0);
  textSize(18);
  textAlign(LEFT, TOP);
  int tempoAtual = (millis() - tempoInicio) / 1000;
  text("⏱ Tempo: " + tempoAtual + "s", 10, 10);
  if (recorde > 0) {
    text("🏆 Recorde: " + recorde + "s", 10, 35);
  }

  if (venceu()) {
    tempoFinal = (millis() - tempoInicio) / 1000;
    if (recorde == -1 || tempoFinal < recorde) {
      recorde = tempoFinal;
    }
    tela = 4;
  }
}

// --- TELA 4: VITÓRIA ---
void telaVitoria() {
  background(220, 255, 220);
  textAlign(CENTER, CENTER);
  fill(0, 150, 0);
  textSize(40);
  text("🎉 Você venceu!", width/2, height/2 - 40);

  fill(0);
  textSize(20);
  text("Tempo: " + tempoFinal + "s", width/2, height/2 + 10);
  text("Clique para jogar novamente", width/2, height - 50);
}

// --- CLIQUES ---
void mousePressed() {
  if (tela == 1) {
    tela = 2;
  } else if (tela == 2) {
    // Facil
    if (mouseY > 200 && mouseY < 250) iniciarJogo(4, 4);
    // Medio
    else if (mouseY > 300 && mouseY < 350) iniciarJogo(5, 4);
    // Dificil
    else if (mouseY > 400 && mouseY < 450) iniciarJogo(6, 4);
  } else if (tela == 3) {
    int w = width / cols;
    int h = height / rows;

    int col = mouseX / w;
    int row = mouseY / h;
    int index = row * cols + col;

    if (index < 0 || index >= totalCards) return;
    if (reveladas[index] || acertadas[index]) return;
    if (!podeClicar) return;

    reveladas[index] = true;

    if (primeiraCarta == -1) {
      primeiraCarta = index;
    } else if (segundaCarta == -1 && index != primeiraCarta) {
      segundaCarta = index;
      podeClicar = false;
      tempoVirar = millis() + 1000;
    }
  } else if (tela == 4) {
    tela = 2;
  }
}

void iniciarJogo(int c, int r) {
  cols = c;
  rows = r;
  totalCards = cols * rows;

  cartas = new int[totalCards];
  reveladas = new boolean[totalCards];
  acertadas = new boolean[totalCards];

  for (int i = 0; i < totalCards; i++) {
    cartas[i] = i % 8;
  }
  embaralhar(cartas);
  primeiraCarta = -1;
  segundaCarta = -1;
  tempoVirar = 0;
  podeClicar = true;
  tempoInicio = millis();
  tela = 3;
}

void embaralhar(int[] array) {
  for (int i = array.length - 1; i > 0; i--) {
    int j = (int) random(i + 1);
    int temp = array[i];
    array[i] = array[j];
    array[j] = temp;
  }
}

boolean venceu() {
  for (boolean acerto : acertadas) {
    if (!acerto) return false;
  }
  return true;
}

// --- CARTAS VETORIAIS ---
void desenhaFruta(int tipo, float x, float y, float w, float h) {
  pushMatrix();
  translate(x + w/2, y + h/2);
  scale(min(w, h) / 100.0);

  switch(tipo % 8) {
    case 0: frutaMaca(); break;
    case 1: frutaBanana(); break;
    case 2: frutaLaranja(); break;
    case 3: frutaMorango(); break;
    case 4: frutaUva(); break;
    case 5: frutaPera(); break;
    case 6: frutaCereja(); break;
    case 7: frutaKiwi(); break;
  }

  popMatrix();
}

void desenhaVerso(float x, float y, float w, float h) {
  fill(150);
  stroke(80);
  rect(x + 5, y + 5, w - 10, h - 10, 10);
}

// --- Frutas ---
void frutaMaca() {
  fill(220, 0, 0);
  stroke(0);
  ellipse(-20, 0, 50, 60);
  ellipse(20, 0, 50, 60);
  stroke(80, 42, 42);
  strokeWeight(5);
  line(0, -30, 0, -50);
  fill(50, 200, 50);
  noStroke();
  ellipse(10, -50, 20, 10);
}

void frutaBanana() {
  noStroke();
  fill(255, 230, 50);
  beginShape();
  vertex(-20, -10);
  bezierVertex(-40, -40, 40, -40, 20, 10);
  bezierVertex(10, 30, -10, 30, -20, -10);
  endShape(CLOSE);
}

void frutaLaranja() {
  fill(255, 150, 0);
  stroke(200, 100, 0);
  strokeWeight(2);
  ellipse(0, 0, 60, 60);
  stroke(255);
  line(-20, 0, 20, 0);
  line(0, -20, 0, 20);
}

void frutaMorango() {
  fill(255, 0, 100);
  stroke(200, 0, 80);
  beginShape();
  vertex(0, -30);
  bezierVertex(30, -10, 30, 40, 0, 50);
  bezierVertex(-30, 40, -30, -10, 0, -30);
  endShape(CLOSE);
  fill(0, 150, 0);
  ellipse(-10, -30, 10, 10);
  ellipse(10, -30, 10, 10);
}

void frutaUva() {
  fill(100, 0, 200);
  noStroke();
  for (int i = -1; i <= 1; i++) {
    for (int j = 0; j < 2; j++) {
      ellipse(i * 15, j * 15, 20, 20);
    }
  }
}

void frutaPera() {
  fill(150, 220, 100);
  stroke(0);
  ellipse(0, 10, 40, 50);
  ellipse(0, -10, 25, 30);
  stroke(100, 50, 0);
  line(0, -30, 0, -40);
}

void frutaCereja() {
  fill(200, 0, 0);
  ellipse(-10, 10, 20, 20);
  ellipse(10, 10, 20, 20);
  stroke(0, 100, 0);
  line(-10, 0, -10, -15);
  line(10, 0, 10, -15);
}

void frutaKiwi() {
  fill(110, 70, 20);
  ellipse(0, 0, 60, 60);
  fill(180, 255, 100);
  ellipse(0, 0, 40, 40);
  fill(50, 150, 0);
  for (int i = 0; i < 12; i++) {
    float angle = TWO_PI / 12 * i;
    ellipse(cos(angle) * 15, sin(angle) * 15, 5, 5);
  }
}
