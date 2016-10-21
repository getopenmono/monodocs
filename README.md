# Mono Docs

[![Documentation Status](https://readthedocs.org/projects/mono-developer-documentation/badge/?version=latest)](http://developer.openmono.com/en/latest/?badge=latest)

This is the source for the site that holds documentation for developers
of [Mono](http://openmono.com) software and hardware.

The [site that displays the documentation](http://developer.openmono.com)
is read-only.

To contribute to the documentation itself, submit pull requests against
[the GitHub repository](https://github.com/getopenmono/monodocs).

## Local setup using virtual machine

You will need [VirtualBox](https://www.virtualbox.org/) and [Vagrant](https://www.vagrantup.com/) installed.

And you need the `mono_framework` repo to be a directory next to this repo.

Then you need to build and get into the virtual machine:

	$ vagrant up
	$ vagrant ssh

Inside the virtual machine, generate the documentation and restart the web server.

	$ cd /vagrant
	$ ./doxyrun.sh /mono_framework/src
	$ ./makeapi.py
	$ sphinx-build . _build/
	$ sudo service nginx restart

Now the documentation site is running at `localhost:8080`.

When the virtual machine is up and running, you only need to run one or more of the generating steps to get the web site updated:

	$ ./doxyrun.sh /mono_framework/src
	$ ./makeapi.py
	$ sphinx-build . _build/

And you can again check the changes on `localhost:8080`.

## Local manual setup

To build the docs locally you need the Python Package manager `pip`. On a mac with brew, install python (pip is included). (This will not overwrite the python that is distributed with OS X.)

	$ brew install python

With `brew`'s  python distribution installed, install `sphinx` and then `recommonmark` to support markdown:

	$ pip install sphinx
	$ pip install recommonmark
	$ pip install breathe

### Compile the docs

In the project root dir, the `conf.py` file contains the build settings. In the root dir, run:

	$ sphinx-build . _build/

## Releasing new versions

When you are satisfied with your local changes, commit to branch master.  Then go to the [specific project page on Read The Docs](https://readthedocs.org/projects/mono-developer-documentation/) and build a new version.
