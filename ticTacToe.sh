#!/bin/bash
echo "-----Welcome to Tic-Tac-Toe Game-----"

#Function to reset board
function resetBoard(){
	echo "Tic-Tac-Toe Game"
	currentPlayer=x;
	gameStatus=1;
	declare -a board;
}

resetBoard
echo $currentPlayer
