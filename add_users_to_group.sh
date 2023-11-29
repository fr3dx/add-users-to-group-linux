#!/bin/bash

<<comment
A szk(r)ipt felhasználókat ad hozzá a táblázatban szereplő csoporthoz
A CSV fajl neve a következő kell legyen: add_users_to_group.csv

Tartalma a következő: 
felhasznalonev,csoport

Egy felhasználót több csoporthoz is hozzá lehet adni: 
felhasznalonev1,csoport1
felhasznalonev1,csoport2

Formázási probléma esetén használható a következő:
dos2unix add_users_to_group.csv 
comment

# CSV fájl meglétének ellenőrzése
if [ ! -f "add_users_to_group.csv" ]; then
    echo "Hiba: a add_users_to_group.csv nem található."
    exit 1
fi

# CSV fájl feldolgozása, userek hozzáadása a csoport(ok)hoz
while IFS=$',\r' read -r user group; do
    if [ -z "$user" ] || [ -z "$group" ]; then
        echo "Hiba: Hibás formátum a CSV fájlban."
        continue
    fi

    if ! id -u "$user" &>/dev/null || ! getent group "$group" &>/dev/null; then
        echo "Hiba: A felhasználó vagy csoport nem létezik - Felhasználó: $user, Csoport: $group"
        continue
    fi
    
    if usermod -aG "$group" "$user" &> /dev/null; then
        echo "Felhasználó: $user hozzáadva a csoport(ok)hoz: $group"
    else
        echo "Hiba: Nem sikerült hozzáadni a(z) $user felhasználót a(z) $group csoport(ok)hoz."
    fi
done < add_users_to_group.csv
