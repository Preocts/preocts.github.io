# How-to: deadsnakes on Ubuntu

## Installing Python versions with deadsnakes on Ubuntu

This guide was written for Ubuntu though it should work for any distro of linux
that uses `apt` for package management.  With this guide you will be able to
install any desired version of Python that is available from the deadsnakes PPA
(Personal Package Archive).  Two things before we start:

1. **Do not attempt to remove or alter your system's default version of
   Python**. Leave it alone, it's happy and doing its thing.
2. The deadsnake PPA is not an official source of Python. [You can find the
   source here and research it yourself](https://github.com/deadsnakes).

## What is deadsnakes?

To quote the maintainer:

> New and old Python versions for Ubuntu

deadsnakes is a personal package archive which houses new and old versions of
Python, built from source, and ready to install via the package manager.  Thanks
to the efforts of the maintainers, we developers have ease of access to the
versions we need.

## Adding the PPA

To install from deadsnakes you will need to add the PPA to your package manager.
This will allow the regular update and upgrade commands to use the deadsnakes
repository as a source.

The bash commands to run are:

```bash
sudo add-apt-repository `ppa:deadsnakes/ppa`
sudo apt update
```

The first installs the PPA repository and the second runs a package update to
refresh the state of your package manager.

## Installing Python 3.X

The next step is to install the Python version desired.  Replace the `3.x` with
the version you wish to install. (e.g.: `3.10` or `3.8`)

The bash commands to run are:

```bash
sudo apt install python3.x # (1)!
sudo apt install python3.x-venv
```

1. Replace `x` here with the version you want.

*Note*: The second command is optional although highly recommended. It will
allow you to create virtual environments (`venv`) with the given python version.
If you already have an alternative solution for this the command can be skipped.

## That's it

You have installed a new version of Python, congratulations. There is no need to
muck with your system's default install.  In fact, don't.  Just leave it alone.
In the bash terminal you can use the following command to confirm the new
install is ready to use.  Again, replace the `3.x` with the version you
installed.

```bash
python3.x --version
```

---

### Bonus: Shell Script

This is my shell script used to install all the versions of Python I generally
test with and develop on.



```bash
#! bin/bash

sudo add-apt-repository -y 'ppa:deadsnakes/ppa'
sudo apt update
sudo apt install -y python3.7 python3.8 python3.9 python3.10 python3.11
sudo apt install -y python3.7-venv python3.8-venv python3.9-venv python3.10-venv python3.11-venv
```
