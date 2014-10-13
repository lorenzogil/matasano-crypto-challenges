# http://cryptopals.com/sets/1/challenges/5/
from itertools import cycle, imap, izip, starmap
from operator import xor


def int2hex(integer):
    return '%0.2x' % integer


def hexencode(integers):
    hexdigits = imap(int2hex, integers)
    return ''.join(hexdigits)


def encrypt(plaintext, key):
    pairs = izip(imap(ord, plaintext), cycle(imap(ord, key)))
    cyphertext = starmap(xor, pairs)
    return hexencode(cyphertext)


if __name__ == '__main__':
    input = "Burning 'em, if you ain't quick and nimble\nI go crazy when I hear a cymbal"
    key = "ICE"
    print(encrypt(input, key))
