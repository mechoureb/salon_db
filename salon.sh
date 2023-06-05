#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"

MAIN_MENU() {
if [[ $1 ]]
then 
  echo -e "\n$1"
else 
  echo -e "\nWelcome to My Salon, how can I help you?\n"
fi
SERVICES=$($PSQL "SELECT service_id, name FROM services ORDER BY service_id")
echo "$SERVICES" | while IFS="|" read service_id NAME 
do 
  echo "$service_id) $NAME"
done
read SERVICE_ID_SELECTED
SERVICE=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $SERVICE ]]
then 
  MAIN_MENU "I could not find that service. What would you like today?"
else 
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  C_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $C_NAME ]]
  then 
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    INSERT_C=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE','$CUSTOMER_NAME')");
  fi
    C_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    CUSTOMER_ID=$($PSQL "SELECT customer_id from customers WHERE phone='$CUSTOMER_PHONE'")
    echo -e "\nWhat time would you like your $SERVICE, $C_NAME?"
    read SERVICE_TIME
    INSERT_A=$($PSQL "INSERT INTO appointments(time, customer_id, service_id) VALUES('$SERVICE_TIME',$CUSTOMER_ID,$SERVICE_ID_SELECTED)")
    echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $C_NAME."
  
fi


}

MAIN_MENU
