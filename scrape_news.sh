#!/bin/bash
# this script goes to ynetnews website, bring a URL for each article and in 
#each one, counts the number of times "gantz" and "Netanyahu" are mentioned
chmod +x ./scrape_news.sh
wget -q https://www.ynetnews.com/category/3082
grep -o -P  'https://www.ynetnews.com/article/\w{9}[#"]' 3082 | sort| uniq \
                                                              > search_list.txt
sed -i  's/.$//' search_list.txt
num_links=$(wc -l search_list.txt | awk '{print $1}') 
echo $num_links > results.csv
#this loop loops over all the URLs, and counts the number of times the words
#"Gantz" and "Netanyahu" appear in each article and saves the final result in
# the file results.csv
for(( i=1; i<=num_links;i++ )); do 
	gantz_cnt=0
	netanyahu_cnt=0
	url=$(sed -n $i\p search_list.txt)
	gantz_cnt=$(wget -q $url -O -| grep -o  "Gantz"| wc -l )
	netanyahu_cnt=$(wget -q $url -O -| grep -o  "Netanyahu" | wc -l )
	if [[ $gantz_cnt -gt 0 || $netanyahu_cnt -gt 0 ]]; then 
	   echo "$url, Netanyahu, $netanyahu_cnt, Gantz, $gantz_cnt," >> results.csv
	else
	   echo "$url, -" >> results.csv 
	fi
done
rm 3082
