# cPanel Git Deploy

This project is a set of scripts (bash, NodeJS, PHP) which enables you to have a complete
deployment pipeline from your remote repository(ies) to your cPanel hosted site via webhooks 
and a cron job.

## Requirements

This project requires a valid NodeJS binary available. If not found, it will attempt to 
install one for the user via curl and nvm. Your project must follow the [cPanel Git 
Deployment Guidelines](https://docs.cpanel.net/knowledge-base/web-services/guide-to-git-deployment/) 
for writing your deployment steps in the _.cpanel.yml_ file.

## Installation

### sub-domain
The best way to install this would be to clone/copy the files the repository on your desired 
host and deploy as a new dedicated sub-domain to the endpoint of your webhook url. e.g. If 
your target host is https://www.example.com, clone and set the repository folder as the root 
folder for https://deploy.example.com. This yields the best results and is the most hassle 
free.

### nested endpoint target
Clone/Copy the files in this repository and deploy it to your target folder. e.g. If your target 
host is https://www.example.com, clone the project where you wish relative to the root folder 
for the target where ~/public_html/deploy => https://www.example.com/deploy/. **NB:** If you 
choose this method, ensure you don't have a deployment step in _.cpanel.yml_ that deletes or 
overwites this project's folder.


## Configuration

### Config file
At the root of your cloned cpanel-git-deploy project, edit the config.json file adding your project 
configurations using the format described in the table below

|       Field       |     Type     |                Description                |
|-------------------|--------------|-------------------------------------------|
| project-name      | String       |  The name/identifier of the project       |
| branch            | String       |  The branch you want to be deployed       |
| repository        | String       |  The path to the root of your git project |
#### Example config.js
```json
{
    "project-name": {
        "branch": "master",
        "repository": "/home/user/repositories/example"
    },
    "project-name-2": {
        "branch": "staging",
        "repository": "/home/user/repositories/example2"
    }
}
```

### Cron Job
Create a cron job that runs every minute as shown below
```
* * * * * . /path/to/cloned/repository/deploy.sh >> $HOME/logs/deploy.log 2>&1
```

### Webhook
Set your webhook to POST to _https://\<host\>/\<path\>/?project=\<project-name\>_ or 
_https://\<host\>/\<path\>/index.php?project=\<project-name\>_ with the ***project-name*** 
configured above as a query parameter. For our sub-domain example this would look like 
`https://deploy.example.com/?project=project-name` or 
`https://deploy.example.com/index.php?project=project-name` while our nested endpoint example 
would be `https://www.example.com/deploy/?project=project-name-2` or 
`https://www.example.com/deploy/index.php?project=project-name-2`
