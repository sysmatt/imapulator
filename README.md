# imapulator


usage: imapulator [-h] [-v] [-d] [-C] [-o] [-n NUMLOOPS] configFile

positional arguments:
  configFile            provide a ini configuration file

optional arguments:
  -h, --help            show this help message and exit
  -v, --verbose         increase output verbosity
  -d, --debug           enable debugging output
  -C, --clear           clear out pending messages upon startup before
                        processing
  -o, --oneshot         process account(s) only once then exit
  -n NUMLOOPS, --numloops NUMLOOPS
                        process account(s) this many times then exit

Configuration File Format
=========================

Configuration takes the form of a "ini" style file.  
Each ini section represents an account to process.  The section name must be unique.
If the USER setting is missing the section name is used.

INI File Values
===============

USER   - IMAP Authentication User, defaults to INI SECTION NAME if missing
HOST   - IMAP Server
PASS   - IMAP Password
FOLDER - IMAP Folder to read from
SAVEATT- Save all attachments in this (existing) directory
          For each message with attachments, a subdir uuid1 will be created.
          attachments will be saved in that dir
          Using /tmp here, for example, is safe.
          You are responsible for cleaning up.

PIPE   - Email Body is piped to STDIN of this program
    or
EXEC   - Program is executed, but nothing is sent to STDIN
          Note, $BODY and $BODYLINE are provided below to pass message body 
          as argument.

ARGS   - Multi-line, each line is passed as a argument to the PIPE or EXEC program. 
          Additional lines are indented.
          Each line is properly quoted when passed to exec() or popen(). 
          You may pass the following variable substitutions in arguments:

    $TO         To Header, Cleaned to just email addresses
    $FROM       From Header, Cleaned to just email addresses
    $CC         CC Header, Cleaned to just email addresses
    $SUBJECT    Subject header
    $REPLYALL   All email addresses from $FROM and $CC combined
    $BODY       The entire message body, including newlines
    $BODYLINE   The entire message body, all in single line. All whitespace
                 Including newlines are replaced by single spaces.
    $ATTDIR     The directory where attachments were stored, null if none.
    $ATTFILES   Replaced with properly quoted list of files. Note, this special
                 variable can not be combined with any other text in the same
                 INI ARGS line.  It should be used on a ARGS line on its own.
                 It is replaced with a list of files, passed directly to exec() or 
                 popen(), Most useful as last argument since it is variable length.

Example Configuration:
======================

[blah@gmail.com]
HOST    = imap.gmail.com
PASS    = blahBLAHblahPASSWORD
SAVEATT = /tmp
PIPE    = /sage/platform/scripts/sysmatt.epson.note
ARGS    = -s
    $SUBJECT
    -f
    $FROM

[blah@gmail.com/SpecialLabel]
USER   = blah@gmail.com
HOST   = imap.gmail.com
PASS   = blahBLAHblahPASSWORD
PIPE   = /sage/platform/scripts/sysmatt.epson.note
FOLDER = MySpecialLabel
ARGS   = -s
    Additional Text $SUBJECT
    -f
    $FROM
    -r
    $REPLY

[blah@gmail.com/ExecExample]
USER   = blah@gmail.com
HOST   = imap.gmail.com
PASS   = blahBLAHblahPASSWORD
EXEC   = /sage/platform/scripts/sysmatt.epson.note
ARGS   = -s
    Additional Text $SUBJECT
    -f
    $FROM
    -r
    $REPLY
    $BODYLINE
    $ATTFILES
