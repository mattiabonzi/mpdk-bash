# MPDK - Moodle Plugin Develpment Kit

This script is a simple wrapper for [Moodle Docker](https://github.com/moodlehq/moodle-docker) and it's main pourpose is to make it faster and easier to use that enviroment.

It's all written in pure bash, so it should work on different system, almost without external dependencies.

It also comes with some utilities like [Moosh](https://moosh-online.com/), [Local Pluginskel](https://github.com/mudrd8mz/moodle-tool_pluginskel) with a cli interactive "Create new plugin" interface, [Local Codechecker](https://github.com/moodlehq/moodle-local_codechecker) ([PhpCS](https://github.com/squizlabs/PHP_CodeSniffer)), pre-configured Node and Grunt, [Local Moodlecheck](https://github.com/moodlehq/moodle-local_moodlecheck) for [PhpDoc](https://en.wikipedia.org/wiki/PHPDoc) checking.
All the tool are installed inside the container or keeped as a local copy inside the MPDK enviriment, so nothing will interfere with your actual setup.

>**INFO**
>This script is not aimed to help Moodle Core developer, as for that, tools already exist.<br>
>The script should help those developer, organization, university and instiution that develop and mantain their own plugins for the Moodle ecosystem.


## Prerequisites
Make sure you have installed: `docker, wget, dialog, sed`<br>

**Mac**<br>
To get docker click [here](https://docs.docker.com/desktop/install/mac-install/)<br>
Everything else should be already installed, if not install [brew]() and then run `brew install wget dialog gnu-sed`
>**Note**: Enable "Virtualization framework" and "VitioFS filesystem" in Docker to boost performance on Mac with ARM system.


**Linux**<br>
To get docker click [here](https://docs.docker.com/desktop/install/linux-install/)<br>
Run `apt install dialog` or `apt install dialog wget sed` if needed (it shouldn't on most distro)


## Install


`git clone https://github.com/mattiabonzi/mpdk "~/Moodle plugin" && cd ~/Moodle\ plugin &&   chmod +x mdev && ./mdev install`

>**Note**: This will create a directory named "Moodle plugin" inside your $HOME that will be your's MPDK root, fell free to change it.


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
    -H              Open github repository homepage

Commands:

    install
        Install the enviroment and download dependencies (execute just one time)

    drop
        (DO NOT USE) Delete all data and file from this mpdk installation

    new [-t] [-v <version>] <name>
        Create a new instance
        -t          Create a test only instance
        -v          Moodle version (x.x.x or x.x)
        <name>      Name of the instance

    run [-tbd] [-p <port>] [-P <port>]
        Run (and init if necessary) the instance
        -t          Init as PhpUnit test instance
        -b          Init as Behat test instance
        -d			Init as development instance (default, only useful in combination with -t or -b)
        -p <port>   Specify the web port
        -P <port>   Specify the db port
        
    init [-tbd]
        Init the instance if not already
        -t          Init as PhpUnit test instance
        -b          Init as Behat test instance
        -d			Init as development instance (default, only useful in 

    stop [-a]
        Stop the instance, but retain the data (docker-compose stop)
        -a			Stop all the instances

    down [-fa]
        Stop the instance, and discard the data (docker-compose down)
        -f          Force, don't ask for confirmation
        -a			Stop all the instances
        
    remove [-a]
        Remove (delete) the instance codebase
        -a          Remove all the instances

    test [-b] [<path>]
        Execute all or the specified PhpUnit/Behat test
        -b          Execute Behat test
        <path>      Path to the test
        
    sniff [-pe] [<plguinames...>]
        Execute PhpCS and/or Grunt ESlint for the specified plugins
        It only works with registered plugin, see 'addplugin'
        -p          Execute only PhpCs (Incompatible with -e)
        -e          Execute only Eslint (Incompatible with -p)
        <plguinames>   Name of the plugin(s) to be checked

    sh <commands..>
        Execute commands inside the container
        Shortcut for 'docker exec {container-name} bash -l -c <commands>'
        
    ps [-an]
        Show the list of running docker container for the instance
        -a          Show the list for every instances
        -n          Show also not running instances (only useful if combined with -a)

    newplugin
        Interactivly create a new plugin structure with tool_pluginskel
        Refers to tool_pluginskel documentation for help with the recipe
        
    addplugin <component_name> <relative_path>
        Add a plugin to the registered plugins list (for code checking and version management)
        
     myplugin
        Show a list of registered plugin and their installed versions on every instance        


````


## Command details

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


#### Install

`install`

Install the dev enviriment
Download all the dependencies, create the config file and ask the user if to create a symlink to "/usr/local/bin" for use "mpdk" from everywhere


#### Drop
`drop`

Delete everything (the source also) from the enviroment, use only if you want to get rid of everything


#### New
`new [-t] [-v <version>] <name>`

Create a new instance downloading the specified version of Moodle (or the latest  stable if not specified).<br>
The instance will be cerated inside the MPDK_ROOT direcotry.<br>
The name of the instance will be used for:

* name the directory
* value of the $DOCKER\_COMPOSE\_PROJECT env
* site name and site description (with '_' converted to spaces)

If the instance is created without the option "-t" some plugin are added to the standard Moodle codebase:

* tool_pluginskel: for new plugin generation
* local_codechecker: for code checking with PhpCs
* local_moodlecheck: for PhpDoc checking

The instance isn't automatically initialized.


#### Run 


## Contribuiting

Every contribution is welcome!.<br>
If you encounter a bug or feel the need to add a new features open a new [issue](https://github.com/mattiabonzi/mpdk/issues).



## Roadmap

* Add a "moodle-version/plugin-version/test passed|fail" tracking utility
* Add test file for testing the script with tap
* Split the code in more file for easy maintenance and contrib
* Imporve the documentation
* Add git related command for ensure good git practice (https://docs.moodle.org/dev/Git_for_developers, https://docs.moodle.org/dev/Git_tips)
* Add support for the releasing process of plugin (https://docs.moodle.org/dev/Plugin_validation, https://docs.moodle.org/dev/Plugin_contribution_checklist)
* Explore https://github.com/SysBind/moodle-dev
