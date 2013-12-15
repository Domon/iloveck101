# iloveck101

A command-line tool to download images from [ck101][] threads. (Reimplementation of [iloveck101][] in Racket.)

[ck101]: http://ck101.com/
[iloveck101]: https://github.com/tzangms/iloveck101


## Installation

    raco pkg install iloveck101


## Usage

    raco iloveck101 [-v] <url>

The command saves images into `<thread-id> - <thread-subject>` directories under `~/Pictures/iloveck101`.


## Examples

    raco iloveck101 -v http://ck101.com/thread-2876990-1-1.html


## Platforms

It should work on Mac OSX 10.9 and Windows 7.


## Copyright

Copyright (c) 2013 Chun-wei Kuo. See [LICENSE][] for details.

[license]:  https://github.com/Domon/iloveck101/blob/master/LICENSE.txt

