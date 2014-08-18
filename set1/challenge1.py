# http://cryptopals.com/sets/1/challenges/1/
from itertools import chain, imap, izip_longest

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


def bits2int(bits):
    size = len(bits) - 1
    return sum([b * 2 ** (size - i) for i, b in enumerate(bits)])


def hex2int(chars):
    return int(''.join(chars), 16)


def int2base64(integer):
    if integer < 26:
        return chr(ord('A') + integer)
    elif integer < 52:
        return chr(ord('a') + integer - 26)
    elif integer < 62:
        return chr(ord('0') + integer - 52)
    elif integer == 62:
        return '+'
    else:
        return '/'


def hex2base64(input):
    args = [iter(input)] * 2
    hexdigits = izip_longest(fillvalue='', *args)
    integers = imap(hex2int, hexdigits)
    bytes_iter = imap(int2bits, integers)
    bitstream = chain(*bytes_iter)
    args = [iter(bitstream)] * 6
    sixchunks = izip_longest(fillvalue=0, *args)
    integers2 = imap(bits2int, sixchunks)
    base64 = imap(int2base64, integers2)
    result = ''.join(base64)
    return result


if __name__ == '__main__':
    input = '49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d'
    assert hex2base64(input) == 'SSdtIGtpbGxpbmcgeW91ciBicmFpbiBsaWtlIGEgcG9pc29ub3VzIG11c2hyb29t'