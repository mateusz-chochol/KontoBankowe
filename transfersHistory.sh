#!/bin/bash

source $(dirname $0)/usefulFunctions.sh

#Takes as an arguments in that order: transfer type, date, bank account number, amount, recipients name, recipients surname
function cAddTransferToHistory
{
    local historyFileState=$(cCheckIfFileExists transfersHistory.txt)
    if [ $historyFileState == 0 ]; then touch $(dirname $0)/transfersHistory.txt; fi

    local index=1
    while read -r line 
    do
        let index++
    done < "$(dirname $0)/transfersHistory.txt"

    printf "%s" $1 "-transfer-" $index" " >> $(dirname $0)/transfersHistory.txt
    printf "%s" "$2 " >> $(dirname $0)/transfersHistory.txt
    printf "%s" "$3 " >> $(dirname $0)/transfersHistory.txt
    printf "%s" "$4 " >> $(dirname $0)/transfersHistory.txt
    printf "%s" "$5 " >> $(dirname $0)/transfersHistory.txt
    printf "%s" "$6 " >> $(dirname $0)/transfersHistory.txt
    echo "" >> $(dirname $0)/transfersHistory.txt
}

function cGetTransfersHistory
{
    clear
    local historyFileState=$(cCheckIfFileExists transfersHistory.txt)
    if [ $historyFileState == 0 ]; then touch $(dirname $0)/transfersHistory.txt; fi

    local -a transfers=()
    local index=0

    while read -r line 
    do
        transfers[$index]="$line"
        let index++
    done < "$(dirname $0)/transfersHistory.txt"

    if [ $index == 0 ]; then echo "You do not have any transfers in the transfers history yet."; return; fi

    local -a ordinaryTransfers=()
    local -a expressTransfers=()
    local -a currencyTransfers=()
    local ordinaryTransferFormat='^Ordinary-transfer-([0-9]+)$'
    local expressTransferFormat='^Express-transfer-([0-9]+)$'
    local currencyTransferFormat='^Currency-transfer-([0-9]+)$'

    for (( i=0; i<$index; i++ ))
    do
        local transfer=(${transfers[$i]})

        if [[ "${transfer[0]}" =~ $ordinaryTransferFormat ]];
        then
            ordinaryTransfers+=("${transfers[$i]}")
        elif [[ "${transfer[0]}" =~ $expressTransferFormat ]];
        then
            expressTransfers+=("${transfers[$i]}")
        elif [[ "${transfer[0]}" =~ $currencyTransferFormat ]];
        then
            currencyTransfers+=("${transfers[$i]}")
        else
            echo "ERROR. Currupted data in transferHistory.txt file."
            sleep 3
            exit 1
        fi
    done

    if [ ${#ordinaryTransfers[@]} -gt 0 ]
    then
        echo "Ordinary transfers: "
        echo ""
        cPrintTransfersData "${ordinaryTransfers[@]}"
    fi

    if [ ${#expressTransfers[@]} -gt 0 ]
    then
        echo "Express transfers: "
        echo ""
        cPrintTransfersData "${expressTransfers[@]}"
    fi

    if [ ${#currencyTransfers[@]} -gt 0 ]
    then
        echo "Currency transfers: "
        echo ""
        cPrintTransfersData "${currencyTransfers[@]}"
    fi
}

function cPrintTransfersData
{
    local -a transfers=("$@")

    for (( i=0; i<${#transfers[@]}; i++ ))
    do
        local transfer=(${transfers[$i]})
        
        echo "Transfer" $(($i+1))":"
        echo "Date:" ${transfer[1]}
        echo "Bank account number:" ${transfer[2]}
        echo "Amount:" ${transfer[3]}
        echo "Name:" ${transfer[4]}
        echo "Surname:" ${transfer[5]}
        echo ""
    done
}

#Takes as an arguments in that order: transfer type, date, bank account number, amount, recipients name, recipients surname
function cSaveTransferSeparately
{
    echo ""
}