# http://cryptopals.com/sets/1/challenges/6/
from functools import partial
from itertools import chain, izip, izip_longest, starmap
from operator import itemgetter, xor

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


def read_file(filename):
    with open(filename, 'r') as f:
        return ''.join([line[:-1] for line in f.readlines()])


def pad(size, bits):
    padding = size - len(bits)
    return padding * [0] + bits


def int2bits(size, integer):
    result = []
    div, mod = divmod(integer, 2)
    result.append(mod)
    while div:
        div, mod = divmod(div, 2)
        result.append(mod)
    return pad(size, list(reversed(result)))


int2bits6 = partial(int2bits, 6)
int2bits8 = partial(int2bits, 8)


def char2intb64(char):
    if 'A' <= char <= 'Z':
        return ord(char) - 65
    elif 'a' <= char <= 'z':
        return ord(char) - 71
    elif '0' <= char <= '9':
        return ord(char) + 4
    elif '+' == char:
        return 62
    elif '/' == char:
        return 63
    else:
        raise ValueError('Invalid base64 char: %s' % char)


def bits2int(bits):
    size = len(bits) - 1
    return sum([b * 2 ** (size - i) for i, b in enumerate(bits)])


def b64(*chars):
    bits = chain(*[int2bits6(char2intb64(c)) for c in chars if c != '='])
    args = [iter(bits)] * 8
    return [bits2int(g) for g in izip(*args) if len(g) == 8]


def b64decode(input):
    args = [iter(input)] * 4
    groups = izip_longest(fillvalue='', *args)
    return chain(*starmap(b64, groups))


def hamming(a, b):
    abits = chain(*map(int2bits8, a))
    bbits = chain(*map(int2bits8, b))

    return sum(starmap(xor, zip(abits, bbits)))


def get_keysize(data):
    candidates = []
    for size in xrange(2, 40):
        args = [iter(data)] * size
        blocks = list(izip_longest(fillvalue=0, *args))
        n = len(blocks) - 1
        distances = sum([hamming(blocks[i], blocks[i+1]) for i in xrange(n)])
        average_distance = distances / float(n)
        normalized_distance = average_distance / size
        candidates.append((size, normalized_distance))

    sorted_candidates = sorted(candidates, key=itemgetter(1))
    return sorted_candidates[0][0]


def xor_list(data, key):
    return [a ^ b for a, b in izip(data, key)]


def score(block, key, size):
    result = sum([frequencies[c] for c in xor_list(block, [key] * size)])
    return (result, key)


def find_key(candidates):
    sorted_candidates = sorted(candidates, key=itemgetter(0), reverse=True)
    best_score, key = sorted_candidates[0]
    return key


def solve_single_xor(block):
    size = len(block)
    candidates = [score(block, key, size) for key in range(0, 256)]
    return find_key(candidates)


def stringify(ints):
    return ''.join([chr(i) for i in ints])


def decrypt(filename):
    # 1. decode the input
    encoded = read_file(filename)
    raw = list(b64decode(encoded))

    # 2. find the most likely key size
    keysize = get_keysize(raw)

    # 3. apply single xor to each transposed block to get the key
    args = [iter(raw)] * keysize
    blocks = izip_longest(fillvalue=0, *args)
    transposed = izip_longest(*blocks)
    key = [solve_single_xor(block) for block in transposed]

    # 4. decrypt the message with this key
    args = [iter(raw)] * keysize
    blocks = list(izip_longest(fillvalue=0, *args))
    decrypted = [stringify(xor_list(block, key)) for block in blocks]
    return ''.join(decrypted)


if __name__ == '__main__':
    input = '6.txt'
    print(decrypt(input))
