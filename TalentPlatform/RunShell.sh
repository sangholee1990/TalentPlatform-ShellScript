#!/bin/bash

#=====================================
# Set Env
#=====================================

#=====================================
# Set Fun
#=====================================

#=====================================
# Set Data
#=====================================

#=====================================
# 주석 단계
#=====================================
# 1 단계 : ====
# 2 단계 : ****
# 3 단계 : ++++

#========================================================
#  Bingo 함수 버전
#========================================================
fnArgsNumberValid() {

   local iNumber=$#

   echo $#

   if [ $iNumber -lt 1 ]; then
      echo "Lower than"

      return 0
   fi

   if [ $iNumber -gt 1 ]; then
      echo "Higher than"

      return 0
   fi

   echo "Bingo!"

   return 1
}

# fnArgsNumberValid
# fnArgsNumberValid 1
# fnArgsNumberValid 1 2 

#==========================================================
#  재귀적 destroy 이용
#==========================================================
destroy1() {
   if [ -d $1 ]; then
      local list=$(ls $1/*)

      for file in $list
      do
         ((num = $num + 1))
   
         # echo $file $num
      done

      echo $num
   fi
}

# num=0
# source=./week10
# 
# destroy1 $source

#==========================================================
#  숫자 야구
#==========================================================
fnBaseBallGame() {

   local argsInputNum=$1

   while : 
   do 
      randomNum=$((RANDOM%2))
   
      if [ $randomNum -eq $argsInputNum ]; then
         echo "Strike"
         iStrikeCount=$(($iStrikeCount + 1))
      else
         echo "Ball"
         iBallCount=$(($iBallCount + 1))
      fi

      # echo $randomNum $argsInputNum $iStrikeCount $iBallCount

      if [ $iStrikeCount -eq 3 ]; then
         echo "Out"
         break
      fi

      if [ $iBallCount -eq 4 ]; then
         echo "Win"
         break
      fi

      read inputNum
      fnBaseBallGame $inputNum
   done

   exit 0
}

# iStrikeCount=0
# iBallCount=0
# read inputNum
# 
# fnBaseBallGame $inputNum

setDir="dir"

fileList=$(find $setDir -type f)

for file in $fileList; do
   
   isText=$(cat $file | grep "Queensland")
   
   if [ ${#isText} -gt 0 ]; then
      echo "[INFO] File Delete" $file
      rm -f $file

      break
   fi
     
   head -n 10 $file
   
   echo 
   echo "[is Delete] y or n"
   
   read isYn
  
   if [ $isYn == "y" ]; then
      echo "[INFO] File Delete" $file
      rm -f $file
   else
      echo "[INFO] File No Delete" $file
   fi
done
