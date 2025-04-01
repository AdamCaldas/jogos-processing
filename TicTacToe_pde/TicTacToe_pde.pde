// Variáveis do jogo
char[][] board = new char[3][3]; // Tabuleiro 3x3
boolean playerVsPlayer = false;  // Modo: false = vs Computador, true = vs Jogador
int currentPlayer = 1;           // 1 = 'X', 2 = 'O'
boolean gameOver = false;        // Controla se o jogo terminou
String message = "Jogador 1 (X), sua vez!";
int screen = 0;                  // 0 = Boas-vindas, 1 = Menu, 2 = Jogo

// Configurações iniciais
void setup() {
  size(600, 700); // Tamanho da janela
  resetGame();    // Inicializa o tabuleiro
  textAlign(CENTER, CENTER);
}

// Reinicia o jogo
void resetGame() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      board[i][j] = ' '; // Limpa o tabuleiro
    }
  }
  currentPlayer = 1;
  gameOver = false;
  message = "Jogador 1 (X), sua vez!";
}

// Desenha a interface
void draw() {
  if (screen == 0) {
    drawWelcomeScreen();
  } else if (screen == 1) {
    drawMenuScreen();
  } else if (screen == 2) {
    drawGameScreen();
  }
}

// Tela 1: Boas-vindas
void drawWelcomeScreen() {
  background(245, 245, 220); // Fundo bege claro (igual ao jogo)
  fill(139, 69, 19); // Marrom escuro (igual ao jogo)
  textSize(50);
  text("Bem-vindo ao", width/2, height/2 - 50);
  text("Jogo da Velha", width/2, height/2 + 10);
  fill(160, 82, 45); // Marrom médio (botões do jogo)
  textSize(30);
  text("Aperte Enter para começar", width/2, height/2 + 100);
}

// Tela 2: Menu de escolha
void drawMenuScreen() {
  background(245, 245, 220); // Fundo bege claro (igual ao jogo)
  fill(139, 69, 19); // Marrom escuro (igual ao jogo)
  textSize(40);
  text("Escolha o modo de jogo", width/2, 150);
  
  // Botões de opções
  drawOptionButton(200, 300, 200, 60, "1 vs 1");
  drawOptionButton(200, 400, 200, 60, "vs Computador");
}

// Tela 3: Jogo
void drawGameScreen() {
  background(245, 245, 220); // Fundo bege claro
  
  // Sombra do tabuleiro
  noStroke();
  fill(0, 0, 0, 50);
  rect(155, 155, 310, 310, 15);
  
  // Desenha o tabuleiro
  strokeWeight(4);
  stroke(139, 69, 19);
  fill(255, 245, 230);
  rect(150, 150, 300, 300, 10);
  
  // Linhas do tabuleiro
  line(250, 150, 250, 450);
  line(350, 150, 350, 450);
  line(150, 250, 450, 250);
  line(150, 350, 450, 350);
  
  // Desenha os símbolos no tabuleiro
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      float x = 200 + j * 100;
      float y = 200 + i * 100;
      if (board[i][j] == 'X') {
        drawX(x, y);
      } else if (board[i][j] == 'O') {
        drawO(x, y);
      }
    }
  }
  
  // Área de mensagem
  fill(139, 69, 19, 200);
  noStroke();
  rect(50, 70, 500, 60, 10);
  fill(255);
  textSize(28);
  text(message, width/2, 100);
  
  // Botão "Voltar"
  drawBackButton(20, 20, 100, 40);
}

// Desenha botão de opção no menu
void drawOptionButton(int x, int y, int w, int h, String label) {
  boolean hover = mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  if (hover) {
    fill(210, 180, 140); // Bege se hover (igual ao jogo)
  } else {
    fill(160, 82, 45); // Marrom padrão (igual ao jogo)
  }
  stroke(139, 69, 19);
  strokeWeight(2);
  rect(x, y, w, h, 10);
  fill(255);
  textSize(24);
  text(label, x + w/2, y + h/2);
}

// Desenha o botão "Voltar"
void drawBackButton(int x, int y, int w, int h) {
  boolean hover = mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  if (hover) {
    fill(210, 180, 140); // Bege se hover
  } else {
    fill(160, 82, 45); // Marrom padrão
  }
  stroke(139, 69, 19);
  strokeWeight(2);
  rect(x, y, w, h, 10);
  fill(255);
  textSize(20);
  text("Voltar", x + w/2, y + h/2);
}

// Desenha 'X' com efeito
void drawX(float x, float y) {
  stroke(220, 20, 60);
  strokeWeight(10);
  line(x - 35, y - 35, x + 35, y + 35);
  line(x + 35, y - 35, x - 35, y + 35);
  stroke(255, 100, 120, 150);
  strokeWeight(6);
  line(x - 35, y - 35, x + 35, y + 35);
  line(x + 35, y - 35, x - 35, y + 35);
}

// Desenha 'O' com efeito
void drawO(float x, float y) {
  noFill();
  stroke(70, 130, 180);
  strokeWeight(10);
  ellipse(x, y, 70, 70);
  stroke(135, 206, 235, 150);
  strokeWeight(6);
  ellipse(x, y, 70, 70);
}

// Verifica entrada do teclado
void keyPressed() {
  if (screen == 0 && key == ENTER) {
    screen = 1; // Vai para o menu de escolha
  }
}

// Verifica clique do mouse
void mousePressed() {
  if (screen == 1) {
    // Seleção de modo no menu
    if (mouseY > 300 && mouseY < 360 && mouseX > 200 && mouseX < 400) { // 1 vs 1
      playerVsPlayer = true;
      screen = 2;
      resetGame();
      message = "Modo vs Jogador. Jogador 1 (X), sua vez!";
    } else if (mouseY > 400 && mouseY < 460 && mouseX > 200 && mouseX < 400) { // vs Computador
      playerVsPlayer = false;
      screen = 2;
      resetGame();
      message = "Modo vs Computador. Jogador 1 (X), sua vez!";
    }
  } else if (screen == 2) {
    // Botão "Voltar"
    if (mouseX > 20 && mouseX < 120 && mouseY > 20 && mouseY < 60) {
      screen = 1;
      resetGame();
      return;
    }
    
    if (gameOver) {
      resetGame();
      return;
    }
    
    // Jogada no tabuleiro
    if (mouseX > 150 && mouseX < 450 && mouseY > 150 && mouseY < 450) {
      int row = (mouseY - 150) / 100;
      int col = (mouseX - 150) / 100;
      
      if (board[row][col] == ' ') {
        if (currentPlayer == 1) {
          board[row][col] = 'X';
          message = "Jogador 2 (O), sua vez!";
        } else {
          board[row][col] = 'O';
          message = "Jogador 1 (X), sua vez!";
        }
        
        if (checkWin()) {
          message = "Jogador " + currentPlayer + " venceu!";
          gameOver = true;
        } else if (isBoardFull()) {
          message = "Empate!";
          gameOver = true;
        } else {
          currentPlayer = (currentPlayer == 1) ? 2 : 1;
          if (!playerVsPlayer && currentPlayer == 2) {
            computerMove();
          }
        }
      }
    }
  }
}

// Movimento do computador (jogada aleatória)
void computerMove() {
  if (gameOver) return;
  
  ArrayList<int[]> emptyCells = new ArrayList<int[]>();
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == ' ') {
        emptyCells.add(new int[]{i, j});
      }
    }
  }
  
  if (!emptyCells.isEmpty()) {
    int[] move = emptyCells.get((int)random(emptyCells.size()));
    board[move[0]][move[1]] = 'O';
    
    if (checkWin()) {
      message = "Computador venceu!";
      gameOver = true;
    } else if (isBoardFull()) {
      message = "Empate!";
      gameOver = true;
    } else {
      currentPlayer = 1;
      message = "Jogador 1 (X), sua vez!";
    }
  }
}

// Verifica se há um vencedor
boolean checkWin() {
  for (int i = 0; i < 3; i++) {
    if (board[i][0] != ' ' && board[i][0] == board[i][1] && board[i][1] == board[i][2]) return true;
    if (board[0][i] != ' ' && board[0][i] == board[1][i] && board[1][i] == board[2][i]) return true;
  }
  if (board[0][0] != ' ' && board[0][0] == board[1][1] && board[1][1] == board[2][2]) return true;
  if (board[0][2] != ' ' && board[0][2] == board[1][1] && board[1][1] == board[2][0]) return true;
  return false;
}

// Verifica se o tabuleiro está cheio
boolean isBoardFull() {
  for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
      if (board[i][j] == ' ') return false;
    }
  }
  return true;
}
