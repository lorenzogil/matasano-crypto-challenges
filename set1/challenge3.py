# http://cryptopals.com/sets/1/challenges/3/
from itertools import imap, izip_longest
from operator import itemgetter

# http://en.wikipedia.org/wiki/Etaoin_shrdlu
english_letter_frequency_lower = {
    'e': 13,
    't': 12,
    'a': 11,
    'o': 10,
    'i': 9,
    'n': 8,
    ' ': 7,
    's': 6,
    'r': 5,
    'h': 4,
    'd': 3,
    'l': 2,
    'u': 1,
}

english_letter_frequency_upper = {l.upper(): f for l, f in english_letter_frequency_lower.iteritems()}

english_letter_frequency = dict(english_letter_frequency_lower)
english_letter_frequency.update(english_letter_frequency_upper)

frequencies = [english_letter_frequency.get(chr(c), 0) for c in range(0, 256)]

def hex2int(chars):
    return int(''.join(chars), 16)


def hexdecode(input):
    args = [iter(input)] * 2
    hexdigits = izip_longest(fillvalue='', *args)
    return imap(hex2int, hexdigits)


def xor(data, key):
    return [a ^ b for a, b in izip_longest(data, [key], fillvalue=key)]


def stringify(ints):
    return ''.join([chr(i) for i in ints])


def score(candidate):
    result = sum([frequencies[c] for c in candidate])
    return (result, candidate)


def decrypt(input):
    decoded = list(hexdecode(input))
    candidates = [score(xor(decoded, key)) for key in range(0, 256)]
    sorted_candidates = sorted(candidates, key=itemgetter(0), reverse=True)
    best_score, solution = sorted_candidates[0]
    return stringify(solution)


if __name__ == '__main__':
    input = '1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736'
    print(decrypt(input))
