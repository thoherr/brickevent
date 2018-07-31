brick-event
===========

Overview
--------

This is a web registration application for the signup of exhibitors, staff and visitors at LUG events,
i. e. LEGO&reg; User Group (LUG) exhibitions.

The system was originally written for the registration of AFOLs (Adult Fans Of LEGO) for the LEGO KidsFest 2012 in Munich.

Currently still far too much of texts and structure is hard coded. All texts are of course available in german, but in the meantime most of them also have an english translation.

However, it is planned to further generalize this rails app in order to use it for several of the many AFOLs events in Germany, Europe and Worldwide.

In November 2016, Schwabenstein 2*4 e.V. joined the club and we introduced the LUG as Entity to this application.
Therefore, some of the UI is now dependent on the name this app is accessed (e. g. the logo).

Help from other IT affine LEGO fans is very welcome ;-).

Setup
-----

After cloning this repository do

    bundle

to get all required gems.

The repository contains a template for the database configuration file, so you have to do

    cp config/database.yml.template config/database.yml

and optionally edit `config/database.yml` to meet your DB preference (the template uses `sqlite3`).

Then

    rake db:migrate
    rake test

If you want to use the provided `Vagrantfile` resp. the puppet scripts, you have to update the git submodules with

    git submodule init
    git submodule update

System requirements
-------------------

Currently the app uses Rails 3.1.12 and Sqlite3/MySQL.

A `Vagrantfile` and puppet manifests are provided to set up a production ready environment with no pain.
Deployment is done with `tools/deploy.sh` for now.

It is planned to incorporate a Capistrano deployment scheme and probably upgrade to Rails 3.2 or even Rails 4.2.

Known Flaws
-----------

The system is currently implemented with a german UI. Even the english local files contain german texts.
