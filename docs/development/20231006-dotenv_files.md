# The .env File

The `.env` file can be a valuable addition toward controlling the run-time
environment of a process. From system level configuration flags to access
tokens, the `.env` gives the developer a single place to configure the
environment. The values stored within the file can be quickly loaded into the
process' run-time environment. This provides ease of querying for the process
and a separation of secrets for security.

Let us pull back and take a high level tour of what is actually happening.

## The Environment

To start, we need to look at "the environment". The operating system running on
your computer creates an environment that all other processes will run in.
Environment variables were introduced to this system environment as a way to
allow those processes easy access to general global details of the environment.
Examples such as:

- What is the current user's name
- Where is the current user's home directory
- What paths should be searched for an executable binary

These common queries can be answered by any process looking up the correct
environment variable. Like variables in many programming languages, the name is
a meaning label that references a value held in memory. The way to answer the
above questions can vary by operating system but looks something like:

- Linux: `$USER`  Windows: `%USERNAME%`
- Linux: `$HOME`  Windows: `%USERPROFILE%`
- Linux: `$PATH`  Windows: `%PATH%`

!!! tip "Naming"

    You can name an environment variable almost anything but it's a good idea to
    always make them meaningful to the process that is using it. It's also a
    good idea to always use uppercase. While some operating systems are not
    case-sensitive, most sane ones are.

## Process Layers

Environment variables can be set, unset, and updated from many places. For
example; running the following in a terminal on a linux system will create an
environment variable and echo it to the terminal:

```console
$ export SAMPLE_VARIABLE="Hello there"
$ echo $SAMPLE_VARIABLE
Hello there
```

An important fact to know is that when the terminal session is closed the
environment variable will be gone. In fact, `SAMPLE_VARIABLE` will not exist in
new terminal sessions or previously opened sessions. This is because we've
created the environment variable within the running terminal process.

Environment variables are inherited from the parent process down to any children
processes. It is a one-way street. The inherited environment variables can also
be altered before the child process starts.

As the layers of processes are built from the kernel of the operating system to
a terminal session into a running process, the environment variables can be
expanded to contain information required for that process layer and any children
processes.

!!! tip "Origins"

    Each operating system has a source for those environment variables that are
    always present such as `USER`, `HOME`, and `PATH`. Some are handled by the
    operating system directly. Others are loaded per session from configuration
    files that are evaluated. An example would be the `.profile` file which
    allows a linux user to define default exports for all sessions.

## Defining the .env file

A `.env` file is a plain text file that contains key-value pairs that will
become part of the environment. The file itself can be named anything. It is
usually a good idea to ensure the `.env` file is ignored by any version control
as it usually contains tokens and secrets.

This is an example file:

``` ini title=".env"
VENDOR_API_KEY=Q29uZ3JhdHVsYXRpb25zLCB5b3UgZ2V0IGEgY29va2llIQ==
DATABASE_PASSWORD="correct horse battery staple"
```

Occasionally you might see a `.env.shared` file in a repository. These can be
useful to hold non-secrets that are still needed to test locally.

``` ini title=".env.shared"
DATABASE_PORT=3306
DATABASE_URL=127.0.0.1
DATABASE_NAME=local_test
DATABASE_USER=tester01
DATABASE_PASSWORD=strongpassword1234
```

Both files have the same goal: hold any environment variables required by the
project.

## Loading the .env file

Loading the `.env` file usually happens at run-time and the process to do so
varies depending on what is loading it. Programming languages have either
standard libraries or popular third-party libraries to load the file. Tools like
Docker and Kubernetes have inputs for the `.env` and ensure their inner
environments are properly loaded.

The process looks the same for general use:

1. Identify the name of the file to load (default: `.env`)
2. Read the key-value pairs in
3. Inject into the current process' run-time environment
4. Repeat for any additional `.env` files

Remember that as discussed earlier; the environment variables created at this
point exist only for the process which created them and their child processes.
For a Kubernetes node, any process running on the node will have access to the
environment variables. For an individual program, only it would have access to
the environment variables loaded.

This allows for flexible and dynamic control of individual environments running
side-by-side.

!!! tip "Overriding"

    Any environment variables loaded from a `.env` file that already exist in
    the environment is overridden. This adds to the dynamic control over
    run-time environments.

## A dev's thoughts

Using the `.env` file and working from the run-time environment offers some
beneficial design choices when programming. Interfaces and instantiation of
providers that require api keys, passwords, or tokens can default to looking at
the environment. This reduces the overhead of handling any of these values in
the codebase completely. Simply ensure on an invocation of run-time that the
values are loaded once. If needed, load the environment at the container layer.

This also leads to the best practice of accessing the production vault, or
key-store, as infrequently as possible. A single call when the environment
run-time has started. Future processes inherit that environment and do not need
access or knowledge of the source. It becomes a clean separation that makes any
dev smile.

Going full-circle, the `.env` file stands in as a production vault replacement
locally. As the local dev the application, library, or process can be run and
tested on seamlessly without risky access to systems that should never be part
of "my machine".
