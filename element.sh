#! /bin/bash

declare PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

function isValidInput() {
  local input="$1"

  if [[ "$input" =~ ^[0-9]+$ ]]; then
    local query="""
      SELECT
        COUNT(*)
      FROM
        elements
      WHERE
        atomic_number = '$input';
    """
  else
    local query="""
      SELECT
        COUNT(*)
      FROM
        elements
      WHERE
        symbol = '$input' OR
        name = '$input';
    """
  fi

  local count="$($PSQL "$query")"
  
  if [ "$count" != "0" ]; then
    return
  else
    echo "I could not find that element in the database."
    exit
  fi
}

function getElementData() {
  local input="$1"

  # valida se input é um número ou uma string
   if [[ "$input" =~ ^[0-9]+$ ]]; then
    local query="""
      SELECT
        elements.atomic_number,
        elements.name,
        elements.symbol,
        types.type, 
        properties.atomic_mass,
        properties.melting_point_celsius,
        properties.boiling_point_celsius
      FROM
        elements
      INNER JOIN
        properties
      ON
        elements.atomic_number = properties.atomic_number
      INNER JOIN
        types
      ON
        properties.type_id = types.type_id
      WHERE
        elements.atomic_number = '$input';
    """
  else
    local query="""
      SELECT
        elements.atomic_number,
        elements.name,
        elements.symbol,
        types.type, 
        properties.atomic_mass,
        properties.melting_point_celsius,
        properties.boiling_point_celsius
      FROM
        elements
      INNER JOIN
        properties
      ON
        elements.atomic_number = properties.atomic_number
      INNER JOIN
        types
      ON
        properties.type_id = types.type_id
      WHERE
        elements.symbol = '$input' OR
        elements.name = '$input';
    """
  fi

  local data="$($PSQL "$query")"
  IFS='|' read -r -a arr <<< "$data"

  echo "The element with atomic number ${arr[0]} is ${arr[1]} (${arr[2]}). It's a ${arr[3]}, with a mass of ${arr[4]} amu. ${arr[1]} has a melting point of ${arr[5]} celsius and a boiling point of ${arr[6]} celsius."
}

function main() {
  local input="$1"
  
  if [ -z "$input" ]; then
    echo "Please provide an element as an argument."
  else
    isValidInput "$input"
    getElementData "$input"
  fi
}

main "$@"
