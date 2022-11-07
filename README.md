# Salesforce Senior Coding Challenge

We appreciate you taking the time to participate and submit a coding challenge! 🥳

In the next step we would like you to implement a simple Invocable Apex Action to be used by your Admin colleagues for a Flow. They need to do HTTP callouts to a NPS Service, whenever an Order got fulfilled. Below you will find a list of tasks and optional bonus points required for completing the challenge.

**🚀 Fork this repo to get started!**

### Invocable:

* accepts the Order Record Ids as Input Parameter
* queries the required records to get the Customers E-Mail Address (`Account.PersonEmail`) and OrderNumber (`Order.OrderNumber`)
* sends the data to the NPS API
* add a basic Flow, that executes your Action whenever an Order Status is changed to `Fulfilled`

### The Mock NPS API:

* Hosted at https://salesforce-coding-challenge.herokuapp.com
* ✨[API Documentation](https://thermondo.github.io/salesforce-coding-challenge/)
* You'll receive the API credentials directly from us 😉

### ⚠️ Must Haves:

* [ ] write good meaningful unit tests
* [ ] use `sfdx` and `git`, commit all code and metadata needed
* [ ] make a list of limitations/possible problems

### ✨ Bonus Points:

* [ ] Layer your Code (use [apex-common](https://github.com/apex-enterprise-patterns/fflib-apex-common) if you like)
* [ ] Properly separate concerns
* [ ] Use IoC and write true unit tests and not integration tests
* [ ] Make sure customers don't get duplicate emails
* [ ] Think of error handling and make it possible for Admins to add it to their Flow

### What if I don't finish?

Finishing these tasks should take about 2 hours, but we are all about **'quality > speed'**, so it's better to deliver a clean MVP and leave some TODOs open.

Try to produce something that is at least minimally functional. Part of the exercise is to see what you prioritize first when you have a limited amount of time. For any unfinished tasks, please do add `TODO` comments to your code with a short explanation. You will be given an opportunity later to go into more detail and explain how you would go about finishing those tasks.