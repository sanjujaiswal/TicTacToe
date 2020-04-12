#!/bin/bash
echo "-----Welcome to Tic-Tac-Toe Game-----"

#Constants declarations
NUMBER=2
ROW=3
COL=3
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
	initialize
}

#Initialize to board
function initialize(){
	echo "Enter position on Board :"
   for (( rowPosition=1;rowPosition<=3;rowPosition++ ))
   do
      echo "---------"
      for (( columnPosition=1;columnPosition<=3;columnPosition++ ))
      do
         board[$rowPosition,$columnPosition]="-"
      done
      echo "| ${board[@]} |"
   done
	echo "---------"
}

resetBoard
echo $currentPlayer
