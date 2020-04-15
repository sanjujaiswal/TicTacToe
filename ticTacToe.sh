#!/bin/bash -x
echo "-----Welcome to Tic-Tac-Toe Game-----"

#Constants declarations
NUMBER=2
TOTAL_COUNT=9
ROW=3
COLUMN=3

#Variables declarations
tossPlayer=0
moveCount=1
computerPlayer="0";
flag=1
#Array declaration
declare -a board

#Toss to play first
function tossToPlayFirst(){
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
	currentPlayer=$( tossToPlayFirst );
	gameStatus=0;
	initialize
}

#Initialize to board
function initialize(){
	echo "Enter position on Board :"
   for (( rowPosition=1;rowPosition<=$ROW;rowPosition++ ))
   do
      echo "---------"
      for (( columnPosition=1;columnPosition<=$COLUMN;columnPosition++ ))
      do
         board[$rowPosition,$columnPosition]="-"
      done
   done
		displayBoard
}

#Function to display board
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
}

#Function to place mark on board
function placeMark(){
	if [[ ${board[$1,$2]} == - ]]
	then
		board[$1,$2]=$currentPlayer
		displayBoard
		checkWin $currentPlayer

		if [[ $gameStatus -eq 1 ]]
		then
			echo "$currentPlayer wins!!"
			exit

		fi
			changePlayer $currentPlayer
			((moveCount++))

		else
			echo "Position already occupied"
		fi
}

#calculate column's position
function calColumn(){
	if [[ $1%$COLUMN -eq 0 ]]
	then
		column=$COLUMN;
	else
		column=$(($1%$COLUMN))
	fi
	echo $column
}

#If no corners are avilable then select centre
function availableCentre(){
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

#Take available corners if no player is  winning
function availableCorners(){
	if [[ $flag -eq 1 ]]
	then
		for (( row=1;row<=$ROW;$((row+=2)) ))
		do
			for (( column=1;column<=$COLUMN;$((column+=2)) ))
			do
				if [[ ${board[$row,$column]} == "-" ]]
				then
					board[$row,$column]=$currentPlayer
					displayBoard
					gameStatus=0;
					((moveCount++))
					flag=0;
				fi
			done
			if [[ $flag -eq 0 ]]
			then
				break;
			fi
		done
	fi
}

#Block user if HUMAN/COMPUTER is winning
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
					echo "$currentPlayer wins !!!"
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

#Execution start from here
resetBoard
while [[ $moveCount -le $TOTALCOUNT ]]
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
		availableCorners $currentPlayer
		row=$(($ROW/2+1))
		column=$(($COLUMN/2+1))
		availableCentre $currentPlayer $row $column
		if [ $flag -eq 1 ]
		then
			row=$(((RANDOM%3)+1))
			column=$(((RANDOM%3)+1))
			placeMark $row $column
		else
			changePlayer $currentPlayer
		fi
	fi
done
if [[ $gameStatus -eq 0 ]]
then
	echo "Match will tie !!! "
fi
