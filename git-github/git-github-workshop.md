### :camel: command based tasks
---
#### Task1: install git on linux
```
apt install git -y #on ubuntu server 
```
#### Task2: install git on windows/mac
* download git software from https://git-scm.com/downloads and install it 
#### Task3: create a github account
* go to www.github.com and create a free account using your personal email id (its free)
#### Task4: create an empty repository on github
* login to your github account 
* click + symbol at right top corner , select "New repository" , git a "Repository name" 
* select "public" , leave eveyrything default, click "Create repository" 
#### Task5: clone the repo from github remote to git local (linux)
* go to your repository on github.com , click on profile pic at "top right" -> select "your repositories" 
* click "Repositories" -> click the required repo -> click on "Code" (green button) -> click "HTTPS" -> copy the url of repo
* login to linux vm , go to the localtion where you want the repo to be created , and execute the below command
```
git config –-global user.name “name”
git config –-global user.email “email address”
git clone <repo-url that was copied in previous step>   # 
```
#### Task6: checkout a branch 
* go to the location where the git repo was cloned in previous task 
* execute below commands
```
git status                      # to check the staus of any files
git checkout -b my-new-branch   # new branch with name my-new-brach will be created
touch this-is-newfile1          # this-is-newfile1 will be created 
nano  this-is-newfile1          # open the file with nano editor
#enter your name in the file    
# save ctrl+o , press "Enter" , ctrl+x to exit out of nano
git status                      # newly added file should be detected by git
git add .                       # add the new file to index
git commit -m "new file added"  # commit the changes from index to local repo
git log --all --decorate --oneline --graph  # A DOG (easy to remember) and graphical log
git branch -avl
git checkout main               # move back to main branch
git merge my-new-branch         # merges my-new-branch with main branch 
git log --all --decorate --oneline --graph  # this time there will be only one branch
```
#### Task7: add a new file 
```
```
#### Task8: push the branch to remote
```
git push origin --all
```
#### Task9: create a pull request to merge
```
```
#### Task10: pull the new code from main branch to local repo
```
```
----
----
### :rocket: scenario based tasks 
#### scenario1: 
* _out of 5 developers working on a github repository, one has pushed fresh code to repo. You also have created fresh code and want to push to github central repo. How will you make sure your code does not conflict with others code ? _

