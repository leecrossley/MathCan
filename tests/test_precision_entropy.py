"""Independent exact finite check for the PEF-01 encoder and decoder theorem."""
from fractions import Fraction
from itertools import product
import unittest


def encoder(k, bits):
    base = 1 << k
    return (base - 1) * sum(b * base**i for i, b in enumerate(bits))


def direct(k, bits):
    base = 1 << k
    x = Fraction(0)
    for bit in bits:
        x = (x + (base - 1) * bit) / base
    return x


def quantized(k, bits, precision):
    return ((1 << precision) * encoder(k, bits)) // ((1 << k)**len(bits))


class PrecisionEntropyTheoremTests(unittest.TestCase):
    def test_encoder_against_rational_affine_recurrence(self):
        for k in range(1, 5):
            for depth in range(0, 7):
                for history in product((0, 1), repeat=depth):
                    self.assertEqual(direct(k, history),
                                     Fraction(encoder(k, history), (1 << k)**depth))

    def test_exact_fibre_counts(self):
        for k in range(1, 5):
            for depth in range(0, 7):
                histories = list(product((0, 1), repeat=depth))
                for precision in range(0, k * depth + 3):
                    buckets = {}
                    suffix_to_code = {}
                    retained = min(depth, (precision + k - 1) // k)
                    for hist in histories:
                        code = quantized(k, hist, precision)
                        suffix = hist[depth-retained:] if retained else ()
                        buckets.setdefault(code, []).append(hist)
                        previous = suffix_to_code.setdefault(suffix, code)
                        self.assertEqual(previous, code)
                    self.assertEqual(len(buckets), 1 << retained)
                    self.assertEqual(len(suffix_to_code), 1 << retained)
                    self.assertEqual(len(set(suffix_to_code.values())), 1 << retained)
                    self.assertEqual({len(x) for x in buckets.values()},
                                     {1 << (depth-retained)})

    def test_depth_four_kernel_examples(self):
        self.assertEqual(len({quantized(2,h,3) for h in product((0,1),repeat=4)}),4)
        self.assertEqual(len({quantized(2,h,6) for h in product((0,1),repeat=4)}),8)
        self.assertEqual(len({quantized(2,h,7) for h in product((0,1),repeat=4)}),16)
        self.assertEqual(len({quantized(1,h,2) for h in product((0,1),repeat=4)}),4)


if __name__ == "__main__":
    unittest.main()
