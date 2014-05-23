#!/usr/bin/env rdmd
/* 
Programmed in the D language
Fredrik Boulund 2014-05-21
Counts nucleotides (blindly) in FASTA files.
*/

import std.getopt; // Parse command line arguments
import std.file;
import std.stdio; // writeln, writefln etc.


bool parseArgs(ref string[] args, ref bool stdin, ref bool help) {
	/* Parse command line options and arguments */
	if (args.length < 2)
	{
		printHelp();
        return false;
	}
	try
	{
		getopt(args, 
            "s", &stdin,
            "stdin", &stdin,
			"h", &help,
			"help", &help);
		if (help) 
		{
			printHelp();
            return false;
		}
	}
	catch (Exception e)
	{
		writefln("%s\nType -h or --help for help", e.msg);
	}
    return true;
}

void printHelp()
{
	writeln("Simple nucleotide counter in D, Fredrik Boulund (c) 2014");
	writeln("  usage: count_nt [options] FILE");
	writeln("Available options:\n"
      "  -s, --stdin    Read stdin instead of FILE\n"
	  "  -h, --help     Show this friendly and helpful message\n"
	  );
}

void readFromStdin(ref uint total) {
    uint current;
    string line;
    while ((line = stdin.readln()) !is null) {
        if (line[0] == '>') {
           total += current;
           current = 0;
        }
        else {
           current += line.length;
        }
    }
    total += current;
}

bool readFromFile(string fastaFile, ref uint total) {
    uint current;
    bool header;
    debug writeln("Reading ", args[1]);
    auto bytes = cast(ubyte[]) read(fastaFile); 
    if (bytes[0] == '>') {
        header = true;
    } else {
        return false;
    }
    foreach (b; bytes[1 .. $]) {
        if (header) {
            if (b == '\n') {
                header = false;
            }
        } else {
            if (b == '\n') {
                continue;
            } else if (b == '>') {
                header = true;
            } else {
                total += 1;
            }
        }
    }
    return true;
}


int main(string[] args) {
    bool stdin, help;
    if (!parseArgs(args, stdin, help)) return(0);

    uint total = 0;
    uint current = 0;
    if (stdin) {
        debug writeln("Reading from stdin");
        readFromStdin(total);
    } else {
        debug writeln("Reading from '", args[1], "'");
        if (readFromFile(args[1], total)) {}
        else {
            writeln("ERROR: Input not FASTA.");
        }

    }
    writeln(total);
    return 0;
}
