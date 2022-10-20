#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# Check if argument provided
if [[ $1 ]]
then
  # if $1 is a number (atomic number)
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number=$1")
    ATOMIC_NUMBER=$(echo $ATOMIC_NUMBER | sed -r 's/^ *| *$//g')
    # if atomic_number doesn't exist
    if [[ -z $ATOMIC_NUMBER ]]
    then
      echo "I could not find that element in the database."
    
    else
    # assign remaining variables (name, symbol, type, mass, melting_point_celsius, boiling_point_celsius)
      NAME=$($PSQL "SELECT name FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE atomic_number=$ATOMIC_NUMBER")
      TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) WHERE atomic_number=$ATOMIC_NUMBER")
      MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE atomic_number=$ATOMIC_NUMBER")
      BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE atomic_number=$ATOMIC_NUMBER")

      # output: The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
      echo -e "The element with atomic number $ATOMIC_NUMBER is $(echo $NAME | sed -r 's/^ *| *$//g') ($(echo $SYMBOL | sed -r 's/^ *| *$//g')). It's a $(echo $TYPE | sed -r 's/^ *| *$//g'), with a mass of $(echo $ATOMIC_MASS | sed -r 's/^ *| *$//g') amu. $(echo $NAME | sed -r 's/^ *| *$//g') has a melting point of $(echo $MELTING_POINT_CELSIUS | sed -r 's/^ *| *$//g') celsius and a boiling point of $(echo $BOILING_POINT_CELSIUS | sed -r 's/^ *| *$//g') celsius."
    fi
  fi

  # if $1 is 1 or 2 characters (symbol)
  if [[ $1 =~ ^[A-Z]([a-z]?)$ ]]
  then
    SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE symbol='$1'")
    SYMBOL=$(echo $SYMBOL | sed -r 's/^ *| *$//g')
    # if symbol doesn't exist
    if [[ -z $SYMBOL ]]
    then
      echo "I could not find that element in the database."
    else
      # assign remaining variable names (atomic_number, name, type, mass, melting_point_celsius, boiling_point_celsius)
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE symbol='$SYMBOL'")
      NAME=$($PSQL "SELECT name FROM elements WHERE symbol='$SYMBOL'")
      TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) INNER JOIN elements USING(atomic_number) WHERE symbol='$SYMBOL'")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol='$SYMBOL'")
      MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol='$SYMBOL'")
      BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE symbol='$SYMBOL'")

      # output: The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
      echo -e "The element with atomic number $(echo $ATOMIC_NUMBER | sed -r 's/^ *| *$//g') is $(echo $NAME | sed -r 's/^ *| *$//g') ($SYMBOL). It's a $(echo $TYPE | sed -r 's/^ *| *$//g'), with a mass of $(echo $ATOMIC_MASS | sed -r 's/^ *| *$//g') amu. $(echo $NAME | sed -r 's/^ *| *$//g') has a melting point of $(echo $MELTING_POINT_CELSIUS | sed -r 's/^ *| *$//g') celsius and a boiling point of $(echo $BOILING_POINT_CELSIUS | sed -r 's/^ *| *$//g') celsius."
    fi
  fi

  # if $1 is longer than 2 characters (name)
  if [[ $1 =~ ^[A-Z][a-z]([a-z]+)$ ]]
  then
    NAME=$($PSQL "SELECT name FROM elements WHERE name='$1'")
    NAME=$(echo $NAME | sed -r 's/^ *| *$//g')
    # if name doesn't exist
    if [[ -z $NAME ]]
    then
      echo "I could not find that element in the database."
    else
      # assign remaining variables (atomic_number, symbol, type, mass, melting_point_celsius, boiling_point_celsius)
      ATOMIC_NUMBER=$($PSQL "SELECT atomic_number FROM elements WHERE name='$NAME'")
      SYMBOL=$($PSQL "SELECT symbol FROM elements WHERE name='$NAME'")
      TYPE=$($PSQL "SELECT type FROM types INNER JOIN properties USING(type_id) INNER JOIN elements USING(atomic_number) WHERE name='$NAME'")
      ATOMIC_MASS=$($PSQL "SELECT atomic_mass FROM properties INNER JOIN elements USING(atomic_number) WHERE name='$NAME'")
      MELTING_POINT_CELSIUS=$($PSQL "SELECT melting_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE name='$NAME'")
      BOILING_POINT_CELSIUS=$($PSQL "SELECT boiling_point_celsius FROM properties INNER JOIN elements USING(atomic_number) WHERE name='$NAME'")

      # output: The element with atomic number 1 is Hydrogen (H). It's a nonmetal, with a mass of 1.008 amu. Hydrogen has a melting point of -259.1 celsius and a boiling point of -252.9 celsius.
      echo -e "The element with atomic number $(echo $ATOMIC_NUMBER | sed -r 's/^ *| *$//g') is $NAME ($(echo $SYMBOL | sed -r 's/^ *| *$//g')). It's a $(echo $TYPE | sed -r 's/^ *| *$//g'), with a mass of $(echo $ATOMIC_MASS | sed -r 's/^ *| *$//g') amu. $NAME has a melting point of $(echo $MELTING_POINT_CELSIUS | sed -r 's/^ *| *$//g') celsius and a boiling point of $(echo $BOILING_POINT_CELSIUS | sed -r 's/^ *| *$//g') celsius."
    fi
  fi

  # if input fits none of the above
  if [[ ! $1 =~ ^[0-9]+$ && ! $1 =~ ^[A-Z]([a-z]?)$ && ! $1 =~ ^[A-Z][a-z]([a-z]+)$ ]]
  then
    echo "I could not find that element in the database."
  fi

else
  # if no argument is provided
  echo "Please provide an element as an argument."

fi 

