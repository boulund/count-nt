#!/usr/bin/env rdmd
/* 
Programmed in the D language
Fredrik Boulund 2014-05-21
Counts nucleotides (blindly) in FASTA files.
*/

import std.getopt; // Parse command line arguments
import std.string; // chomp
import std.stdio; // writeln, writefln etc.


bool parseArgs(ref string[] args, ref bool stdin, ref bool help) {
	if (args.length < 2) {
		printHelp();
        return false;
	}
	try {
		getopt(args, 
            "s|stdin", &stdin,
			"h|help", &help,
            );
		if (help) {
			printHelp();
            return false;
		}
	}
	catch (Exception e) {
		writefln("%s\nType -h or --help for help", e.msg);
        return false;
	}
    return true;
}


void printHelp()
{
	writeln("Simple nucleotide counter in D, Fredrik Boulund (c) 2014");
	writeln("  usage: count_nt [options] file.fasta");
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
           current += chomp(line).length;
        }
    }
    total += current;
}


void readFromFile(File fastaFile, ref uint total) {
    uint current;
    debug writeln("Reading ", args[1]);
    auto currentLine = fastaFile.readln();
    while (!fastaFile.eof()) {
        if (currentLine[0] == '>') {
           total += current;
           current = 0;
        }
        else {
           current += chomp(currentLine).length;
        }
        currentLine = fastaFile.readln();
    }
    total += current;
}


int main(string[] args) {
    bool stdin, help;
    uint total, current;

    if (!parseArgs(args, stdin, help)) return(1);

    if (stdin) {
        debug writeln("Reading from stdin");
        readFromStdin(total);
    } else {
        debug writeln("Reading from '", args[1], "'");
        File fastaFile = File(args[1], "r"); 
        readFromFile(fastaFile, total);

    }
    writeln(total);
    return 0;
}
