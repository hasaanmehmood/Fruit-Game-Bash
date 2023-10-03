Project Video#!/bin/bash

#color
green=$(tput setaf 2)
yellow=$(tput setaf 3)
cyan=$(tput setaf 6)
bold=$(tput bold)
reset=$(tput sgr0)
soOn=$(tput smso)
soOff=$(tput rmso)
bell=$(tput bel)
                                                           #splash screen
splash="
███████╗██████╗░██╗░░░██╗██╗████████╗  ░██████╗░░█████╗░███╗░░░███╗███████╗
██╔════╝██╔══██╗██║░░░██║██║╚══██╔══╝  ██╔════╝░██╔══██╗████╗░████║██╔════╝
█████╗░░██████╔╝██║░░░██║██║░░░██║░░░  ██║░░██╗░███████║██╔████╔██║█████╗░░
██╔══╝░░██╔══██╗██║░░░██║██║░░░██║░░░  ██║░░╚██╗██╔══██║██║╚██╔╝██║██╔══╝░░
██║░░░░░██║░░██║╚██████╔╝██║░░░██║░░░  ╚██████╔╝██║░░██║██║░╚═╝░██║███████╗
╚═╝░░░░░╚═╝░░╚═╝░╚═════╝░╚═╝░░░╚═╝░░░  ░╚═════╝░╚═╝░░╚═╝╚═╝░░░░░╚═╝╚══════╝"
clear
nohup mplayer  g1.wav > /dev/null 2>&1 &
printf "\n\n\n\n\n\n   $splash"
sleep 0.5
clear
printf "\n\n\n\n\n\n   ${yellow} $splash"
sleep 0.5
clear
printf "\n\n\n\n\n\n   ${green} $splash"
sleep 0.5
clear
printf "\n\n\n\n\n\n   ${reset} $splash"
sleep 3
                                                           #-End splash screen
                                                           #variable declaration
declare -A matrix
rows=25
columns=20
#💣🦀🥔🥟🍏
permanentFruit=("💣." "🍎." "🍏." "🍇." "🥭." "💣.")
currentFruit=("f1." "f2." "f3.")
basket="🧺."
basketJ=$(( $RANDOM%$columns+1 ))
fruitI=(1 1 1)
fruitJ=(0 0 0)
currentScore=0
arrowl='\[D'
arrowr='\[C'
level=1
highscore="$(cat hscore.txt)"
player="guest"
speed=0.4
speedChangeChecker=0
currentTime=0
                                                         #credit
credit()
{
clear
echo "𝘊𝘙𝘌𝘋𝘐𝘛𝘚:"
echo
echo "𝘔𝘜𝘏𝘈𝘔𝘔𝘈𝘋 𝘚𝘈𝘈𝘋          19𝘍0220"
echo "𝘏𝘈𝘍𝘐𝘡 𝘐𝘛𝘚𝘈𝘔 𝘚𝘏𝘈𝘍𝘘𝘈𝘛   19𝘍0335"
echo "𝘏𝘈𝘚𝘈𝘈𝘕 𝘔𝘌𝘏𝘔𝘖𝘖𝘋         19𝘍0249 (𝘛𝘌𝘈𝘔 𝘓𝘌𝘈𝘋)"
sleep 3
echo
}
                                                         #-End credit
                                                         #start board set
boardSet()
{
for ((i=1;i<=rows;i++)) do
    for ((j=1;j<=columns;j++)) do
        matrix[$i,$j]="..."
    done
	done
fruitSet
read -s -t 0.0001 -n3 key
echo -n "$key" | grep "$arrowl"

if [ $? -eq 0 -a $basketJ -gt 1 ]
then
#echo left
(( basketJ-- ))
fi
echo -n "$key" | grep "$arrowr"
if [ $? -eq 0 -a $basketJ -lt 20 ]
then
#echo right
(( basketJ++ ))
fi
case $key in
     $'\e')
     killall -9 mplayer
                                                          #high score
     echo "$player $currentScore" >> score.txt
     if [ $currentScore -gt $highscore ]
     then
        highscore=$currentScore
        echo $highscore > hscore.txt
     fi
     menu;;
 esac

matrix[$rows,$basketJ]=$basket
                                                     #score incremention
for((i=0;i<level;i++))
do
if [ "$basketJ" -eq "${fruitJ[i]}" -a "${fruitI[i]}" -eq $rows ]
then
echo "${bell}"
if [[ "${currentFruit[i]}" != "${permanentFruit[0]}" ]]
then
(( currentScore++ ))
elif [[ "${currentFruit[i]}" = "${permanentFruit[0]}" ]]
then
(( currentScore-- ))
fi
fi
done
}
                                                     #end board set
logs()
{
  echo "𝘓𝘖𝘎𝘚:-"
  echo
  cat score.txt
  echo
  echo
  echo "𝘌𝘯𝘵𝘦𝘳 𝘵𝘰 𝘨𝘰 𝘣𝘢𝘤𝘬 𝘵𝘰 𝘔𝘢𝘪𝘯 𝘔𝘦𝘯𝘶"
  read k
  case $k in
       $'\e') menu;;
   esac
}
                                                    #fruitset
fruitSet()
{
                                 #setting level according to score(level changer
if [ "$currentScore" -gt 3 -a "$currentScore" -lt 7 ]
then
level=2
elif [[ "$currentScore" -gt 10 ]]
then
level=3
fi


(( fruitI[0]++ ))
                                                 #first fruit
if [ "${fruitI[0]}" -gt $rows -o "${fruitJ[0]}" -eq 0 ]
then
rotenORfresh 0
fruitI[0]=1
fruitJ[0]=$(( $RANDOM%$columns+1 ))
fi
                                                #for other fruits
for((i=1;i<level;i++))
do
(( fruitI[i]++ ))
if [[ "${fruitI[$(( i-1 ))]}" -eq 9 ]]  #new fruit comes when previous fruit is on 9th row
then
if [ "${fruitI[i]}" -gt $rows -o ${fruitJ[i]} -eq 0 ]
then
rotenORfresh "$i"
fruitI[i]=1
fruitJ[i]=$(( $RANDOM%$columns+1 ))
fi
fi
done
for((i=0;i<level;i++))
do
matrix[${fruitI[i]},${fruitJ[i]}]=${currentFruit[i]}
done
}
                                                  #fruitSet
                                                  #rotenORfresh
rotenORfresh()
{
#this funtion decides wheather to set rotten or fresh fruits
#it takes fruits romdomly from permanent fruits array and put them in to currnetfruits array
x=$(( $RANDOM%6 ))
#index=$1
currentFruit[$1]=${permanentFruit[x]}
}
#rotenORfresh

Play()
{

#name input


while [ true ]
do
echo  "                 ${bold}         $(tput setab 7)${soOn}${yellow}𝘞𝘦𝘭𝘤𝘰𝘮𝘦${cyan} 𝘵𝘰 ${green}𝘍𝘳𝘶𝘪𝘵 𝘉𝘢𝘴𝘬𝘦𝘵${reset}${soOff}🧺"
echo
echo "Do you want to Enter your name:"
c="𝘠𝘌𝘚 𝘕𝘖"
select option in $c;
do
if [ "$REPLY" -eq 1 -o "$REPLY" -eq 2 ]
then
break
fi
done
if [[ "$REPLY" -eq 1 ]]
then
  echo "Enter Name:"
  IFS= read -r player
  break;

elif [[ "$REPLY" -eq 2 ]]
then
  break;
fi
done

clear
boardSet                             #function call
currentTime=$(date '+%s')
finishTime=$(( $currentTime+150 ))  #change gameover time
while [ 1 ]
do
clear
#time calculation
currentTime=$(date '+%s')
remainingTime=$(( $finishTime-$currentTime ))
minutes=$(( $remainingTime/60 ))
seconds=$(( $remainingTime%60 ))
#speed changer
if [ $seconds -eq 0 -a $speedChangeChecker -eq 0 ]
then
speed=$(echo  $speed-0.05 | bc)
speedChangeChecker=1
elif [ $seconds -ne 0 -a $speedChangeChecker -eq 1 ]
then
speedChangeChecker=0
fi
#if time finish the game will over and wait of 5 seconds and go to menu
if [ $minutes -eq 0 -a $seconds -eq 0 ]
then
#change requiredd
echo "
████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████
█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░█░░░░░░██████████░░░░░░█░░░░░░░░░░░░░░████░░░░░░░░░░░░░░█░░░░░░██░░░░░░█░░░░░░░░░░░░░░█░░░░░░░░░░░░░░░░███
█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░░░░░░░░░░░░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░████░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀▄▀░░███
█░░▄▀░░░░░░░░░░█░░▄▀░░░░░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░░░░░░░░░████░░▄▀░░░░░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░░░░░█░░▄▀░░░░░░░░▄▀░░███
█░░▄▀░░█████████░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░▄▀░░░░░░▄▀░░█░░▄▀░░████████████░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░█████████░░▄▀░░████░░▄▀░░███
█░░▄▀░░█████████░░▄▀░░░░░░▄▀░░█░░▄▀░░██░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░░░░░████░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░░░░░█░░▄▀░░░░░░░░▄▀░░███
█░░▄▀░░██░░░░░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░██░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░████░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀▄▀▄▀▄▀▄▀▄▀░░███
█░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░▄▀░░█░░▄▀░░██░░░░░░██░░▄▀░░█░░▄▀░░░░░░░░░░████░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░░░░░░░░░█░░▄▀░░░░░░▄▀░░░░███
█░░▄▀░░██░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░██████████░░▄▀░░█░░▄▀░░████████████░░▄▀░░██░░▄▀░░█░░▄▀▄▀░░▄▀▄▀░░█░░▄▀░░█████████░░▄▀░░██░░▄▀░░█████
█░░▄▀░░░░░░▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░██████████░░▄▀░░█░░▄▀░░░░░░░░░░████░░▄▀░░░░░░▄▀░░█░░░░▄▀▄▀▄▀░░░░█░░▄▀░░░░░░░░░░█░░▄▀░░██░░▄▀░░░░░░█
█░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░██░░▄▀░░█░░▄▀░░██████████░░▄▀░░█░░▄▀▄▀▄▀▄▀▄▀░░████░░▄▀▄▀▄▀▄▀▄▀░░███░░░░▄▀░░░░███░░▄▀▄▀▄▀▄▀▄▀░░█░░▄▀░░██░░▄▀▄▀▄▀░░█
█░░░░░░░░░░░░░░█░░░░░░██░░░░░░█░░░░░░██████████░░░░░░█░░░░░░░░░░░░░░████░░░░░░░░░░░░░░█████░░░░░░█████░░░░░░░░░░░░░░█░░░░░░██░░░░░░░░░░█
████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████████"
echo "
█▄█ █▀█ █░█ █▀█   █▀ █▀▀ █▀█ █▀█ █▀▀ ▀ ▄▄
░█░ █▄█ █▄█ █▀▄   ▄█ █▄▄ █▄█ █▀▄ ██▄ ▄ ░░ $currentScore"
killall -9 mplayer
                                                      #high score
     echo "$player $currentScore" >> score.txt
     if [ $currentScore -gt $highscore ]
     then
        highscore=$currentScore
        echo $highscore > hscore.txt
     fi

sleep 5
menu
fi
echo "Collect: 🍎 🍏 🍇 🥭 Avoid: 💣      Time  $minutes:$seconds   delay=$speed "
echo


                                     #print board


for ((i=1;i<=rows;i++)) do
for ((j=1;j<=columns;j++)) do
       echo -n  "${matrix[$i,$j]}"" "
done
echo
done
echo
echo  "
█▀ █▀▀ █▀█ █▀█ █▀▀   ▀ ▄▄
▄█ █▄▄ █▄█ █▀▄ ██▄   ▄ ░░    ${bold}${soOn}$currentScore${soOff}${reset}"
echo  "
█░░ █▀▀ █░█ █▀▀ █░░   ▀ ▄▄
█▄▄ ██▄ ▀▄▀ ██▄ █▄▄   ▄ ░░   ${soOn}${bold}$level${soOff}${reset}"
echo "
█░█ █ █▀▀ █░█ █▀ █▀▀ █▀█ █▀█ █▀▀ ▀ ▄▄
█▀█ █ █▄█ █▀█ ▄█ █▄▄ █▄█ █▀▄ ██▄ ▄ ░░ ${soOn}${bold}$highscore${soOff}${reset}"
echo "
█▀▀ █░█ █▀█ █▀█ █▀▀ █▄░█ ▀█▀   █▀█ █░░ ▄▀█ █▄█ █▀▀ █▀█ ▀ ▄▄
█▄▄ █▄█ █▀▄ █▀▄ ██▄ █░▀█ ░█░   █▀▀ █▄▄ █▀█ ░█░ ██▄ █▀▄ ▄ ░░ ${bold}$player"

boardSet
echo
if [[ $currentScore -gt $highscore ]]
then
  echo "
█░█ █ █▀▀ █░█ █▀ █▀▀ █▀█ █▀█ █▀▀   ▄▀█ █▀▀ █░█ █▀▀ █ █░█ █▀▀ █▀▄ █
█▀█ █ █▄█ █▀█ ▄█ █▄▄ █▄█ █▀▄ ██▄   █▀█ █▄▄ █▀█ ██▄ █ ▀▄▀ ██▄ █▄▀ ▄"
score=$currentScore
fi
if [[ $currentScore -gt $score ]]
then
score=$currentScore
fi
sleep $speed

done
}
                                   #play end

                         #funtion to reset everything
reset()
{
basketJ=$(( $RANDOM%$columns+1 ))
fruitI=(1 1 1)
fruitJ=(0 0 0)
currentScore=0
level=1
highscore="$(cat hscore.txt)"
player="guest"
speed=0.4
speedChangeChecker=0
currentTime=0
}
                          #end reset

                         #Main Menu                                           #

menu()
{
reset
killall -9 mplayer
while [ true ]
do
clear
echo  "                 ${bold}         $(tput setab 7)${soOn}${yellow}𝘞𝘦𝘭𝘤𝘰𝘮𝘦${cyan} 𝘵𝘰 ${green}𝘍𝘳𝘶𝘪𝘵 𝘉𝘢𝘴𝘬𝘦𝘵${reset}${soOff}🧺"
echo
echo "𝘗𝘓𝘌𝘈𝘚𝘌 𝘊𝘏𝘖𝘖𝘚𝘌 𝘠𝘖𝘜𝘙 𝘖𝘗𝘛𝘐𝘖𝘕:"
echo
Choices="𝘗𝘓𝘈𝘠 𝘊𝘙𝘌𝘋𝘐𝘛𝘚 𝘓𝘖𝘎𝘚 𝘌𝘟𝘐𝘛"
select option in $Choices;
do
if [ "$REPLY" -eq 1 -o "$REPLY" -eq 2 -o "$REPLY" -eq 3 -o "$REPLY" -eq 4 ]
then
break
fi
done
clear
echo "𝘚𝘌𝘓𝘌𝘊𝘛𝘌𝘋 𝘖𝘗𝘛𝘐𝘖𝘕: $REPLY"
echo "𝘛𝘏𝘌 𝘚𝘌𝘓𝘌𝘊𝘛𝘌𝘋 𝘖𝘗𝘛𝘐𝘖𝘕 𝘐𝘚: $option"
sleep 1
if [[ "$REPLY" -eq 1 ]]
then
echo "${bell}"
nohup mplayer -quiet -loop 0  rise.mp3 > /dev/null 2>&1 &
clear
Play
elif [[ "$REPLY" -eq 2 ]]
then
echo "${bell}"
credit
elif [[ "$REPLY" -eq 3 ]]
then
clear
logs
elif [[ "$REPLY" -eq 4 ]]
then
echo "${bell}"
clear
echo "Saving.."
#echo $highscore >> hscore.txt
sleep 0.5
clear
echo "Exiting.."
sleep 0.15
echo
echo "Exited."
echo
exit
fi
done
}
                                                           #End Menu
menu    #menu call

