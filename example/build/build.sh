#!/bin/bash
echo [1m[32mSetting environment variables...[39m[22m
echo [1m[35mexport[39m[22m RETIS_LANGUAGE
export RETIS_LANGUAGE="nodejs"
echo [1m[35mexport[39m[22m RETIS_OS
export RETIS_OS="Linux"
echo [1m[35mexport[39m[22m RETIS_PROJECT_NAME
export RETIS_PROJECT_NAME="retis-example"
echo [1m[35mexport[39m[22m RETIS_GIT_USER
export RETIS_GIT_USER="Gum-Joe"
echo [1m[35mexport[39m[22m RETIS_GIT_COMMIT
export RETIS_GIT_COMMIT="fd4f9dade834c40e4be844e3199ed11f8d165c05"
echo [1m[35mexport[39m[22m RETIS_GIT_BRANCH
export RETIS_GIT_BRANCH="master"
echo [1m[35mexport[39m[22m RETIS_GIT_REMOTE
export RETIS_GIT_REMOTE="https://github.com/jakhu/retis-ci.git"
echo 
echo [1m[32mSettting environment variables from project specification file...[39m[22m
echo [1m[35mexport[39m[22m TEST
export TEST="test"
echo 
echo [1m[32m'Running pre install command(s)...'[39m[22m
echo [1m[32m[RUN][39m[22m echo 'Before install.'
echo 'Before install.' || {
	echo [1mCommand "echo 'Before install.'" exited with $?[22m
	exit $?
}
echo 
echo [1m[32m'Running install command(s)...'[39m[22m
echo [1m[32m[RUN][39m[22m echo 'Install.'
echo 'Install.' || {
	echo [1mCommand "echo 'Install.'" exited with $?[22m
	exit $?
}
echo 
echo [1m[32m'Running post install command(s)...'[39m[22m
echo [1m[32m[RUN][39m[22m echo 'After install.'
echo 'After install.' || {
	echo [1mCommand "echo 'After install.'" exited with $?[22m
	exit $?
}
echo 
echo [1m[32m'Running pre build command(s)...'[39m[22m
echo [1m[32m[RUN][39m[22m echo 'Before build.'
echo 'Before build.' || {
	echo [1mCommand "echo 'Before build.'" exited with $?[22m
	exit $?
}
echo 
echo [1m[32m'Running build command(s)...'[39m[22m
echo [1m[32m[RUN][39m[22m echo 'Build.'
echo 'Build.' || {
	echo [1mCommand "echo 'Build.'" exited with $?[22m
	exit $?
}
echo 
echo [1m[32m'Running post build command(s)...'[39m[22m
echo [1m[32m[RUN][39m[22m echo 'Done!'
echo 'Done!' || {
	echo [1mCommand "echo 'Done!'" exited with $?[22m
	exit $?
}
echo [1m[32m[RUN][39m[22m npm install qiwhfdiuewhfiuwehfihsdcbgewufh23r328uu
npm install qiwhfdiuewhfiuwehfihsdcbgewufh23r328uu || {
	echo [1mCommand "npm install qiwhfdiuewhfiuwehfihsdcbgewufh23r328uu" exited with $?[22m
	exit $?
}
