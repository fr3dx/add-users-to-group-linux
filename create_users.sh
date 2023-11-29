#!/bin/bash

<<comment
A szk(r)ipt felhasználókat hoz létre
comment

# CSV fájl meglétének ellenőrzése
if [ ! -f "create_users.csv" ]; then
    echo "Hiba: a create_users.csv nem található."
    exit 1
fi

# CSV fájl feldolgozása, userek létrehozása
while IFS=$',\r' read -r user group; do
    if adduser -HD "$user" &> /dev/null; then
        echo "Felhasználó: $user létrehozva"
    else
        echo "Hiba: Nem sikerült létrehozni a(z) $user felhasználót."
    fi
done < create_users.csv
