# http://cryptopals.com/sets/1/challenges/2/
from itertools import chain, imap, izip_longest, starmap

def pad8(bits):
    padding = 8 - len(bits)
    return padding * [0] + bits


def int2bits(integer):
    result = []
    div, mod = divmod(integer, 2)
    result.append(mod)
    while div:
        div, mod = divmod(div, 2)
        result.append(mod)
    return pad8(list(reversed(result)))


def hex2int(chars):
    return int(''.join(chars), 16)


def hexdecode(input):
    args = [iter(input)] * 2
    hexdigits = izip_longest(fillvalue='', *args)
    integers = imap(hex2int, hexdigits)
    bytes_iter = imap(int2bits, integers)
    return chain(*bytes_iter)


def bits2int(bits):
    size = len(bits) - 1
    return sum([b * 2 ** (size - i) for i, b in enumerate(bits)])


def int2hex(integer):
    return '%0.2x' % integer


def hexencode(bits):
    args = [iter(bits)] * 8
    octects = izip_longest(fillvalue=0, *args)
    integers = imap(bits2int, octects)
    hexdigits = imap(int2hex, integers)
    return ''.join(hexdigits)


def bitsxor(bit1, bit2):
    return bit1 ^ bit2


def hexxor(a, b):
    ad = hexdecode(a)
    bd = hexdecode(b)
    result = starmap(bitsxor, izip_longest(ad, bd, fillvalue=0))
    return hexencode(result)


if __name__ == '__main__':
    inputs = (
        '1c0111001f010100061a024b53535009181c',
        '686974207468652062756c6c277320657965',
    )
    expected_output = '746865206b696420646f6e277420706c6179'
    assert hexxor(*inputs) == expected_output