# About this Project

This project is designed to help us in creating project documentation for code repositories. You can clone this whole project as a `git submodule` into whatever codebase to give the potential for ongoing documentation maintenance, or just use it as a quick way to generate a README.html file that will end up in your repo.

We are using <https://tiddlywiki.com> as the editing "engine", along with a little [Ruby server](#readme-server.rb) that you can use to host the file for easier editing (eg from remote or virtual machines).

TiddlyWiki has a lot of nice features that make it better for project documentation than simple Markdown or other plain-text formats, while still retaining viewability and portability over time (because it's just HTML/CSS/JS).


# File Structure

- `index.html` - The barebones "template" file that you can use as the foundation of your project documentation. When you run [readme-server.rb](#readme-server.rb), `index.html` will be the landing page.
- [readme-server.rb](#readme-server.rb) - Server code that makes it easier to host + edit _any_ of the `.html` files in this repository.
- `doc/readme.html` - This file, which is the meta-README :) We use it to generate the more basic `readme.txt` in the repo root.
- `dist/`- The original [TiddlyWiki](https://tiddlywiki.com) `empty.html` and `upgrade.html`, in case you want to start from a fully clean slate.


# How to Export as TXT

Because we often want to generate documentation for code repositories where HTML might not be perfect, we have added the ability to export a set of [Tiddlers](https://tiddlywiki.com/#Tiddlers) in plain text.

Note that the exported files will be in [WikiText](https://tiddlywiki.com/#WikiText) format unless you [have decided to use Markdown](#How to Use Markdown).

To learn more about exporting, first read [How to export tiddlers](https://tiddlywiki.com/#How%20to%20export%20tiddlers), and then note that in the EXPLO wiki files, we've added a [Custom Export Format](https://tiddlywiki.com/#Creating%20a%20custom%20export%20format) for "TXT File" export.


# How to Use Markdown

We have installed the [Markdown Plugin](https://tiddlywiki.com/plugins/tiddlywiki/markdown/) in our default wiki installations, to make it a bit easier for those coders who prefer Markdown.

To use it, just make a [Tiddler](https://tiddlywiki.com/#Tiddlers) as normal but change the "type" to `text/x-markdown` . Note that the [syntax is different](https://tiddlywiki.com/plugins/tiddlywiki/markdown/#MarkdownExample), especially for links.


# readme-server.rb

You can use this server to host any of the `.html` files in this repository (or any folder). You don't actually need to run this server to edit any of the README files. You can just open, for example, `index.html` and you'll get a fully functional, editable wiki. However, the server makes it easier to:

- Automatically save edits to any wiki file you've selected
- Host a file in a virtual machine and edit it elsewhere on the LAN
- Automatically create backups of any edited files, in a folder of your choice


## Setup

You will need to install Ruby, but otherwise there are no dependencies.


## Usage

Usage is simple: you can just type `./readme-server.rb`, and then navigate to the host IP at port 8000 (eg <http://localhost:8000>). The `index.html` file is edited by default, but you can edit any of the other files by adjusting the URL (eg <http://localhost:8000/doc/readme.html> to view/edit this very file).

To exit the server, type CTRL-C. The server will attempt to "rotate" your backup logs by running `bin/rotate_backups.sh`, which takes all but the last N (default 5) backups and TAR+GZIPs them to save space. You can also run this script manually should you so-desire.


## Options

For options, you can type `./readme-server.rb -h` or `./readme-server --help`. The options are:

    Usage: readme-server [options]
        -b, --backup DIR                 Directory in which to store backups. Defaults to "backup"                            
        -h, --help                       Print this help screen
        -p, --port PORT                  Port to serve from, defaults to 8000                                                 
        -r, --root ROOT                  Root directory from which to serve, defaults to "."    


# Usage

## Beginner Mode

Just open `index.html` and write documentation. Click the red checkmark on the right to save as a `README.html` for your project. Or [export as a TXT file](#How to Export as TXT).

## Pro Mode

Run [readme-server.rb](#readme-server.rb) and point your browser to http://localhost:8000 and you'll get auto-saving and auto-backup.

Make sure to check out <https://tiddlywiki.com> for tons of tips about syntax and usage. You can do some truly amazing things with this wiki.


