"""Standalone exact arithmetic checks for PEF-02S mixed schedule witnesses."""
from collections import defaultdict
from fractions import Fraction
from itertools import product
import unittest


def encoded_num(widths, bits):
    shift=total=0
    for k,b in zip(widths,bits):
        total += ((1<<k)-1)*b*(1<<shift)
        shift += k
    return total


def hull_gap(widths, t):
    groups=defaultdict(list)
    for bits in product((0,1),repeat=len(widths)):
        groups[bits[len(widths)-t:]].append(encoded_num(widths,bits))
    spans=sorted((min(v),max(v)) for v in groups.values())
    return Fraction(min(spans[i+1][0]-spans[i][1] for i in range(len(spans)-1)),
                    1<<sum(widths))


class PrecisionEntropyScheduleTests(unittest.TestCase):
    def test_exact_finite_gap_witnesses(self):
        self.assertEqual(hull_gap((2,2,4),2),Fraction(9,256))
        self.assertEqual(hull_gap((2,4,2),2),Fraction(57,256))
        self.assertEqual(encoded_num((2,2,4),(1,0,0)),3)
        self.assertEqual(encoded_num((2,2,4),(0,1,0)),12)
        self.assertEqual(encoded_num((2,4,2),(1,0,0)),3)
        self.assertEqual(encoded_num((2,4,2),(0,1,0)),60)

    def test_capacity_and_threshold(self):
        for widths,B,distinct in [
            ((2,2,4),6,4),((2,4,2),6,4),
            ((4,2,2),6,8),((4,2,2),4,4),
            ((4,2,2),5,8),((2,2,4),7,8)
        ]:
            codes={encoded_num(widths,bits)*(1<<B)//(1<<sum(widths))
                   for bits in product((0,1),repeat=3)}
            self.assertEqual(len(codes),distinct)

    def test_general_mixed_rational_gap(self):
        for depth in range(1,5):
            for widths in product((1,2,3),repeat=depth):
                total=sum(widths)
                for t in range(1,depth+1):
                    cumulative=0;terms=[]
                    for k in reversed(widths[-t:]):
                        cumulative+=k
                        terms.append(Fraction((1<<k)-2,1<<cumulative))
                    formula=Fraction(1,1<<total)+min(terms)
                    self.assertEqual(hull_gap(widths,t),formula)


if __name__=="__main__":
    unittest.main()
