<<<<<<< HEAD
# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
=======
# Salesforce Senior Coding Challenge

We appreciate you taking the time to participate and submit a coding challenge! 🥳

In the next step we would like you to implement a simple Invocable Apex Action to be used by your Admin colleagues for a Flow. They need to do HTTP callouts to a NPS Service, whenever an Order got fulfilled. Below you will find a list of tasks and optional bonus points required for completing the challenge.

**🚀 This is a template repo, just use the green button to create your own copy and get started!**

### Invocable:

* accepts the Order Record Ids as Input Parameter
* queries the required records to get the Bill To E-Mail Address (`Contact.Email`) and OrderNumber (`Order.OrderNumber`)
* sends the data to the NPS API
* add a basic Flow, that executes your Action whenever an Order Status is changed to `Fulfilled`

### The Mock NPS API:

* Hosted at https://salesforce-coding-challenge.herokuapp.com
* ✨[API Documentation](https://thermondo.github.io/salesforce-coding-challenge/)
* 🔐 uses HTTP Basic Auth, username: `tmondo`, password: `Noy84LRpYvMZuETB`

### ⚠️ Must Haves:

* [ ] use `sfdx` and `git`, commit all code and metadata needed (so we can test with a scratch org)
* [ ] write good meaningful unit tests
* [ ] properly separate concerns
* [ ] make a list of limitations/possible problems

### ✨ Bonus Points:

* [ ] layer your Code (use [apex-common](https://github.com/apex-enterprise-patterns/fflib-apex-common) if you like)
* [ ] use Inversion of Control to write true unit tests and not integration tests
* [ ] make sure customers don't get duplicate emails
* [ ] think of error handling and return them to the Flow for the Admins to handle

### What if I don't finish?

Finishing these tasks should take about 2-3 hours, but we are all about **'quality > speed'**, so it's better to deliver a clean MVP and leave some TODOs open.

Try to produce something that is at least minimally functional. Part of the exercise is to see what you prioritize first when you have a limited amount of time. For any unfinished tasks, please do add `TODO` comments to your code with a short explanation. You will be given an opportunity later to go into more detail and explain how you would go about finishing those tasks.
>>>>>>> origin/main
