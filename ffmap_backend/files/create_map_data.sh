#!/bin/bash
# Shellskript zum Erzeugen vom Kartendaten

# Domänentexte
declare -A text
text=([00]=Test [01]=Münster [02]="Kreis Coesfeld" [03]="Kreis Steinfurt West" [04]="Kreis Steinfurt Ost" [05]="Münster Süd" [06]=Westmünsterland [14]="Kreis Warendorf")

# Daten mit ffmap-backend aus Alfred auslesen und owner entfernen
for i in /proc/sys/net/ipv4/conf/bat*; do
    num=${i#*bat}
    mkdir -p /var/ffmap/data${num}
    mkdir -p /var/www/html/maps/data${num}
    /usr/src/ffmap-backend/backend.py -d /var/ffmap/data${num} -m bat${num}:/run/alfred.$(printf %02d ${num}).sock
    jq '.nodes = (.nodes | with_entries(del(.value.nodeinfo.owner)))' < /var/ffmap/data${num}/nodes.json > /var/www/html/maps/data${num}/nodes.json
    cp /var/ffmap/data${num}/graph.json /var/www/html/maps/data${num}/graph.json
done

# Daten der Legacy-Domäne per wget holen
mkdir -p /var/ffmap/data_legacy /var/www/html/maps/data_legacy
wget http://192.168.43.3/map/data/nodes.json -O /var/ffmap/data_legacy/nodes.json
wget http://192.168.43.3/map/data//graph.json -O /var/ffmap/data_legacy/graph.json
mv /var/ffmap/data_legacy/* /var/www/html/maps/data_legacy

# Daten mit merge_map_data.py zuammenfügen
mkdir -p /var/www/html/maps/data
/usr/src/tools/merge_map_data.py -o /var/www/html/maps/data /var/www/html/maps/data?*

# meshviewer-Daten kopien/verlinken, wenn noch nicht vorhanden und index.html erzeugen
for i in /var/www/html/maps/data?*; do
    suf=${i#*data}
    if [ ! -e /var/www/html/maps/map${suf} ]; then
        name=$(echo $suf | sed -e s/_legacy/Legacy/)
        mkdir /var/www/html/maps/map${suf} && cd /var/www/html/maps/map${suf} && ln -s ../map/* . && rm config.json && sed -e "s#/data/#/data$suf/#" -e "s#Münsterland#Münsterland - Domäne ${name}#" <../map/config.json >config.json
        cat <<EOF > /var/www/html/maps/index.html
<html>
<head>
<meta charset="UTF-8">
<title>Freifunk Münsterland</title>
</head>
<body>
<h1>Freifunk Münsterland - Karten</h1>
<p><a href="map/">Gesamtkarte</a></p>
EOF
	for j in /var/www/html/maps/data?*; do
	    suf2=${j#*data}
	    name=$(echo $suf2 ${text[$suf2]:+-} ${text[$suf2]}| sed -e s/_legacy/Legacy/)
	    echo "<p><a href=\"map$suf2/\">Domäne $name</a></p>" >> /var/www/html/maps/index.html
        done
        cat <<EOF >> /var/www/html/maps/index.html
</body>
</html>
EOF
    fi
done
