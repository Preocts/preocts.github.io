# Open that file

## How to be explicit with filepaths while still being portable

---

Maybe you've been here before; you are coding up a small script that needs to
open a file, read the contents, and take some actions.  You put your program
(`reader.py`) in the same directory as the file (`source.txt`) and code up the
following:

``` py title="reader.py"
with open("source.txt", "r"): as infile:
    file_contents = infile.read()

print(file_contents)
```

Here you tell Python to `open` the file `source.txt` and you don't give any type
of filepath to the file because it's right there, in the same place as your
program `reader.py`.  So you hit `Run` in your editor of choice and...

``` py title="console output" hl_lines="3"
Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
FileNotFoundError: [Errno 2] No such file or directory: 'source.txt'
```

What?

Now we're sure the `reader.py` and the `source.txt` are together in a folder
named `project`.  It looks like this:

``` title="directory tree"
C
└── Users
    └── preocts
        └── Documents
            └── project
                ├── reader.py
                └── source.txt
```

So, `reader.py` should totally be able to see `source.txt` and open it. Right?
Well, if we add a few lines of code we see the cause of our issue.

``` py title="reader.py" hl_lines="1 3-4"
import pathlib

print(pathlib.Path().cwd())
print(pathlib.Path(__file__))

with open("source.txt", "r"): as infile:
    file_contents = infile.read()

print(contents)
```

```py title="Console output" hl_lines="1-2"
C:\Users\preocts
C:\Users\preocts\Documents\project\reader.py

Traceback (most recent call last):
  File "<stdin>", line 1, in <module>
FileNotFoundError: [Errno 2] No such file or directory: 'source.txt'
```

We import `pathlib` which is a great standard library for working with
filepaths. The first print is showing us what is called the "current working
directory".  This is where the Python interpreter was run.

The second print is telling us where the `reader.py` is. `__file__` is a special
value set by Python which holds the location of the file.

Notice our paths here do not match! Python isn't "working" where our file is
located. We can think of that current working directory as a "You are here"
arrow on a map of our file system.  That's where the interpreter is and, unless
told otherwise, where the interpreter starts to look for files.

This is a common issue for anyone that uses the built-in terminal of their
editors to run the code.  Unless told otherwise, many editors default to the
user's home directory as the current working directory.

So when we used `open("source.txt")...` we assumed the interpreter would look in
the same path as the `reader.py` (at least, I did at first). Instead, python is
looking for the file at `C:\Users\preocts\source.txt`.

!!! tip "Key Point"
    **The Python interpreter's current working directory is set where the
    interpreter is run. This will affect where Python looks for files with the
    `open` statement (and imports too).**


So that's what is wrong with our program. We're just looking for our file in the
wrong place. Now, we just need a solution.

A fast and easy solution would be to use an absolute path to open our file.
Using `C:\Users\preocts\Documents\project\source.txt` would get the job done,
but it's not very portable. The code wouldn't work on anyone else's computer or
if we moved the files. Great for local-only projects.

Another solution would be to configure the editor to use the `.\project`
directory as the working directory. This can be a good habit for development but
if you shared the project, the next dev might have the same issue. Again,
portability is lost.

Instead, we can leverage that special `__file__` value and open `source.txt`
*relative to the location of* `reader.py`. Meaning that so long as we know where
`source.txt` is in relation to `reader.py` we will be able to find and open it.
To do this, we'll, again, use `pathlib`.

``` py
filepath = pathlib.Path(__file__).parent / "source.txt"
```

This looks complex if you aren't familiar with `pathlib` but it is actually very
straight-forward.

- `pathlib.Path(__file__)` gives us the full path to our file:
  `C:\Users\preocts\Documents\project\reader.py`
- `.parent` removes the right-most piece of the path, leaving us with just a
  location: `C:\Users\preocts\Documents\project`
- `/ "source.txt` is how we add to a `Path` object.
- Together we get `C:\Users\preocts\Documents\project\source.txt` which is the
  absolute path of our target file.

The neat thing is that if we move `reader.py` the code will still work so long
as we move `source.txt` with it.

Our end code looks like this:

``` py title="reader.py" hl_lines="1 3"
import pathlib

filepath = pathlib.Path(__file__).parent / "source.txt"

with open(filepath, "r"): as infile:
    file_contents = infile.read()

print(file_contents)
```

With an expected output of our file without needing to worry about where the
Python interpreter is running (working directory).

``` py title="Console output"
Eggs are amazing. # (1)!
```

1. In fact, they are eggcellent.  that's it, that's the yolk.  Now go have a shell of a good time programming.  Don't let little things like this scramble you.
