#! /bin/bash

PSQL="psql -X --username=freecodecamp --tuples-only --dbname=salon -c"

echo -e "\n~~~~~ Salon ~~~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "\nServices list:"

  # show list of services
  SERVICES_LIST=$($PSQL "SELECT service_id, name FROM services")
  echo "$SERVICES_LIST" | while read SERVICE_ID BAR SERVICE_NAME
  do
    echo -e "$SERVICE_ID) $SERVICE_NAME"
  done
  echo -e "\nWhich service would you like to choose?"
  read SERVICE_ID_SELECTED

  # if service picked doesn't exist
  if [[ ! $SERVICE_ID_SELECTED =~ ^[0-5]+$ ]]
  then
    MAIN_MENU "Please enter a valid option."
  else
    MAKE_APPOINTMENT $SERVICE_ID_SELECTED
  fi
}

MAKE_APPOINTMENT() {
  SERVICE_ID_SELECTED=$1

  echo -e "\nYou have selected Service #$SERVICE_ID_SELECTED!"

  # get customer phone number
  echo -e "\nWhat is your phone number?"
  read CUSTOMER_PHONE
  
  # get customer name from database
  CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

  # if customer doesn't exist
  if [[ -z $CUSTOMER_NAME ]]
  then
    # get new customer name
    echo -e "\nWhat's your name?"
    read CUSTOMER_NAME

    # insert into database
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")
  fi

  # get appointment time
  echo -e "\nWhat time would you like to make an appointment?"
  read SERVICE_TIME

  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  SERVICE_NAME_SELECTED=$($PSQL "SELECT name FROM services WHERE service_id = $SERVICE_ID_SELECTED")

  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")

  echo -e "\nI have put you down for a $(echo $SERVICE_NAME_SELECTED | sed -r 's/^ *| *$//g') at $SERVICE_TIME, $(echo $CUSTOMER_NAME | sed -r 's/^ *| *$//g')."

}


MAIN_MENU