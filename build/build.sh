#!/bin/sh -xe

DATE=`date +%m-%d-%Y-%T`
cd "${0%/*}/.."
git checkout master --quiet
git pull origin master --quiet
composer install --no-interaction --no-progress --quiet
rm -rf sa_yaml/7/drupal sa_yaml/8/drupal

php application.php drupal-contrib-sa:download > /dev/null
php application.php drupal-contrib-sa:complete > /dev/null

# This will checkout all deleted files, but not untracked.
git checkout sa_yaml/ --quiet

if [ ! -z "$(git status --porcelain)" ]
then
  git add sa_yaml
  git checkout -b autoupdate/$DATE
  git commit -m "Drupal Contrib SA $DATE"
  git push origin autoupdate/$DATE
fi
