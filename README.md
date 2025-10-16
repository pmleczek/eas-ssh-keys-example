# Building Fully Native iOS Apps with Expo EAS

### This repository contains the source code for tutorial at: <TODO-ADD-LINK>

## 📄 Overview

[Expo Application Services (EAS)](https://expo.dev/eas) is a set of powerful and highly customizable tools for building your React Native apps, automating the CI/CD and streamlined submissions to the app stores. It offers out-of-the-box integration with GitHub, allowing you to e.g. run CI/CD workflows on each pull request or push to the specific branch. But sometimes we might just need to perform some operations on a repository without the full integration, which would require us to set up access to GitHub on the EAS runner. This example explores three different ways of configuring such access on Expo EAS.

## 🗂️ Project structure

<pre>
.
├── <a href="./.eas">.eas/</a> # Expo EAS configuration files
│   ├── <a href="./.eas/build">build/</a> # Custom build configurations
│   │   ├── <a href="./.eas/build/build-ios.yml">custom-build.yml</a> # Custom build configuration
│   ├── <a href="./.eas/setupGithubAccess">setupGithubAccess/</a> # EAS TypeScript function
│   │   ├── <a href="./.eas/workflows/build">build/</a> # Built artifacts of the function
│   │   ├── <a href="./.eas/workflows/src/">src/</a> # Function sources
│   │   │   ├── <a href="./.eas/workflows/src/index.ts">index.ts</a> # Function entrypoint
├── <a href="./app">app/</a> # Expo app router files
├── <a href="./assets">assets/</a> # App assets
├── <a href="./components">components/</a> # App components
├── <a href="./constants">constants/</a> # App constants
├── <a href="./hooks">hooks/</a> # App hooks
├── <a href="./scripts">scripts/</a> # Scripts
│   ├── <a href="./scripts/new-tag.sh">new-tag.sh/</a> # Script releasing new tag in the repository
│   ├── <a href="./scripts/reset-project.js">reset-project.js</a> # Expo script for resetting the project
│   ├── <a href="./scripts/setup-github-access.sh">setup-github-access.sh/</a> # Script setting up SSH key for GitHub access on EAS
├── <a href="./app.json">app.json/</a> # Expo project configuration file
├── <a href="./eas.json">eas.json/</a> # Expo EAS configuration file
</pre>

## 🔨 Building the project

### ⚙️ Preqrequisites

Before building this example please make sure that:

- You have correct EAS `projectId` set up in `app.json`

- You have configured the SSH key both on GitHub and as an Expo EAS environment variable – instructions for those steps can be found in the tutorial

- Replaced the repo name and URL with your data in `scripts/new-tag.sh`

- Specified the correct Git email address and user name either in `scripts/setup-github-access.sh` or in `.eas/build/setupGithubAccess/src/index.ts` depending on your choice

### 🏗️ Rebuilding the TypeScript function

If you plan to use and made any changes to the TypeScript function make sure to rebuild it by cd-ing into its directory and running the following command:

```bash
cd .eas/build/setupGithubAccess

npm run build
```

### ☁️ Building on EAS cloud

Run the following command to start an EAS cloud build:

```
eas build -p <platform: ios or android> -e <build profile>

# e.g.

eas build -p android -e development
```

**Note:** The build can also be run locally by appending the `--local` flag to the above command, e.g:

```
eas build -p android -e development --local
```

## [Community Discord](https://discord.swmansion.com)

[Join the Software Mansion Community Discord](https://discord.swmansion.com) to chat about this example and other Software Mansion solutions.

## This project is created by [Software Mansion](https://swmansion.com)

[![swm](https://logo.swmansion.com/logo?color=white&variant=desktop&width=150 'Software Mansion')](https://swmansion.com)

Since 2012 [Software Mansion](https://swmansion.com) is a software agency with
experience in building web and mobile apps. We are Core React Native
Contributors and experts in dealing with all kinds of React Native issues. We
can help you build your next dream product –
[Hire us](https://swmansion.com/contact/projects).

Made by [@software-mansion](https://github.com/software-mansion) 💙
