// Variáveis globais
float ballX, ballY; // Posição da bola
float ballSpeedX, ballSpeedY; // Velocidade da bola
float paddle1Y, paddle2Y; // Posição atual das raquetes
float targetPaddle1Y, targetPaddle2Y; // Posição alvo das raquetes (para suavização)
float paddleHeight = 100; // Altura da raquete
float paddleWidth = 15; // Largura da raquete
int score1, score2; // Placar dos jogadores
int maxScore = 5; // Limite de pontuação
boolean gameOver = false; // Controle do fim do jogo
int difficulty = 1; // Nível de dificuldade (1 = fácil, 2 = médio, 3 = difícil)
float baseSpeed = 5; // Velocidade base da bola
int gameState = 0; // 0 = tela de boas-vindas, 1 = menu principal, 2 = menu de dificuldade, 3 = jogo
boolean vsComputer = false; // Modo jogador vs. computador

void setup() {
  size(800, 600); // Tamanho da tela
  resetGame(); // Inicializa o jogo
  targetPaddle1Y = height / 2 - paddleHeight / 2; // Inicializa alvos
  targetPaddle2Y = height / 2 - paddleHeight / 2;
  paddle1Y = targetPaddle1Y;
  paddle2Y = targetPaddle2Y;
}

void draw() {
  // Fundo com gradiente
  drawGradientBackground();
  
  if (gameState == 0) {
    drawWelcomeScreen();
  } else if (gameState == 1) {
    drawMainMenu();
  } else if (gameState == 2) {
    drawDifficultyMenu();
  } else if (gameState == 3) {
    if (!gameOver) {
      drawPaddles();
      drawBall();
      moveBall();
      checkCollisions();
      drawScore();
      drawBackButton();
      if (vsComputer) moveComputerPaddle();
      // Suaviza o movimento das raquetes
      paddle1Y = lerp(paddle1Y, targetPaddle1Y, 0.2); // Movimento fluido
      paddle2Y = lerp(paddle2Y, targetPaddle2Y, 0.2);
    } else {
      displayWinner();
    }
  }
}

// Fundo com gradiente
void drawGradientBackground() {
  for (int i = 0; i < height; i++) {
    float inter = map(i, 0, height, 0, 1);
    int c = lerpColor(color(20, 40, 80), color(10, 20, 40), inter);
    stroke(c);
    line(0, i, width, i);
  }
}

// Tela de boas-vindas
void drawWelcomeScreen() {
  fill(255, 200);
  textSize(60);
  textAlign(CENTER, CENTER);
  text("PONG", width / 2, height / 2 - 50);
  fill(200, 255, 200);
  textSize(24);
  text("Aperte qualquer tecla para começar", width / 2, height / 2 + 50);
  drawShadow(width / 2 - 100, height / 2 - 70, 200, 80); // Sombra no título
}

// Menu principal
void drawMainMenu() {
  fill(255, 220);
  textSize(40);
  textAlign(CENTER, CENTER);
  text("Menu Principal", width / 2, height / 2 - 120);
  fill(180, 255, 180);
  textSize(28);
  text("1 - Jogador vs. Jogador", width / 2, height / 2 - 20);
  text("2 - Jogador vs. Computador", width / 2, height / 2 + 20);
  drawShadow(width / 2 - 150, height / 2 - 140, 300, 60); // Sombra no título
}

// Menu de dificuldade
void drawDifficultyMenu() {
  fill(255, 220);
  textSize(40);
  textAlign(CENTER, CENTER);
  text("Dificuldade", width / 2, height / 2 - 120);
  fill(180, 255, 180);
  textSize(28);
  text("1 - Fácil", width / 2, height / 2 - 20);
  text("2 - Normal", width / 2, height / 2 + 20);
  text("3 - Difícil", width / 2, height / 2 + 60);
  drawShadow(width / 2 - 150, height / 2 - 140, 300, 60); // Sombra no título
}

// Função para desenhar as raquetes
void drawPaddles() {
  noStroke();
  fill(100, 255, 100); // Cor verde clara
  rect(50, paddle1Y, paddleWidth, paddleHeight, 10); // Raquete 1 com bordas arredondadas
  rect(width - 50 - paddleWidth, paddle2Y, paddleWidth, paddleHeight, 10); // Raquete 2
  drawShadow(50, paddle1Y, paddleWidth, paddleHeight); // Sombra na raquete 1
  drawShadow(width - 50 - paddleWidth, paddle2Y, paddleWidth, paddleHeight); // Sombra na raquete 2
}

// Função para desenhar a bola
void drawBall() {
  noStroke();
  fill(255, 100, 100); // Cor vermelha suave
  ellipse(ballX, ballY, 20, 20);
  drawShadow(ballX - 10, ballY - 10, 20, 20); // Sombra na bola
}

// Função para mover a bola
void moveBall() {
  ballX += ballSpeedX;
  ballY += ballSpeedY;
  
  if (ballY < 0 || ballY > height) {
    ballSpeedY *= -1;
  }
  
  if (ballX < 0) {
    score2++;
    resetBall();
  } else if (ballX > width) {
    score1++;
    resetBall();
  }
  
  if (score1 >= maxScore || score2 >= maxScore) {
    gameOver = true;
  }
}

// Função para verificar colisões
void checkCollisions() {
  if (ballX - 10 < 50 + paddleWidth && ballY > paddle1Y && ballY < paddle1Y + paddleHeight) {
    ballSpeedX *= -1;
    ballSpeedX *= 1.1;
    ballSpeedY *= 1.1;
  }
  
  if (ballX + 10 > width - 50 - paddleWidth && ballY > paddle2Y && ballY < paddle2Y + paddleHeight) {
    ballSpeedX *= -1;
    ballSpeedX *= 1.1;
    ballSpeedY *= 1.1;
  }
}

// Função para desenhar o placar
void drawScore() {
  fill(255, 220);
  textSize(40);
  textAlign(CENTER, CENTER);
  text(score1, width / 4, 50);
  text(score2, 3 * width / 4, 50);
}

// Função para exibir a tela de vencedor
void displayWinner() {
  fill(255, 200);
  textSize(48);
  textAlign(CENTER, CENTER);
  String winner = score1 >= maxScore ? "Jogador 1 Venceu!" : vsComputer ? "Computador Venceu!" : "Jogador 2 Venceu!";
  text(winner, width / 2, height / 2);
  fill(180, 255, 180);
  textSize(24);
  text("Pressione 'R' para reiniciar", width / 2, height / 2 + 50);
  drawShadow(width / 2 - textWidth(winner) / 2, height / 2 - 30, textWidth(winner), 60); // Sombra no texto
}

// Função para desenhar o botão de voltar
void drawBackButton() {
  fill(80, 100, 140, 200); // Cor azul suave com transparência
  rect(10, 10, 120, 40, 10); // Botão com bordas arredondadas
  fill(255);
  textSize(20);
  textAlign(LEFT, CENTER);
  text("Voltar", 20, 30);
  drawShadow(10, 10, 120, 40); // Sombra no botão
}

// Função para mover a raquete do computador
void moveComputerPaddle() {
  float targetY = ballY - paddleHeight / 2;
  targetPaddle2Y = constrain(targetY, 0, height - paddleHeight);
}

// Função para criar sombras
void drawShadow(float x, float y, float w, float h) {
  noStroke();
  fill(0, 50); // Sombra semi-transparente
  rect(x + 5, y + 5, w, h, 10);
}

// Função para reiniciar a bola
void resetBall() {
  ballX = width / 2;
  ballY = height / 2;
  ballSpeedX = baseSpeed * difficulty * (random(1) > 0.5 ? 1 : -1);
  ballSpeedY = baseSpeed * difficulty * (random(1) > 0.5 ? 1 : -1);
}

// Função para reiniciar o jogo
void resetGame() {
  ballX = width / 2;
  ballY = height / 2;
  ballSpeedX = baseSpeed * difficulty;
  ballSpeedY = baseSpeed * difficulty;
  targetPaddle1Y = height / 2 - paddleHeight / 2;
  targetPaddle2Y = height / 2 - paddleHeight / 2;
  paddle1Y = targetPaddle1Y;
  paddle2Y = targetPaddle2Y;
  score1 = 0;
  score2 = 0;
  gameOver = false;
}

void keyPressed() {
  if (gameState == 0) {
    gameState = 1; // Vai para o menu principal
  } else if (gameState == 1) {
    if (key == '1') {
      vsComputer = false;
      gameState = 2; // Menu de dificuldade (PvP)
    } else if (key == '2') {
      vsComputer = true;
      gameState = 2; // Menu de dificuldade (PvC)
    }
  } else if (gameState == 2) {
    if (key == '1') {
      difficulty = 1; // Fácil
      gameState = 3;
      resetGame();
    } else if (key == '2') {
      difficulty = 2; // Normal
      gameState = 3;
      resetGame();
    } else if (key == '3') {
      difficulty = 3; // Difícil
      gameState = 3;
      resetGame();
    }
  } else if (gameState == 3) {
    // Controles do jogo com movimento alvo
    if (!vsComputer) {
      if (key == 'w' || key == 'W') targetPaddle1Y -= 15 * (4 - difficulty);
      if (key == 's' || key == 'S') targetPaddle1Y += 15 * (4 - difficulty);
      if (keyCode == UP) targetPaddle2Y -= 15 * (4 - difficulty);
      if (keyCode == DOWN) targetPaddle2Y += 15 * (4 - difficulty);
    } else {
      if (key == 'w' || key == 'W') targetPaddle1Y -= 15 * (4 - difficulty);
      if (key == 's' || key == 'S') targetPaddle1Y += 15 * (4 - difficulty);
    }
    if (key == 'r' || key == 'R') resetGame();
    // Limita as posições alvo
    targetPaddle1Y = constrain(targetPaddle1Y, 0, height - paddleHeight);
    targetPaddle2Y = constrain(targetPaddle2Y, 0, height - paddleHeight);
  }
}

void mousePressed() {
  if (gameState == 3 && mouseX > 10 && mouseX < 130 && mouseY > 10 && mouseY < 50) {
    gameState = 1; // Volta ao menu principal
  }
}
