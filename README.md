# Purpose

__A hacky tool to poll github and enqueue jenkins builds for new PRs.__

Using this tool avoids double-enqueuing builds for large repos where the jenkins git plugin seems to detect multiple changes and cause two builds to be enqueued.

This problem does not seem to occur on smaller repos.  For those smaller repos, skip this tool and simply alter the git refspec to: `+refs/pull/*:refs/remotes/origin/pr/*` then trigger builds on pushes to `**/pr/**/head`
See: http://continuousdeliberation.wordpress.com/2013/02/21/building-pull-requests-with-jenkins/

Note: This may actually workaround an issue that could be resolved with a more complex refspec once a bug in NetBeans-git is fixed and availabe in jenkins.

## Usage
### Configuration
* Configuration is done primarily through environment variables.  
* You can use a shell script to save the variables and load them between builds or via a linux service.


```sh
export GITHUB_USER=tom
export GITHUB_TOKEN=29c0d9fe03079dfdf1bd8e3ca2d2d0a6f3e5f423
export GITHUB_REPO=pudding
export JENKINS_JOB=name_of_job_we_want_to_run_on_jenkins
```

### Running
* rake enqueue:run


