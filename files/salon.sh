#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

DEL_DATA=${1: false}
if [ $DEL_DATA ]
then
  CLEAR_DATA=$($PSQL "TRUNCATE TABLE customers, appointments;")
  echo $CLEAR_DATA
fi

# Intro
echo -e "Welcome!\n~~~~~ MY SUPER SALON ~~~~~\n"

# Menu of services
SERVICES_MENU (){
  if [[ -n $1 ]]
  then 
    echo -e "$1\n"
  fi

  # Instructions 
  echo -e "Select a service by entering the service #\n"

  # query all avail services
  SERVICES_RESULT=$($PSQL "SELECT service_id, name, description FROM services;")

  #  format #) <service>
  echo "$SERVICES_RESULT" | while read ID NAME DESC
  do
    echo -e "$ID $NAME $DESC\n" | tr -d "\|" | sed -E "s/ {1}/\)/"
  done

  read SERVICE_ID_SELECTED
  # next step, query the services DB to dynamically define the range of service IDs
  i=$($PSQL "SELECT MAX(service_id) FROM services;" | tr -d " ")
  services="[1-${i}]"
  case $SERVICE_ID_SELECTED in
    $services) SCHEDULE_SERVICES $SERVICE_ID_SELECTED ;;
    *) SERVICES_MENU "Please enter a valid option. Your selection '$SERVICE_ID_SELECTED' is not valid." ;;
  esac
}

SCHEDULE_SERVICES(){

  SERVICE_ID_SELECTED=$1
  SERVICE=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED;")
  echo -e "Selected Service ID: $SERVICE_ID_SELECTED for a $SERVICE."
  CURRENT_CUSTOMERS=$($PSQL "SELECT * FROM customers;")
  
  echo -e "please enter your phone number:"
  read CUSTOMER_PHONE
  
  # Query customer name
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone = '$CUSTOMER_PHONE';")

  # Add name and phone if new client
  # SERVICE_ID_SELECTED, CUSTOMER_PHONE, CUSTOMER_NAME, and SERVICE_TIME
  if [[ -z $CUSTOMER_NAME ]]
  then
      echo -e "please enter your name:"
      read CUSTOMER_NAME
      ADD_CUSTOMER_NAME=$($PSQL "INSERT INTO customers(phone,name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  # query customer ID 
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone = '$CUSTOMER_PHONE';")

  # Add appointment for client
  echo -e "\nplease enter a time for your appointment:"
  read SERVICE_TIME
  ADD_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id,service_id,time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  # final confirmation
  echo -e "\nI have put you down for a $SERVICE at $SERVICE_TIME, $CUSTOMER_NAME."
}

SERVICES_MENU
