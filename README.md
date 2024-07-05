# Tetris Game - 8088 Assembly

Welcome to our Tetris game project, developed in 8088 assembly language! This was a pair project that we are thrilled to share with you. 

## Features

- Simple and classic Tetris gameplay
- Background score
- Start screen and end screen
- Hint of the next shape
- 5-minute timer
- Controls: 
  - `<` to move left
  - `>` to move right
  - `Spacebar` to rotate the shape
- Smooth handling of game mechanics using interrupts

## How to Run the Game

To run the game, follow these steps:

1. **Download Everything**
   - Clone or download the repository to your local machine.

2. **Set Up DOSBox**
   - Mount your folder in DOSBox that includes all the game files, DOSBox, nasm and ADF.

3. **Compile the Game**
   - Run the following command in DOSBox:
     ```
     nasm proj.asm -o proj.com
     ```
   - This will compile the assembly code into a .com file. It may take a few moments.

4. **Run the Game**
   - Once the compilation is complete, type the following command in DOSBox:
     ```
     proj.com
     ```
   - The game will start, and you can begin playing!

## Controls

- Use `<` to move the shape left
- Use `>` to move the shape right
- Use `Spacebar` to rotate the shape

## Enjoy the Game!

This game is close to our hearts, and we hope you enjoy playing it as much as we enjoyed creating it. Have fun and happy gaming! 🎮
