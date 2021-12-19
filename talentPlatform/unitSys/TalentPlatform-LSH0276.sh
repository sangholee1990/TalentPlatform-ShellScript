#===============================================================================================
# Routine : Main Bash Shell
#
# Purpose : 재능상품 오투잡
#
# Author : 해솔
#
# Revisions: V1.0 May 28, 2020 First release (MS. 해솔)
#===============================================================================================

#!/bin/bash

#=====================================
# Set Env
#=====================================
# Stack Size resized unlimited
ulimit -s unlimited

#=====================================
# Set Fun
#=====================================
videoCheck() {

    local isCheckFlag="$1"
    local metaData="$2"

    videoCnt=$(expr ${#videoList[@]} - 1)
    for idxInfo in $(seq 0 $videoCnt); do
        cnt=$(expr $idxInfo + 1)
        videoInfo="${videoList[idxInfo]}"
        isFlag="FALSE"

        while IFS="," read -r name phoneNumber video rentDate; do
            nameInfo=$name
            phoneNumberInfo=$phoneNumber

            if [ ${#name} -lt 1 ]; then continue; fi
            if [ ${#phoneNumber} -lt 1 ]; then continue; fi
            if [ ${#video} -lt 1 ]; then continue; fi
            if [ ${#rentDate} -lt 1 ]; then continue; fi
            if [ "${inpName}" != "${name}" ]; then continue; fi

            if [ "${videoInfo}" == "${video}" ]; then
                isFlag="TRUE"
                break
            fi
        done < "$metaData"

        if [ "${isFlag}" == "${isCheckFlag}" ]; then
            printf "  %s %s %s\n" "${cnt}."  "${videoInfo}" "${rentDate}"
        fi

        cnt=$(expr $cnt + 1)
    done
}

#=====================================
# Set Data
#=====================================

# Gildong Hong

#*********************
# 주석 단계
#*********************
# 1 단계 : ====
# 2 단계 : ****
# 3 단계 : ++++

#=====================================
# Main
#=====================================
echo "[START] Main Shell : $0"

contextPath=$(pwd)
videoList=("Amadeus" "Back to the Future" "Batman Returns" "Candy Candy" "Ghost Busters" "Star Wars" "Time Machine" "Avengers Forever" "Superman Returns" )

echo "[VMS]"

while :; do
    echo
    echo "[Please Select]"
    echo "  1. Create Account"
    echo "  2. Query Account"
    echo "  3. Rent Video"
    echo "  4. Return Video"
    echo "  0. Quit"
    echo

    read -p "명령어를 입력해주세요 : " cmd

    case $cmd in
        1)
            echo "[1] Create Account"
            echo "Enter Customer Info:"

            read -p "   Name: " nameInfo
            read -p "   Phone Number: " phoneNumberInfo

            metaData="${contextPath}/Meta_Data_${nameInfo}.db"

            fileInfo=$(find "$metaData" 2>/dev/null)
            if [ ${#fileInfo} -gt 0 ]; then
                echo "[ERROR] 이미 등록된 고객 (Name, Phone Number)입니다."
                continue
            fi

            echo "$nameInfo,$phoneNumberInfo" > "$fileInfo"
            ;;

        2)
            echo "[2] Query Account"
            read -p "Enter Name: " inpName

            metaData="${contextPath}/Meta_Data_${inpName}.db"

            fileInfo=$(find "$metaData" 2>/dev/null)
            if [ ${#fileInfo} -lt 1 ]; then
                echo "[ERROR] 고객 정보를 등록해주세요."
                continue
            fi

            echo "  Videos Rented"
            echo "  ========================================================"
            videoCheck "TRUE" "$fileInfo"
            echo "  ========================================================"
            ;;

        3)
            echo "[3] Rent Video"
            read -p "Enter Name: " inpName

            metaData="${contextPath}/Meta_Data_${inpName}.db"

            fileInfo=$(find "$metaData" 2>/dev/null)
            if [ ${#fileInfo} -lt 1 ]; then
                echo "[ERROR] 고객 정보를 등록해주세요."
                continue
            fi

            echo "  Videos Available"
            echo "  ========================================================"
            videoCheck "FALSE" "$fileInfo"
            echo "  ========================================================"

            read -p "Please Select Number: " videoIdx
            idx=$(expr $videoIdx - 1)

            echo "$nameInfo,$phoneNumberInfo,${videoList[idx]},$(date +'%m/%d')"  >> "$fileInfo"
            echo "Amadeus is rented now."
            ;;

        4)
            echo "[4] Return Video"
            read -p "Enter Name: " inpName

            metaData="${contextPath}/Meta_Data_${inpName}.db"

            fileInfo=$(find "$metaData" 2>/dev/null)
            if [ ${#fileInfo} -lt 1 ]; then
                echo "[ERROR] 고객 정보를 등록해주세요."
                continue
            fi

            echo "  Videos Rented"
            echo "  ========================================================"
            videoCheck "TRUE" "$fileInfo"
            echo "  ========================================================"

            read -p "Please Select Number: " videoIdx
            idx=$(expr $videoIdx - 1)

            cat "${fileInfo}" | egrep -v "$nameInfo,$phoneNumberInfo,${videoList[idx]}" > "${fileInfo}.tmp"
            mv -f "${fileInfo}.tmp"  "${fileInfo}"

            echo "Amadeus Forever is returned"
            ;;

        0)
            echo "[SUCC] 정상 종료"
            exit 0
            ;;

        *)
            echo "[ERROR] 비정상 종료"
            exit 1
            ;;

    esac

done


echo "[END] Main Shell : $0"


