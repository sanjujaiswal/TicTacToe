#!/bin/bash -x
echo "-----Welcome to Tic-Tac-Toe Game-----"

#Constants declarations
NUMBER=2
#Variables declarations
tossPlayer=0

#Toss to play first
function tossToPlayFirst(){
	tossPlayer=$((RANDOM%NUMBER))
	if [ $tossPlayer -eq 0 ]
	then
		echo "x"
	else
		echo "0"
	fi
}

#Function to reset board
function resetBoard(){
	currentPlayer=$( tossToPlayFirst );
	gameStatus=1;
	declare -a board;
}

resetBoard
echo $currentPlayer
