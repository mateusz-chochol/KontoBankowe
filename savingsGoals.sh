#!/bin/bash

source $(dirname $0)/usefulFunctions.sh

function cCheckIfSavingsDirExists
{
    if [ -d "$(dirname $0)/SavingsAccount" ]
    then
        echo 1
    else
        echo 0
    fi
}

function cCheckIfSavingsAccountExists
{
    if [ -f "savingsAccount.txt" ]
    then
        echo 1
    else
        echo 0
    fi
}

function cCreateSavingsAccount
{
    local savingsAccountDirState=$(cCheckIfSavingsDirExists)

    if [ $savingsAccountDirState == 0 ]
    then
        mkdir $(dirname $0)/SavingsAccount
    fi
    
    cd $(dirname $0)/SavingsAccount
    local savingsAccountState=$(cCheckIfSavingsAccountExists)

    if [ $savingsAccountState == 0 ]
    then
        touch savingsAccount.txt
        printf "%s\n" "Balance: 0" >> savingsAccount.txt 
        printf "%s\n" "Monthly: 0" >> savingsAccount.txt
        printf "%s\n" "Goal: 0" >> savingsAccount.txt
    fi
}

function cSetMonthlySavings
{
    clear
    local monthlySavings
    read -p "Set how much money would you like to save per month: " monthlySavings
    local monthlySavingsFormat='^[1-9][0-9]*$'

    if ! [[ "$monthlySavings" =~ $monthlySavingsFormat ]]
    then
        echo "Wrong savings format. Has to be greater than 0 and can contain only digits."
        sleep 2
        cSetMonthlySavings
        return
    fi

    sed -i "s/Monthly: \(.*\)/Monthly: $monthlySavings/" ./savingsAccount.txt
}

function cSetGoal
{
    clear
    local goal
    read -p "Set your saving goal: " goal
    local goalFormat='^[1-9][0-9]*$'

    if ! [[ "$goal" =~ $goalFormat ]]
    then
        echo "Wrong goal format. Has to be greater than 0 and can contain only digits."
        sleep 2
        cSetGoal
        return
    fi

    sed -i "s/Goal: \(.*\)/Goal: $goal/" ./savingsAccount.txt
}

function cDisplaySavingsAccountMenu
{
    clear
    echo "Menu | Savings account"
    echo "1. Set monthly savings."
    echo "2. Make transfer manually."
    echo "3. Set goal."
    echo "4. Display information about your savings account."
    echo "Press desired option number in order to continue "
}

function cMakeTransfer
{
    clear
    local transferAmount
    read -p "Type in how much would like to transfer to your savings account: " transferAmount
    local transferAmountFormat='^[1-9][0-9]*$'

    if ! [[ "$transferAmount" =~ $transferAmountFormat ]]
    then
        echo "Wrong transfer amount format. Transfer has to be greater than 0 (only digits are allowed)."
        sleep 2
        cMakeTransfer
        return
    fi

    local savingsAccountBalance=$(awk '/Balance: /{print $2}' savingsAccount.txt)
    savingsAccountBalance=$(echo $(($savingsAccountBalance+$transferAmount)))
    sed -i "s/Balance: \(.*\)/Balance: $savingsAccountBalance/" savingsAccount.txt
}

function cDisplaySavingsAccountInformation
{
    clear
    while read -r line 
    do
        echo $line
    done < "savingsAccount.txt"

    local monthly=$(awk '/Monthly: /{print $2}' savingsAccount.txt)
    local goal=$(awk '/Goal: /{print $2}' savingsAccount.txt)
    local gatheredMoney=$(awk '/Balance: /{print $2}' savingsAccount.txt)
    local timeToGoal
    let goal-=gatheredMoney

    if [ "$monthly" == 0 ]
    then
        echo "You haven't setup your monthly payment yet."
        sleep 3
        cSavingsAccount
    elif [ "$goal" == 0 ]
    then
        echo "You haven't setup your goal yet."
        sleep 3
        cSavingsAccount
    else
        let timeToGoal=goal/monthly
        echo "It will take you" $timeToGoal "more months to achieve your goal of saving" $goal"."
    fi
}

function cSavingsAccount
{
    clear
    cCreateSavingsAccount

    local option
    cDisplaySavingsAccountMenu
    read -rsn1 option
    local optionFormat='^[1-4]$'

    if ! [[ "$option" =~ $optionFormat ]]
    then
        cSavingsAccount
        return
    fi

    case $option in
        1)
            cSetMonthlySavings
            ;;
        2)
            cMakeTransfer
            ;;
        3)
            cSetGoal
            ;;
        4)
            cDisplaySavingsAccountInformation
            ;;
    esac
}

cSavingsAccount