#!/bin/bash

source $(dirname $0)/usefulFunctions.sh

function cAddRecipient
{
    clear
    local name=$(cGetName)
    if [ "$name" == "-1" ]; then cAddRecipient; return; fi
    local surname=$(cGetSurname)
    if [ "$surname" == "-1" ]; then cAddRecipient; return; fi
    local pesel=$(cGetPesel)
    if [ "$pesel" == "-1" ]; then cAddRecipient; return; fi
    local bankAccountNumber=$(cGetBankAccountNumber)
    if [ "$bankAccountNumber" == "-1" ]; then cAddRecipient; return; fi

    printf "%s" "$name " >> $(dirname $0)/recipients.txt
    printf "%s" "$surname " >> $(dirname $0)/recipients.txt
    printf "%s" "$pesel " >> $(dirname $0)/recipients.txt
    printf "%s" "$bankAccountNumber" >> $(dirname $0)/recipients.txt
    echo "" >> $(dirname $0)/recipients.txt
}

function cDeleteRecipient
{
    clear
    local pesel=$(cGetPesel)
    if [ "$pesel" == "-1" ]; then cDeleteRecipient; return; fi

    sed -i "/ $pesel /d" $(dirname $0)/recipients.txt
}

function cGetRecipients
{
    clear
    local -a recipients=()
    local index=0

    while read -r line 
    do
        recipients[$index]="$line"
        let index++
    done < $(dirname $0)/recipients.txt

    local -a recipientsName=()
    local -a recipientsSurname=()
    local -a recipientsPESEL=()
    local -a recipientsBankAccountNumber=()

    for (( i=0; i<$index; i++ ))
    do
        local recipient=(${recipients[$i]})

        recipientsName[$i]=${recipient[0]}
        recipientsSurname[$i]=${recipient[1]}
        recipientsPESEL[$i]=${recipient[2]}
        recipientsBankAccountNumber[$i]=${recipient[3]}
    done

    for (( i=0; i<$index; i++ ))
    do
        echo "Recipient" $(($i+1))":"
        echo "Name:" ${recipientsName[$i]}
        echo "Surname:" ${recipientsSurname[$i]}
        echo "PESEL:" ${recipientsPESEL[$i]}
        echo "Bank account number:" ${recipientsBankAccountNumber[$i]}
        echo ""
    done
}