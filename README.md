# inventory

Command line utility for CSV inventory of files

## How to use

This is a program with a command-line interface (or CLI). You can run it in your
command prompt or terminal of choice, such as Windows Command Prompt, PowerShell,
or Git Bash.

Using any of these, `cd` to this directory (or wherever the executable lives),
and execute the program like so: `./inventory-exe.exe`. Executing without the
required argument will print the help text that shows usage and available options.

The directory whose files you want to inventory is a required argument, and is
preceded by `-s` or `--src`. The file you want to write the CSV output to is an
optional argument, and is preceded by `-d` or `--dest`. If you don't supply that
argument, output will instead be sent to stdout, which means it will be printed
to the screen or you could pipe it into another program.

All together now:
```
./inventory-exe.exe --src C:/Users/CHanley/Downloads
--dest C:/Users/CHanley/Downloads/inventory.csv
```

It will run faster if you copy the executable to your local machine and run from
there. Also, beware of huge directories.
