#AMZ-Pro

<img src='http://i.imgur.com/uGT7Nq5.png' height='300'>

AMZ-Pro is an application that allows Amazon merchants to see their sales KPIs in real time. Merchants can sign up and in, and see their products' aggregated performance.

https://amzpro.herokuapp.com/

##Technologies Used
Ruby<br>
Rails<br>
Heroku<br>
PostgreSQL<br>
Html<br>
CSS<br>

##APIs and Gems
Amazon MWS API<br>
Peddler gem<br>
OmniAuth Amazon gem<br>
BCrypt gem<br>
ChartKick gem<br>
Monetize gem<br>

## Project Road Map

##### Week 1

### Sprint 1 - Plan

### Sprint 2 - POC
* MWS response with correct data
* Rails project setup
* Render a line chart

##### Week 2

### Sprint 3 - Auth
* MWS oauth working
* Session
	* MWS auth token
	* User_id

### Sprint 4 - App Development
* Establish MWS call, response and chart render in controller action
* About page
* User experience flow

### Sprint 5 - Enable Multiple Calls
* Identify when multiple calls are needed
* Make multiple calls
* Consolidate data returned from multiple calls

##### Week 3

### Sprint 6 - Style

### Sprint 7 - Present

## Data Processing
<img src='http://i.imgur.com/j24KNO2.png' height='300'><br>
The data for this application is provided by Amazon's MWS API. A hash is returned that can have a NextToken. If there is a NextToken, additional requests are made and the hashes are condensed into one hash containing many orders. The condensed hash is then used to generate hashes that contain order counts and sales by day. Those are further aggregated by a the desired period. There is only a small user model for authentication.

## Wireframes
<img src='http://i.imgur.com/rW05xDD.jpg' height='300'>


## Hurdles
* **Authorization**. To make a successful request of MWS, an authorization token and a merchant's id are required. This made creating a session a 2-step process.
* **NextToken**. After changing query date parameters it became apparent MWS was not returning all orders for a given period. Upon investgating, MWS sends a NextToken hash as part of the object it returns. Further development was needed to check for the presense of this token, make additional requests and consolidate all the data returned.
