#!/bin/bash
#
#3> <> a conversion:RetrievalTrigger, doap:Project;
#3>    prov:wasDerivedFrom <https://github.com/timrdf/ieeevis/blob/master/data/source/en-wikipedia-org/Siena_College/version/2014-Jun-17/retrieve.sh>;
#3>    rdfs:seeAlso <http://www.mediawiki.org/wiki/Manual:Parameters_to_Special:Export>,
#3>                 <http://en.wikipedia.org/wiki/Wikipedia:Lamest_edit_wars>;
#3> .

api='http://en.wikipedia.org/w/index.php'

if [[ $# -eq 0 || "$1" == '--help' || "$1" == '-h' ]]; then
   echo
   echo "`basename $0` [--api <url>] <page_title>+"
   echo
   echo "   --api <url> : The URL of the Mediawiki API, e.g. $api (which is the default)"
   echo "    page_title : The page name to retrieve full edit history. e.g. Siena_College"
   exit
fi

if [[ "$1" == '--api' ]]; then
   api="$2"
   shift 2
fi

if [[ -e "$1" ]]; then
   # If the 'page_title' argument exists as a file, request all pages listed.
   page_list="$1" 
   cat $page_list | xargs -I page $0 --api $api page
else
   mkdir -p quoted
   while [ $# -gt 0 ]; do
      page="$1" # e.g. 'Siena_College'
      shift
      echo quoted/$page.xml

      # Retrieves first 5 edits.
      #curl -d "" "$api?title=Special:Export&pages=$page%0ATalk:$page&offset=1&limit=5&action=submit" > quoted/${page}_1-5.xml

      # Retrieves 1026 Siena_College edits and 319 Talk:Siena_College edits.
      if [[ ! -e "quoted/$page.xml" ]];then
         curl "$api?title=Special:Export&pages=$page%0ATalk:$page&history&action=submit" > quoted/$page.xml
         echo "$api?title=Special:Export&pages=$page%0ATalk:$page&history&action=submit" > quoted/$page.xml.url
         sleep $(($RANDOM%30)) # sleep 0-30 seconds, give poor Wikipedia a break...
      fi
   done
fi
