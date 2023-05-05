#!/data/data/com.termux/files/usr/bin/bash

echo  '  $$$$$$$\                             $$\                    $$$$$$$\'                                      
echo  '  $$  __$$\                            $$ |                   $$  __$$\'                                     
echo  '  $$ |  $$ |$$$$$$\ $$\   $$\$$$$$$$\$$$$$$\  $$\   $$\       $$ |  $$ |$$$$$$\  $$$$$$$\ $$$$$$\ $$$$$$$\'  
echo  '  $$$$$$$\ $$  __$$\$$ |  $$ $$  __$$\_$$  _| $$ |  $$ |      $$$$$$$  $$  __$$\$$  _____$$  __$$\$$  __$$\' 
echo  '  $$  __$$\$$ /  $$ $$ |  $$ $$ |  $$ |$$ |   $$ |  $$ |      $$  __$$<$$$$$$$$ $$ /     $$ /  $$ $$ |  $$ |'
echo  '  $$ |  $$ $$ |  $$ $$ |  $$ $$ |  $$ |$$ |$$\$$ |  $$ |      $$ |  $$ $$   ____$$ |     $$ |  $$ $$ |  $$ |'
echo  '  $$$$$$$  \$$$$$$  \$$$$$$  $$ |  $$ |\$$$$  \$$$$$$$ |      $$ |  $$ \$$$$$$$\\$$$$$$$\\$$$$$$  $$ |  $$ |'
echo  '  \_______/ \______/ \______/\__|  \__| \____/ \____$$ |      \__|  \__|\_______|\_______|\______/\__|  \__|'
echo  '                                              $$\   $$ |                                                    '
echo  '                                              \$$$$$$  |                                                    '
echo  '                                               \______/                                                     '

 
echo -n 'Bounty Recon Tool'
echo 
echo '* - finds subdomains'
echo '* - checks if subdomain is alive'
#echo '* - checks if alive domain is vulnerable to takeover'
echo '* - spiders alive domains'
#echo '* - enumerates network via nmap'
echo '* - scans for vulns with Nuclei'
 
echo -n 'Enter your target url: '
read TARGET
 
mkdir ~/targets/$TARGET/
SUBS=~/targets/$TARGET/$TARGET-subs.txt
ALIVE=~/targets/$TARGET/$TARGET-alive.txt
TAKEOVER=~/targets/$TARGET/$TARGET-takeover.txt
SPIDER=~/targets/$TARGET/spider/
NMAP=~/targets/$TARGET/$TARGET-nmap.txt
NUCLEI=~/targets/$TARGET/$TARGET-nuclei.txt
 
cd ~/go/bin/
 
echo '**** Finding Subdomains with assetfinder'
./assetfinder --subs-only $TARGET | tee $SUBS
 
echo '**** Checking if Subdomains are alive with httprobe'
cat $SUBS | ./httprobe -c 50 | tee $ALIVE
 
#echo '**** Checking if Subdomains are vulnerable to takeover with subjack'
#./subjack -w $SUBS -t 100 -timeout 30 | tee $TAKEOVER
 
echo '**** Spidering Alive Sites to Enumerate Endpoints'
./gospider -S $ALIVE -c 10 -d 1 -t 20 -o $SPIDER
 
#echo '*** Port Scanning Target #Subdomains through Nmap'
#nmap -iL $SUBS -sT -Pn -F -A --max-retries 2 --open | tee $NMAP

echo '**** Scanning vulns with Nuclei'
./nuclei -l $ALIVE -rate-limit 20 -concurrency 5 -timeout 10 -H [h1 email] -nts | 
tee $NUCLEI
