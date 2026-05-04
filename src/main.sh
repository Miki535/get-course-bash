getPrice() {
    dateAndTime=$(date)
    local codeA=$1
    local codeB=$2
    local currencyName=$3

    currencyPrice=$(curl -s https://api.monobank.ua/bank/currency \
    | jq -r --arg codeA "$codeA" --arg codeB "$codeB" --arg currencyName "$currencyName" '
    .[]
    | select(
          .currencyCodeA == ($codeA|tonumber)
          and
          .currencyCodeB == ($codeB|tonumber)
        )
    | "\($currencyName): купівля \(.rateBuy) | продаж \(.rateSell)"
')

    echo "$currencyPrice"

    if [ -f "currencyHistory.txt" ]; then
        echo "History updated"
    else
        touch "currencyHistory.txt"
    fi
    
    echo $dateAndTime >> "currencyHistory.txt"
    echo "$currencyPrice" >> "currencyHistory.txt"
}

echo "==============Currency=============="

echo "     ============USD============"
getPrice 840 980 BTC
echo "     ============EUR============"
getPrice 978 980 EUR
