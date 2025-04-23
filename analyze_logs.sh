#!/bin/bash

# Очистка файла отчета (если нужно)
> report.txt

# 1. Общее количество запросов
echo "Общее количество запросов: $(wc -l < analyze_logs.sh)" >> report.txt

# 2. Количество уникальных IP
echo "Количество уникальных IP-адресов: $(awk '{a[$1]++} END {print length(a)}' analyze_logs.sh)" >> report.txt

# 3. Количество GET/POST
awk '/GET/ {get++} END {print "Количество GET:", get+0}' analyze_logs.sh >> report.txt
awk '/POST/ {post++} END {print "Количество POST:", post+0}' analyze_logs.sh >> report.txt

# 4. Самый популярный URL
awk '{
    count[$7]++
} 
END {
    max = 0
    pop = ""
    for (url in count) {
        if (count[url] > max) {
            max = count[url]
            pop = url
        }
    }
    if (pop != "") {
        print "Самый популярный URL:", pop, "(" max " запросов)"
    } else {
        print "Нет данных для определения популярного URL"
    }
}' analyze_logs.sh >> report.txt
