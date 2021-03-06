# Automated-Crypto-Price-Updates
This script takes as input an Excel Workbook containing subscription details. This information could also have come from a database.

The input table has information about which crypto currencies each subscriber would like to receive price updates about, as well as subscriber contact info.

The script gets the pricing data through the www.coinbase.com API.

An email is sent to each subscriber containing only the prices for which they signed up. Each subscriber, therefore, receives a personalised email, with their name in the body and only the crypto currency prices for which they signed up.

I used Windows Task Scheduler to schedule this script to run every morning. That way, I have an automated way to send emails with relevant info to my subscriber list. I only have to maintain the database / Excel Workbook.

Check out my video about this: https://youtu.be/s2XGyXyW0CQ
