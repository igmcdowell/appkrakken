# About
AppKrakken parses Apple's RSS feeds to retrieve the top 400 apps in various categories for the US market, for a total database of ~40k apps.  These feeds are fetched once daily. Individual apps are checked for price changes at the rate of 500/10 minutes using Apple's affiliate API.

A working installation is available at http://appkrakken.heroku.com

# Usage
- ./apps.json?n=<#> : Return the n apps with the most recent price drops. e.g. ./apps.json?n=5 would show the five most recent. Default is 5, limit is 50.

- ./apps/<app_id>.json : Return the specified app and any price drops. app_id is Apple's id for the app; you can get it from their APIs or the list of price drops.
