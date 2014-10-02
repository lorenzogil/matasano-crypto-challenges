# http://cryptopals.com/sets/1/challenges/2/
from itertools import imap, izip_longest, starmap


def hex2int(chars):
    return int(''.join(chars), 16)


def hexdecode(input):
    args = [iter(input)] * 2
    hexdigits = izip_longest(fillvalue='', *args)
    return imap(hex2int, hexdigits)


def int2hex(integer):
    return '%0.2x' % integer


def hexencode(integers):
    hexdigits = imap(int2hex, integers)
    return ''.join(hexdigits)


def hexxor(a, b):
    ad = hexdecode(a)
    bd = hexdecode(b)
    result = starmap(lambda a, b: a ^ b, izip_longest(ad, bd, fillvalue=0))
    return hexencode(result)


if __name__ == '__main__':
    inputs = (
        '1c0111001f010100061a024b53535009181c',
        '686974207468652062756c6c277320657965',
    )
    expected_output = '746865206b696420646f6e277420706c6179'
    assert hexxor(*inputs) == expected_output