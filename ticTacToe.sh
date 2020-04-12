#!/bin/bash -x
echo "-----Welcome to Tic-Tac-Toe Game-----"

#Constants declarations
NUMBER=2
TOTAL_COUNT=9
#Variables declarations
tossPlayer=0
moveCount=1
#Array declaration
declare -a board

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
		displayBoard
}

#Function to print board
function displayBoard(){
echo "---------------"
	for (( row=1;row<=3;row++ ))
	do
		for (( column=1;column<=3;column++ ))
		do
			echo -e "| ${board[$row,$column]} | \c"
		done
		echo
	done
	echo "---------------"
}

#Change the player turn
function changePlayer(){
	if [[ $1 == "x" ]]
	then
		currentPlayer="0";
	else
		currentPlayer="x";
	fi
}

#Function to check win condition
function checkWin(){
	gameStatus=0;
	for (( i=1;i<=3;i++ ))
	do
		if [[ ${board[$i,1]} == $currentPlayer && ${board[$i,1]} == ${board[$i,2]} && ${board[$i,1]} == ${board[$i,3]} ]]
		then
			gameStatus=1;
		fi
		if [[ ${board[1,$i]} == $currentPlayer && ${board[1,$i]} == ${board[2,$i]} && ${board[1,$i]} == ${board[3,$i]} ]]
		then
			gameStatus=1;
		fi
	done

	if [[ ${board[1,1]} == $currentPlayer &&  ${board[1,1]} == ${board[2,2]} && ${board[1,1]} == ${board[3,3]} ]]
	then
		gameStatus=1;
	fi

	if [[ ${board[1,3]} == $currentPlayer && ${board[1,3]} == ${board[2,2]} && ${board[1,3]} == ${board[3,1]} ]]
	then
		gameStatus=1;
	fi

	echo $gameStatus
}

#Function to place mark on board
function placeMark(){
	if [[ ${board[$1,$2]} == - ]]
	then
		board[$1,$2]=$currentPlayer
		displayBoard
		if [[ $( checkWin $(()) ) -eq 1 ]]
		then
			echo "$currentPlayer wins!!"
			exit
		fi
		changePlayer $currentPlayer
	else
		echo "Position already occupied"
	fi
}

#start execution
resetBoard
while [[ $moveCount -le $TOTAL_COUNT ]]
do
	read -p "Enter row no. " row
	read -p "Enter column no. " column
	placeMark $row $column
	((moveCount++))
done
if [[ $gameStatus -eq 0 ]]
then
	echo "Match tie !!! "
fi
