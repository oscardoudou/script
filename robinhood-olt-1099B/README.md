automate some repetive step during tax return
=======
#### Scenario 
I'm using robinhood as brokerage account. They generate a pdf version of consolidated 1099 form.  
Mostly the pdf is taken by security transactions, which is a headache when you need to manually type into whatever tax software you are using.  
Disclaimer: below is my lazy setup as NRA to handle hundreds of transaction with wash sale in OLT(ONLINE TAX RETURN tool), if you are RA, plenty of software and accountants could handle your case 

### Workflow
1. convert robinhood consolidate 1099 form from pdf to csv(I used convertio), name it raw.csv
2. data wrangling resulting csv to actually readeble and ready to use csv `./process.sh raw.csv > result.csv`
3. split the csv into per transaction based `./splitIntoCSVPerTransaction.sh result.csv`
4. install tamper-monkey script olt-1099B.js to chrome, also make sure the script is active in all phase(during step 5,6,7)
5. click "Add a new transaction from a 1099-B" 
6. click the "Choose file" button to import local csv 
7. double check the info autofilled
8. repeat step 5,6,7
