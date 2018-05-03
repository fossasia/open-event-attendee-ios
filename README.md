[![Build Status](https://travis-ci.org/fossasia/open-event-ios.svg?branch=development)](https://travis-ci.org/fossasia/open-event-ios)

# Open Event iOS
**iOS** app for **Open Event**
![Open Event](https://storage.googleapis.com/eventyay.com/assets/branding/base_branding.png)

## Introduction
> This is an iOS app developed for `FOSSASIA` in mind. The Open Event Project offers event managers a platform to organize all kinds of events including concerts, conferences, summits and regular meetups.

## Communication

**Please join our mailing list to discuss questions regarding the project :-**

> *https://groups.google.com/forum/#!forum/open-event*

**Our chat channel is here :-**

> *https://gitter.im/fossasia/open-event*

## Things To Have
1. **[Xcode](https://developer.apple.com/xcode/)**
2. **[CocoaPods](http://cocoapods.org/)**

## Development Setup

Before you begin, you should already have the Xcode downloaded and set up correctly. You can find a guide on how to do this here: [Setting up Xcode](https://developer.apple.com/library/content/documentation/IDEs/Conceptual/AppStoreDistributionTutorial/Setup/Setup.html)

##### &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Steps to install Cocoapods (one time installation)

- Run `sudo gem install cocoapods` to install the latest version of cocoapods

-  Next, run `pod setup` for setting up cocoapods master repo. You may include `--verbose` for more descriptive logs.
**NOTE:** This might take a while to setup depending on your network speed.

## Setting up the iOS Project

1. Download the _open_event_ios_ project source. You can do this either by forking and cloning the repository (recommended if you plan on pushing changes) or by downloading it as a ZIP file and extracting it.

2. Navigate to the unzipped folder and run `pod install`.

3. Open `FOSSAsia.xcworkspace` from the folder.

4. Build the project (⌘+B) and check for any errors.

5. Run the app (⌘+R).and test it.
# Contribute!

> You're now ready to contribute!

Before writing any code, We will highly recommend to have a look at the [Contribution Guidelines](CONTRIBUTING.md) to avoid any unnecessary conflicts.

## Git commands for Configuring remotes
When a repository is cloned, it has a default remote called `origin` that points to your fork on GitHub, not the original repository it was forked from. To keep track of the original repository, you should add another remote named `upstream`:<br />
1. Get the path where you have your git repository on your machine. Go to that path in Terminal using cd. Alternatively, Right click on project in Github Desktop and hit ‘Open in Terminal’.<br />
2. Run `git remote -v`  to check the status of current remotes, you should see something like the following:<br />
> origin    https://github.com/YOUR_USERNAME/open-event-ios.git(fetch)<br />
> origin    https://github.com/YOUR_USERNAME/open-event-ios.git(push)<br />
3. Set the remote of orignal repository as  `upstream`:<br />
`git remote add upstream https://github.com/fossasia/open-event-ios.git`<br />
4. Run `git remote -v`  again to check the status of current remotes, you should see something like the following:<br />
> origin    https://github.com/YOUR_USERNAME/open-event-ios.git  (fetch)<br />
> origin    https://github.com/YOUR_USERNAME/open-event-ios.git  (push)<br />
> upstream  https://github.com/fossasia/open-event-ios.git (fetch)<br />
> upstream  https://github.com/fossasia/open-event-ios.git (push)<br />
5. To update your local copy with remote changes, run the following:<br />
`git fetch upstream development`<br />
`git rebase  upstream/development`<br />
This will give you an exact copy of the current remote, make sure you don't have any local changes.<br />
6. Project set-up is complete.<br />
## Git commands for developing a feature
1. Make sure you are in the development branch `git checkout development`.<br />
2. Sync your copy `git pull --rebase upstream development`.<br />
3. Create a new branch with a meaningful name `git checkout -b branch_name`.<br />
4. Develop your feature on Xcode IDE  and run it using the simulator or connecting your own iphone.<br />
5. Add the files you changed `git add file_name` (avoid using `git add .`).<br />
6. Commit your changes `git commit -m "Message briefly explaining the feature"`.<br />
7. Keep one commit per feature. If you forgot to add changes, you can edit the previous commit `git commit --amend`.<br />
8. Push to your repo `git push origin branch-name`.<br />
9. Go into [the Github repo](https://github.com/fossasia/open-event-ios) and create a pull request explaining your changes.<br />
10. If you are requested to make changes, edit your commit using `git commit --amend`, push again and the pull request will edit automatically.<br />
11. If you have more than one commit try squashing them into single commit by following command:<br />
`git rebase -i HEAD~n `(having n number of commits).<br />
12. Once you've run a git rebase -i command, text editor will open with a file that lists all the commits in current branch, and in front of each commit is the word "pick". For every line except the first, replace the word "pick" with the word "squash".<br />
13. Save and close the file, and a moment later a new file should pop up in  editor, combining all the commit messages of all the commits. Reword this commit message into meaningful one briefly explaining all the features, and then save and close that file as well. This commit message will be the commit message for the one, big commit that you are squashing all of your larger commits into. Once you've saved and closed that file, your commits of current branch have been squashed together.<br />
14. Force push to update your pull request with command `git push origin branchname --force`.<br/>

## License
This repository is licensed under the **[MIT License](LICENSE)**.
> To obtain the software under a different license, Please contact **FOSSASIA**.
