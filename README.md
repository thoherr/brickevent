brick-event
===========

Overview
--------

This is a web registration application for the signup of exhibitors, staff and visitors at LUG events,
i. e. LEGO&reg; User Group (LUG) exhibitions.

The system was originally written for the registration of AFOLs (Adult Fans Of LEGO) for the LEGO KidsFest 2012
in Munich. Currently far too much of the texts and structure is hard coded. Most texts are in german language.

However, it is planned to generalize this rails app in order to use it for several of the many AFOLs events in Germany, Europe and Worldwide.

Help from other IT affine LEGO fans is very welcome ;-).

System requirements
-------------------

Currently the app uses Rails 3.1.12 and Sqlite3/MySQL.

A Vagrantfile and puppet manifests are provided to set up a production ready environment with no pain.
Deployment is done with tools/deploy.sh for now.

It is planned to incorporate bundler and a Capistrano deployment scheme shortly and probably upgrade to Rails 3.2.


