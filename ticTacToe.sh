#!/bin/bash

#Constants declaration
TOTAL_COUNT=9
ROW=3
COLUMN=3
NUMBER=2
#Variables declaration
moveCount=1;
computerPlayer="0";
flag=1;

#Array declaration
declare -A board


#Toss tomplay first
function tossPlayer(){
	tossPlayer=$((RANDOM%NUMBER))
	if [ $tossPlayer -eq 0 ]
	then
		echo "x"
	else
		echo $computerPlayer
	fi
}

#Function to reset board
function resetBoard(){
	echo "Tic Tac Toe Game"
	currentPlayer=$( tossPlayer );
	gameStatus=0;
	initalize
}
#Initialization of board
function initalize(){
	for (( rowPosition=1;$rowPosition<=$ROW;rowPosition++ ))
	do
		for (( columnPosition=1;$columnPosition<=$COLUMN;columnPosition++ ))
		do
			board[$rowPosition,$columnPosition]="-"
		done
	done
			displayBoard
}
#Display the board
function displayBoard(){
	echo "---------------"
	for (( row=1;row<=$ROW;row++ ))
	do
		for (( column=1;column<=$COLUMN;column++ ))
		do
			echo -e "| ${board[$row,$column]} | \c"
		done
		echo
	done
	echo "---------------"
}
#Change players turn
function changePlayer(){
	if [[ $1 == "x" ]]
	then
		currentPlayer="0";
	else
		currentPlayer="x";
	fi
}
#Check win conditions
function checkWin(){
	gameStatus=0;
	for (( i=1;i<=$ROW;i++ ))
	do
		if [[ ${board[$i,1]} == $1 && ${board[$i,1]} == ${board[$i,2]} && ${board[$i,1]} == ${board[$i,3]} ]]
		then
			gameStatus=1;
		fi
		if [[ ${board[1,$i]} == $1 && ${board[1,$i]} == ${board[2,$i]} && ${board[1,$i]} == ${board[3,$i]} ]]
		then
			gameStatus=1;
		fi
	done
	if [[ ${board[1,1]} == $1 &&  ${board[1,1]} == ${board[2,2]} && ${board[1,1]} == ${board[3,3]} ]]
	then
		gameStatus=1;
	fi
	if [[ ${board[1,3]} == $1 && ${board[1,3]} == ${board[2,2]} && ${board[1,3]} == ${board[3,1]} ]]
	then
		gameStatus=1;
	fi
}

#Write mark on board
function placeMark(){
	if [[ ${board[$1,$2]} == - ]]
	then
		board[$1,$2]=$currentPlayer
		displayBoard
		checkWin $currentPlayer
		if [[ $gameStatus -eq 1 ]]
		then
			echo "$currentPlayer wins !!"
			exit
		fi
		changePlayer $currentPlayer
		((moveCount++))
	else
		echo "Position already occupied"
	fi
}

#Calculate column
function calColumn(){
	if [[ $1%$COLUMN -eq 0 ]]
	then
		column=$COLUMN;
	else
		column=$(($1%$COLUMN))
	fi
	echo $column
}

#Set player mark at position
function assignCornerCentreSide(){
	if [[ $flag -eq 1 ]]
	then
		if [[ ${board[$2,$3]} == "-" ]]
		then
			board[$2,$3]=$1
			displayBoard
			gameStatus=0;
			((moveCount++))
			flag=0;
		fi
	fi
}

#Take any available corners,centre and side if neither of player is winnig.
function availableCornersCentreSide(){
	if [[ $flag -eq 1 ]]
	then
		#Take corners
		for (( row=1;row<=$ROW;$((row+=2)) ))
		do
			for (( column=1;column<=$COLUMN;$((column+=2)) ))
			do
				assignCornerCentreSide $1 $row $column
			done
		done
		#Take Centre 
		assignCornerCentreSide $1 $(($ROW/2+1)) $(($COLUMN/2+1))
		#Take sides
		for (( row=1;row<=$ROW;row++ ))
		do
			for (( column=1;column<=$COLUMN;column++ ))
			do
				assignCornerCentreSide $1 $row $column
			done
		done
	fi
}
#check play win and block user if he/she is winning
function playWinAndBlockUser(){
	flag=1;
	for (( row=1;row<=$ROW;row++ ))
	do
		for (( column=1;column<=$COLUMN;column++ ))
		do
			if [[ ${board[$row,$column]} == - ]]
			then
				board[$row,$column]=$1
				checkWin $1
				if [[ $gameStatus -eq 0 ]]
				then
					board[$row,$column]="-"
				elif [[ $gameStatus == 1 && ${board[$row,$column]} == $currentPlayer ]]
				then
					displayBoard
					echo "$currentPlayer wins !"
					exit
				elif [[ $gameStatus -eq 1 ]]
				then
					board[$row,$column]=$currentPlayer
					displayBoard
					gameStatus=0
					((moveCount++))
					flag=0;
					break
				fi
			fi
		done
		if [[ $flag -eq 0 ]]
		then
			break
		fi
	done
}
 
# function to play with computer
function computer(){
	moveCount=0;
	while [[ $moveCount -le $TOTAL_COUNT ]]
	do
		if [[ $currentPlayer == x ]]
		then
			read -p "Enter position between 1-9 : " position
			#calculate row and column
			row=$(((($position-1)/$ROW)+1))
			column=$( calColumn $position )
			placeMark $row $column
		else
			player="x";
			playWinAndBlockUser $currentPlayer
			playWinAndBlockUser $player
			availableCornersCentreSide $currentPlayer
			changePlayer $currentPlayer
		fi
	done
}
#function for other player
function otherPlayer(){
	moveCount=0;
	while [[ $moveCount -le $TOTAL_COUNT ]]
	do
		if [[ $currentPlayer == x ]]
		then
			read -p "Enter position between 1-9 : " position
			#calculate row and column
			row=$(((($position-1)/$ROW)+1))
			column=$( calColumn $position )
			placeMark $row $column
		else
			read -p "Enter position b/w 1-9 : " position
			row=$(((($position-1)/$ROW)+1))
			column=$( calColumn $position )
			placeMark $row $column
		fi
	done
}
#start execution
resetBoard
read -p "Enter choice : 1.Computer 2.otherPlayer" inputForPlayer
case $inputForPlayer in
	1)
		computer
		;;
	2)
		otherPlayer
		;;
esac
if [[ $gameStatus -eq 0 ]]
then
	echo "Match tie !!! "
fi
