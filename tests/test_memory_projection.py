"""Exact small-integer oracles for PEF-05 projection obstructions."""
from itertools import product
import unittest


def mem(g):
    return g[0]+g[1]


def precondition(g):
    return (2*g[0],g[1])


def square(g):
    return g[0]*g[0]+g[1]*g[1]


class MemoryProjectionTests(unittest.TestCase):
    def test_orthogonality_is_not_metric_aware(self):
        g=(1,-1)
        self.assertEqual(mem(g),0)
        self.assertEqual(mem(precondition(g)),1)
        for x in range(-15,16):
            y=-x
            self.assertEqual(mem(precondition((x,y))),x)

    def test_general_fixed_diagonal_correction(self):
        for x,y,c in product(range(-5,6),repeat=3):
            if 2*x+y<=2*c:
                self.assertLessEqual(mem(precondition((x-c,y))),0)

    def test_norm_matched_vectors_differ_by_memory_direction(self):
        self.assertEqual(square((1,0)),square((0,1)))
        self.assertNotEqual((1,0)[0],(0,1)[0])

    def test_positive_aggregate_can_hide_negative_history_pair(self):
        vals=[4,-3]
        self.assertGreater(sum(vals),0)
        self.assertTrue(any(v<0 for v in vals))
        for length in range(5):
            for values in product(range(0,4),repeat=length):
                self.assertGreaterEqual(sum(values),0)


if __name__=="__main__":
    unittest.main()
