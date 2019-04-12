# Commodore 1541 DOS ROM Source Code

This is based on the [reconstruction](https://github.com/mist64/cbmsrc) of the Comodore 1541 DOS ROM. The source has been adapted to work with the cc65/ca65 assembler. All original symbols and comments are intact.

The history of the repository contains all versions from the 1540 to the 1541-II:

| Revision | Part Numbers         | Description                |
|----------|----------------------|----------------------------|
| 1371125  | 325302-01, 325303-01 | 1540                       | 
| 1b7ccc4  | 325302-01, 901229-01 | 1541 (original)            |
| 11fa875  | 325302-01, 901229-02 | 1541 (update)              |
| 1109aa1  | 325302-01, 901229-03 | 1541 (update)              |
| bfaf45a  | 325302-01, 901229-05 | 1541 (short board)         |
| bd9aae0  | 325302-01, 901229-06 | 1541 (short board, update) |
| 543e4b0  | 251968-01            | 1541C (original)           |
| cd67762  | 251968-02            | 1541C (updated)            |
| HEAD     | 251968-03            | 1541-II                    |

All versions build into the exact ROM images, except for checksum and signature bytes.

This makes this repository not just a great base for custom 1541 DOS ROMs, but also a great resource to research ROM differences.

## Building

* Use `make` to build.
* Requires [cc65](https://github.com/cc65/cc65).
* The resulting file `dos.bin` is the full `$C000`-`$FFFF` image.
* The only differences are the checksum bytes at `$C000` and `$FEE6` and the signature byte at `$FFE5`.

## Credits

This version is maintained by Michael Steil <mist64@mac.com>, [www.pagetable.com](https://www.pagetable.com/)