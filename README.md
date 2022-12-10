# MPDK - Moodle Plugin Develpment Kit

This script is a simple wrapper for [Moodle Docker](https://github.com/moodlehq/moodle-docker) and it's main pourpose is to make it faster and easier to use that repo.

It also come with some utilities like [Moosh](), [Local Pluginskel]() with a cli interactive "Create new plugin" interface, [Local Codechecker]() [(PhpCS)](), pre-configured Node and Grunt and [Local Moodlecheck]() for PhpDoc checking.
All the tool are installed inside the container or keeped as local coopy inside the MPDK enviriment, so nothing will interfere with your actual setup.

>**INFO**
>This is not aimed to help Moodle Core developer, as for that tools already exist.<br>
>The script should help those developer, organization, university and instiution that develop and mantain their own plugin for the Moodle ecosystem.

## Install

Run:

`git clone https://github.com/mattiabonzi/mpdk "Plugin dev" && cd Plugin\ dev &&   chmod +x mdev && ./mdev install`

*This will create a directory named "Plugin dev" that will be your's MPDK home, fell free to change it.*


## Quick start
#### Create a new instance
To create a new inctance (a new Moodle platform for developing or testing), named "my-instance" run:

`mpdk new my-instance`

this will install the latest stable version of moodle, you can also select a specific version using the `-v` options:

`mpdk new -v3.11.5 my-instance`

> Use a meaningful name for the instance (_eg. "myplugin\_dev\_4.1.0" or "myplugin\_fix\_3.8"_) for an easier management later on


#### Run an instance
To run an instance (once created), cd into it and run:

* `mpdk run` for a develpmence instance
* `mpdk run -t` for a PhpUnit testing instance
* `mpdk run -b` for a Behat testing instance
* `mpdk run -dtb` for a develpmence, PhpUnit and Behat instace

If the instace was already initialized it will not be re-initialized, you will have to use `mpdk init` for that.

#### Stop an instance

To stop an insatnce you can use either 

* `mpdk stop` for stopping it, preserving the generated docker volumes (the generated data)
* `mpdk down` for stopping it deleting all the data (not the code)


#### Create a new plugin
For create a new plugin, ensure that you have a running instance (`mpdk ps -a` to show running instance), run the following and answer the questions.

`mpdk newplugin`

This will generate the plugin skeleton using [Local Pluginskel](), init the GIT repository and configure Grunt (yuo can select what to do during the config process).<br>
You can now start coding!

#### Run PhpUnit/Behat test
For run test case in the instance (the instance must have been initialized with the `-t` and/or `-b` options) simply run:

* `mpdk test path/to/phpunit/test`
* `mpdk test -b behat-test-tag`

OR, to run all defined test:

* `mpdk test`
* `mpdk test -b`





## Command list

* **install**: Install the dev enviriment
* **drop**: Delete the dev enviriment (everything)
* **new**: Create a new instance
* **run**: Run (and init) the instance
* **init**: Init the instance
* **stop**: Stop the instance
* **down**: Stop and drop the instance volumes
* **remove**: Remove the instance codebase
* **test**: Run PhpUnit/Behat test
* **sniff**: Run PhpCs/Eslint code check
* **sh**: Shortcut for "docker exec {instance} bash -c"
* **ps**: Show running instance (docker ps)
* **newplugin**: Create a new plugin
* **addplugin**: Add a plugin to the registry
* **myplugin**: Show my plugin list

## Command and options
````yaml
Usage:
    mpdk [-i <path>] [-n name] [-h] <command> [-options..] [<args..>]

Current instance:
    The current instance can be selected either via
    - Working from inside an instance directory (at any level)
    - Global options, using -i or -n
    - Setting the '\$IROOT' env to the desired instance root

Global options:

    -i <path>       Path to moodle instance (alternative to -n)
    -n <name>       Name of Moodle instance (alternative to -i)
    -h              Display help screen
    -H              Display extended help screen

Commands:

    new [-d] [-v <version>] <name>
        Create a new instance
        -d          Create a development instance
        -v          Moodle version (x.x.x or x.x)
        <name>      Name of the instance

    run [-tb] [-p <port>] [-P <port>]
        Run the instance
        -t          Run a PhpUnit test instance
        -b          Run a Behat test instance
        -p <port>   Specify the web port
        -P <port>   Specify the db port

    stop
        Stop the instance, but retain the data 

    down [-f]
        Stop the instance, and discard the data
        -f          Force, don't ask for confirmation

    test [<path>]
        Execute all or the specified PhpUnit test
        <path>      Path to the test

    sh <args..>
        Just a shortcut for 'docker exec {container-name} bash -l -c <args>'

    newplugin
        Interactive procedure to creare a tool_pluginskel reciper for generating a new plugin    
        Refers to tool_pluginskel documentation for help
    
    sniff [-pe] [<plguinames...>]
        Execute PhpCS and/or Grunt ESlint for the specified plugins
        -p          Execute only PhpCs (Incompatible with -g)
        -e          Execute only PhpCs (Incompatible with -p)
        <plugins>   Name of the plugin(s) to be checked

        It only works with registered plugin, see 'addplugin'

    install
        Install the script and download dependencies (execute just one time)

    drop
        Delete all data and file from this mpdk installation
````

## Contribuiting


## Roadmap
