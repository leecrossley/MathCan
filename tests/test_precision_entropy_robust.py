"""Independent standard-library integer/rational oracle for PEF-02 finite cases."""
import itertools
import unittest
from collections import defaultdict
from fractions import Fraction


def numerator(k, history):
    base = 1 << k
    return (base-1) * sum(bit*base**i for i,bit in enumerate(history))


def gap(k, depth, t):
    base=1<<k
    groups=defaultdict(list)
    for history in itertools.product((0,1),repeat=depth):
        groups[history[depth-t:]].append(numerator(k,history))
    spans=sorted((min(v),max(v)) for v in groups.values())
    return Fraction(min(spans[i+1][0]-spans[i][1]
                        for i in range(len(spans)-1)),base**depth)


def stage_floor(history, k, bits):
    base=1<<k
    state=0
    for bit in history:
        state=(state+(base-1)*(1<<bits)*bit)//base
    return state


def end_floor(history, k, bits):
    base=1<<k
    return numerator(k,history)*(1<<bits)//base**len(history)


class PrecisionEntropyRobustTests(unittest.TestCase):
    def test_minimum_gaps_and_exact_witness(self):
        for k in range(1,5):
            for depth in range(1,8):
                for t in range(1,depth+1):
                    base=1<<k
                    self.assertEqual(gap(k,depth,t),
                                     Fraction(base-2,base**t)+Fraction(1,base**depth))
        self.assertEqual(gap(2,4,2),Fraction(33,256))
        self.assertEqual(numerator(2,(1,1,0,0)),15)
        self.assertEqual(numerator(2,(0,0,1,0)),48)

    def test_exact_floor_stage_commutation(self):
        for k in range(1,4):
            for depth in range(0,7):
                for bits in range(0,10):
                    for history in itertools.product((0,1),repeat=depth):
                        self.assertEqual(stage_floor(history,k,bits),
                                         end_floor(history,k,bits))

    def test_exact_markov_three_source_example(self):
        weights=[]
        for history in itertools.product((0,1),repeat=3):
            w=(3 if history[0]==history[1] else 1)*(
               3 if history[1]==history[2] else 1)
            weights.append((history,w))
        self.assertEqual(sum(w for _,w in weights),32)
        self.assertEqual(sum(w for h,w in weights if h[-1]==0),16)
        self.assertEqual(sum(w for h,w in weights if h[-1]==1),16)
        self.assertEqual(sum(w for h,w in weights if h[-2]==h[-1]),24)
        self.assertEqual(sum(max(w for h,w in weights if h[-1]==b)
                             for b in (0,1)),18)


if __name__=="__main__":
    unittest.main()
